# res://ui/hud/hud.gd
extends Control

## Controller della Schermata Principale (HUD) di World-tour
## Implementa l'architettura a Layer Differenziati per Simmetria Universale (Luca & Holy Diver)
## e supporta la localizzazione dinamica multilingua (i18n).

@onready var vbox_main: VBoxContainer = $VBoxMain
@onready var label_time: Label = $VBoxMain/PanelTop/HBoxTop/LabelTime
@onready var label_energy: Label = $VBoxMain/PanelTop/HBoxTop/LabelEnergy
@onready var label_stress: Label = $VBoxMain/PanelTop/HBoxTop/LabelStress
@onready var label_morale: Label = $VBoxMain/PanelTop/HBoxTop/LabelMorale
@onready var label_money: Label = $VBoxMain/PanelTop/HBoxTop/LabelMoney
@onready var btn_speed: Button = $VBoxMain/PanelTop/HBoxTop/BtnSpeed
@onready var btn_pause: Button = $VBoxMain/PanelTop/HBoxTop/BtnPause
@onready var btn_save: Button = $VBoxMain/PanelTop/HBoxTop/BtnSave
@onready var btn_main_menu: Button = $VBoxMain/PanelTop/HBoxTop/BtnMainMenu

@onready var label_player_summary: Label = $VBoxMain/PanelPlayerOverview/Margin/LabelPlayerSummary
@onready var label_status: Label = $VBoxMain/PanelCenter/LabelStatus
@onready var btn_character: Button = $VBoxMain/PanelCenter/HBoxActions/BtnCharacter
@onready var btn_practice: Button = $VBoxMain/PanelCenter/HBoxActions/BtnPractice
@onready var btn_catalog: Button = $VBoxMain/PanelCenter/HBoxActions/BtnCatalog
@onready var btn_new_song: Button = $VBoxMain/PanelCenter/HBoxActions/BtnNewSong
@onready var btn_concert: Button = $VBoxMain/PanelCenter/HBoxActions/BtnConcert
@onready var btn_economy: Button = $VBoxMain/PanelCenter/HBoxActions/BtnEconomy

@onready var song_catalog_modal: Control = $SongCatalog
@onready var song_creator_modal: Control = $SongCreator
@onready var live_concert_modal: Control = $LiveConcert
@onready var economy_bank_modal: Control = $EconomyBank
@onready var daily_summary_modal: Control = $DailySummary
@onready var character_sheet_modal: Control = $CharacterSheet

var action_system: ActionSystem
var quick_practice_action: ActionData

func _ready() -> void:
	# Inizializzazione azione rapida
	quick_practice_action = ActionData.new(
		"quick_practice",
		tr("ACTION_QUICK_PRACTICE"),
		10.0,
		15,
		5,
		10.0,
		"instrument"
	)
	
	action_system = ActionSystem.new(GameManager.player_data, GameManager.calendar_data)
	if GameManager.current_state == Enums.GameState.BOOT or GameManager.current_state == Enums.GameState.MAIN_MENU:
		GameManager.change_state(Enums.GameState.GAMEPLAY_IDLE)
	
	# Impostazione Live Region per l'orologio (annuncio dinamico senza spostare il focus)
	label_time.set_accessibility_live(Constants.ACCESSIBILITY_LIVE_POLITE)
	label_status.set_accessibility_live(Constants.ACCESSIBILITY_LIVE_ASSERTIVE)
	
	# Connessione eventi UI
	btn_character.pressed.connect(open_character_sheet)
	btn_practice.pressed.connect(_on_btn_practice_pressed)
	btn_catalog.pressed.connect(open_catalog)
	btn_new_song.pressed.connect(open_song_creator)
	btn_concert.pressed.connect(open_live_concert)
	btn_economy.pressed.connect(open_economy_bank)
	btn_speed.pressed.connect(_on_btn_speed_pressed)
	btn_pause.pressed.connect(_on_btn_pause_pressed)
	btn_save.pressed.connect(_on_btn_save_pressed)
	btn_main_menu.pressed.connect(_on_btn_main_menu_pressed)
	
	# Connessione modali musicali, concerti, economia e scheda personaggio
	song_catalog_modal.closed.connect(close_catalog)
	song_catalog_modal.new_song_requested.connect(_on_catalog_new_song_requested)
	song_catalog_modal.edit_song_requested.connect(open_song_editor)
	song_creator_modal.creation_finished.connect(_on_song_created_or_finished)
	song_creator_modal.creation_canceled.connect(close_song_creator)
	live_concert_modal.closed.connect(close_live_concert)
	live_concert_modal.concert_completed.connect(_on_concert_completed)
	economy_bank_modal.closed.connect(close_economy_bank)
	if daily_summary_modal:
		daily_summary_modal.day_advanced.connect(_on_day_advanced)
	if character_sheet_modal:
		character_sheet_modal.closed.connect(close_character_sheet)
		
	# Connessione Fine Giornata (EndDaySystem)
	if GameManager:
		if not GameManager.end_day_system and GameManager.player_data and GameManager.calendar_data:
			GameManager.end_day_system = EndDaySystem.new(GameManager.player_data, GameManager.calendar_data)
		if GameManager.end_day_system:
			GameManager.end_day_system.summary_ready.connect(open_daily_summary)
		if GameManager.player_data and GameManager.player_data.songs.is_empty():
			GameManager.player_data.populate_starter_test_songs()
	
	# Connessione EventBus
	EventBus.time_ticked.connect(_on_time_ticked)
	EventBus.speed_changed.connect(_on_speed_changed)
	EventBus.action_started.connect(_on_action_started)
	EventBus.action_progress.connect(_on_action_progress)
	EventBus.action_completed.connect(_on_action_completed)
	EventBus.money_changed.connect(_on_money_changed)
	EventBus.language_changed.connect(_on_language_changed)
	EventBus.song_catalog_requested.connect(open_catalog)
	EventBus.song_creator_requested.connect(open_song_creator)
	EventBus.live_concert_requested.connect(open_live_concert)
	EventBus.economy_screen_requested.connect(open_economy_bank)
	
	# Configurazione semantica AccessKit e testi iniziali
	_refresh_ui_text()
	_update_hud_display()
	
	# Auto-focus sul primo elemento utile
	btn_character.grab_focus()

func _process(delta: float) -> void:
	if GameManager.time_system:
		GameManager.time_system.advance_time(delta)
	if action_system and action_system.is_running:
		action_system.update_action(delta)

func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventKey) or not event.is_pressed() or event.is_echo():
		return
	
	# Se una modale è aperta, non intercettare scorciatoie di navigazione HUD
	if (song_catalog_modal and song_catalog_modal.visible) or \
	   (song_creator_modal and song_creator_modal.visible) or \
	   (live_concert_modal and live_concert_modal.visible) or \
	   (economy_bank_modal and economy_bank_modal.visible) or \
	   (daily_summary_modal and daily_summary_modal.visible) or \
	   (character_sheet_modal and character_sheet_modal.visible):
		return
	
	match event.keycode:
		KEY_C:
			open_character_sheet()
			get_viewport().set_input_as_handled()
		KEY_L:
			open_live_concert()
			get_viewport().set_input_as_handled()
		KEY_M:
			open_catalog()
			get_viewport().set_input_as_handled()
		KEY_N:
			open_song_creator()
			get_viewport().set_input_as_handled()
		KEY_B:
			open_economy_bank()
			get_viewport().set_input_as_handled()
		KEY_T:
			_on_btn_speed_pressed()
			get_viewport().set_input_as_handled()
		KEY_P:
			_on_btn_pause_pressed()
			get_viewport().set_input_as_handled()

func _get_localized_period(period: int) -> String:
	match period:
		Enums.TimePeriod.MORNING:
			return tr("PERIOD_MORNING")
		Enums.TimePeriod.AFTERNOON:
			return tr("PERIOD_AFTERNOON")
		Enums.TimePeriod.EVENING:
			return tr("PERIOD_EVENING")
		Enums.TimePeriod.NIGHT:
			return tr("PERIOD_NIGHT")
		_:
			return tr("PERIOD_MORNING")

func _refresh_ui_text() -> void:
	# Testi pulsanti
	btn_character.text = tr("HUD_BTN_CHARACTER")
	btn_practice.text = tr("HUD_BTN_PRACTICE")
	btn_catalog.text = tr("HUD_BTN_CATALOG")
	btn_new_song.text = tr("HUD_BTN_NEW_SONG")
	btn_concert.text = tr("HUD_BTN_CONCERT")
	btn_economy.text = tr("HUD_BTN_ECONOMY")
	
	var current_spd: float = GameManager.time_system.time_scale if GameManager and GameManager.time_system else 1.0
	btn_speed.text = tr("HUD_BTN_SPEED") % current_spd
	
	var is_paused: bool = GameManager.time_system.is_paused if GameManager.time_system else false
	btn_pause.text = tr("HUD_BTN_RESUME") if is_paused else tr("HUD_BTN_PAUSE")
	btn_save.text = tr("HUD_BTN_SAVE")
	btn_main_menu.text = tr("HUD_BTN_MAIN_MENU")
	
	# Hook AccessKit semantici per NVDA
	AccessibilityManager.hook_control_accessibility(btn_character, tr("HUD_BTN_CHARACTER_ACC_NAME"), tr("HUD_BTN_CHARACTER_ACC_DESC"))
	AccessibilityManager.hook_control_accessibility(btn_practice, tr("HUD_BTN_PRACTICE_ACC_NAME"), tr("HUD_BTN_PRACTICE_ACC_DESC"))
	AccessibilityManager.hook_control_accessibility(btn_catalog, tr("HUD_BTN_CATALOG_ACC_NAME"), tr("HUD_BTN_CATALOG_ACC_DESC"))
	AccessibilityManager.hook_control_accessibility(btn_new_song, tr("HUD_BTN_NEW_SONG_ACC_NAME"), tr("HUD_BTN_NEW_SONG_ACC_DESC"))
	AccessibilityManager.hook_control_accessibility(btn_concert, tr("HUD_BTN_CONCERT_ACC_NAME"), tr("HUD_BTN_CONCERT_ACC_DESC"))
	AccessibilityManager.hook_control_accessibility(btn_economy, tr("HUD_BTN_ECONOMY_ACC_NAME"), tr("HUD_BTN_ECONOMY_ACC_DESC"))
	AccessibilityManager.hook_control_accessibility(btn_speed, tr("HUD_BTN_SPEED_ACC_NAME"), tr("HUD_BTN_SPEED_ACC_DESC"))
	AccessibilityManager.hook_control_accessibility(btn_pause, tr("HUD_BTN_PAUSE_ACC_NAME"), tr("HUD_BTN_PAUSE_ACC_DESC"))
	AccessibilityManager.hook_control_accessibility(btn_save, tr("HUD_BTN_SAVE_ACC_NAME"), tr("HUD_BTN_SAVE_ACC_DESC"))
	AccessibilityManager.hook_control_accessibility(btn_main_menu, tr("HUD_BTN_MAIN_MENU_ACC_NAME"), tr("HUD_BTN_MAIN_MENU_ACC_DESC"))
	
	if not action_system or not action_system.is_running:
		label_status.text = tr("HUD_STATUS_IDLE")

func _on_btn_speed_pressed() -> void:
	if GameManager and GameManager.time_system:
		var new_spd: float = GameManager.time_system.cycle_speed()
		btn_speed.text = tr("HUD_BTN_SPEED") % new_spd
		var msg: String = tr("HUD_SPEED_CHANGED") % new_spd
		AccessibilityManager.announce(msg, true)

func _on_speed_changed(new_speed: float) -> void:
	btn_speed.text = tr("HUD_BTN_SPEED") % new_speed

func open_catalog() -> void:
	if song_creator_modal.visible:
		song_creator_modal.visible = false
	if live_concert_modal.visible:
		live_concert_modal.visible = false
	if economy_bank_modal.visible:
		economy_bank_modal.visible = false
	if character_sheet_modal and character_sheet_modal.visible:
		character_sheet_modal.visible = false
	if vbox_main:
		vbox_main.visible = false
	song_catalog_modal.visible = true
	song_catalog_modal.refresh_catalog()
	GameManager.open_menu()

func close_catalog() -> void:
	song_catalog_modal.visible = false
	if vbox_main:
		vbox_main.visible = true
	GameManager.close_menu()
	btn_catalog.grab_focus()

func open_song_creator() -> void:
	if song_catalog_modal.visible:
		song_catalog_modal.visible = false
	if live_concert_modal.visible:
		live_concert_modal.visible = false
	if economy_bank_modal.visible:
		economy_bank_modal.visible = false
	if character_sheet_modal and character_sheet_modal.visible:
		character_sheet_modal.visible = false
	if vbox_main:
		vbox_main.visible = false
	song_creator_modal.visible = true
	song_creator_modal.start_new_song()
	GameManager.open_menu()

func close_song_creator() -> void:
	song_creator_modal.visible = false
	if vbox_main:
		vbox_main.visible = true
	GameManager.close_menu()
	btn_new_song.grab_focus()

func open_song_editor(song: SongData) -> void:
	if song_catalog_modal.visible:
		song_catalog_modal.visible = false
	if live_concert_modal.visible:
		live_concert_modal.visible = false
	if economy_bank_modal.visible:
		economy_bank_modal.visible = false
	if character_sheet_modal and character_sheet_modal.visible:
		character_sheet_modal.visible = false
	if vbox_main:
		vbox_main.visible = false
	song_creator_modal.visible = true
	song_creator_modal.edit_existing_song(song)
	GameManager.open_menu()

func open_live_concert() -> void:
	if song_catalog_modal.visible:
		song_catalog_modal.visible = false
	if song_creator_modal.visible:
		song_creator_modal.visible = false
	if economy_bank_modal.visible:
		economy_bank_modal.visible = false
	if character_sheet_modal and character_sheet_modal.visible:
		character_sheet_modal.visible = false
	if vbox_main:
		vbox_main.visible = false
	live_concert_modal.visible = true
	live_concert_modal.open_preparation()
	GameManager.open_menu()

func close_live_concert() -> void:
	live_concert_modal.visible = false
	if vbox_main:
		vbox_main.visible = true
	GameManager.close_menu()
	btn_concert.grab_focus()
	_update_hud_display()

func open_economy_bank() -> void:
	if song_catalog_modal.visible:
		song_catalog_modal.visible = false
	if song_creator_modal.visible:
		song_creator_modal.visible = false
	if live_concert_modal.visible:
		live_concert_modal.visible = false
	if character_sheet_modal and character_sheet_modal.visible:
		character_sheet_modal.visible = false
	if vbox_main:
		vbox_main.visible = false
	economy_bank_modal.open()
	GameManager.open_menu()

func close_economy_bank() -> void:
	economy_bank_modal.visible = false
	if vbox_main:
		vbox_main.visible = true
	GameManager.close_menu()
	btn_economy.grab_focus()
	_update_hud_display()

func open_character_sheet() -> void:
	if song_catalog_modal and song_catalog_modal.visible:
		song_catalog_modal.visible = false
	if song_creator_modal and song_creator_modal.visible:
		song_creator_modal.visible = false
	if live_concert_modal and live_concert_modal.visible:
		live_concert_modal.visible = false
	if economy_bank_modal and economy_bank_modal.visible:
		economy_bank_modal.visible = false
	if daily_summary_modal and daily_summary_modal.visible:
		daily_summary_modal.visible = false
	if vbox_main:
		vbox_main.visible = false
	if character_sheet_modal:
		character_sheet_modal.open()
	GameManager.open_menu()

func close_character_sheet() -> void:
	if character_sheet_modal:
		character_sheet_modal.visible = false
	if vbox_main:
		vbox_main.visible = true
	GameManager.close_menu()
	btn_character.grab_focus()
	_update_hud_display()

func open_daily_summary(summary_data: Dictionary) -> void:
	if song_catalog_modal.visible:
		song_catalog_modal.visible = false
	if song_creator_modal.visible:
		song_creator_modal.visible = false
	if live_concert_modal.visible:
		live_concert_modal.visible = false
	if economy_bank_modal.visible:
		economy_bank_modal.visible = false
	if character_sheet_modal and character_sheet_modal.visible:
		character_sheet_modal.visible = false
	if vbox_main:
		vbox_main.visible = false
	if daily_summary_modal:
		daily_summary_modal.show_summary(summary_data)

func _on_day_advanced() -> void:
	if daily_summary_modal:
		daily_summary_modal.visible = false
	if vbox_main:
		vbox_main.visible = true
	_update_hud_display()
	btn_practice.grab_focus()

func _on_concert_completed(_result: Dictionary) -> void:
	_update_hud_display()

func _on_catalog_new_song_requested() -> void:
	song_catalog_modal.visible = false
	open_song_creator()

func _on_song_created_or_finished(_song: SongData) -> void:
	song_creator_modal.visible = false
	open_catalog()

func _update_hud_display() -> void:
	if GameManager.calendar_data:
		var t_str: String = GameManager.calendar_data.get_formatted_time_string()
		var p_str: String = _get_localized_period(GameManager.calendar_data.current_period)
		var d_num: int = GameManager.calendar_data.day_number
		label_time.text = tr("HUD_CLOCK") % [d_num, t_str, p_str]
		label_time.set_accessibility_name(tr("HUD_CLOCK_ACCESSIBILITY") % [d_num, t_str, p_str])
		
	if GameManager.player_data:
		label_energy.text = tr("HUD_ENERGY") % GameManager.player_data.energy
		if label_stress:
			label_stress.text = tr("HUD_STRESS") % GameManager.player_data.stress
		if label_morale:
			label_morale.text = tr("HUD_MORALE") % GameManager.player_data.morale
		label_money.text = tr("HUD_MONEY") % GameManager.player_data.money
		
		if label_player_summary:
			var skills_summary: String = ""
			if GameManager.skill_system:
				var summaries: Array[Dictionary] = GameManager.skill_system.get_all_skills_summary()
				var parts: Array[String] = []
				for s in summaries:
					parts.append("%s L%d" % [s["name"], s["level"]])
				skills_summary = ", ".join(parts)
			else:
				skills_summary = "Strumento L10"
			
			var tier_name: String = "Principiante"
			if GameManager.career_system:
				tier_name = GameManager.career_system.get_tier_name(GameManager.player_data.career_tier)
				
			label_player_summary.text = tr("HUD_PLAYER_SUMMARY") % [
				GameManager.player_data.player_name,
				GameManager.player_data.get_background_name(),
				tier_name,
				skills_summary
			]

func _on_time_ticked(_remaining_sec: float, _time_str: String, _period: int) -> void:
	_update_hud_display()

func _on_btn_practice_pressed() -> void:
	if action_system:
		action_system.start_action(quick_practice_action)

func _on_btn_pause_pressed() -> void:
	if GameManager.time_system:
		var paused: bool = GameManager.time_system.toggle_pause()
		btn_pause.text = tr("HUD_BTN_RESUME") if paused else tr("HUD_BTN_PAUSE")

func _on_btn_save_pressed() -> void:
	SaveManager.save_game()

func _on_btn_main_menu_pressed() -> void:
	# Salva la partita se possibile e ritorna al menu principale
	if SaveManager.is_save_allowed():
		SaveManager.save_game()
	get_tree().change_scene_to_file("res://ui/main_menu/main_menu.tscn")

func _on_action_started(action_id: String, _duration: float) -> void:
	var act_name: String = tr("ACTION_QUICK_PRACTICE") if action_id == "quick_practice" else action_id
	label_status.text = tr("HUD_STATUS_BUSY") % act_name
	btn_practice.disabled = true

func _on_action_progress(_action_id: String, elapsed: float, duration: float) -> void:
	var progress_pct: int = int(round((elapsed / duration) * 100.0))
	label_status.text = tr("HUD_STATUS_PROGRESS") % progress_pct

func _on_action_completed(_action_id: String, rewards: Dictionary) -> void:
	label_status.text = tr("HUD_STATUS_COMPLETED") % rewards.get("xp_gained", 0.0)
	btn_practice.disabled = false
	_update_hud_display()

func _on_money_changed(_new_bal: float, _delta: float, _reason: String) -> void:
	_update_hud_display()

func _on_language_changed(_new_lang: String) -> void:
	_refresh_ui_text()
	_update_hud_display()
