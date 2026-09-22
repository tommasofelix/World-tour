# res://ui/hud/hud.gd
extends Control

## Controller della Schermata Principale (HUD) di World-tour
## Implementa l'architettura a Layer Differenziati per Simmetria Universale (Luca & Holy Diver)
## e supporta la localizzazione dinamica multilingua (i18n).

@onready var label_time: Label = $VBoxMain/PanelTop/HBoxTop/LabelTime
@onready var label_energy: Label = $VBoxMain/PanelTop/HBoxTop/LabelEnergy
@onready var label_money: Label = $VBoxMain/PanelTop/HBoxTop/LabelMoney
@onready var label_status: Label = $VBoxMain/PanelCenter/LabelStatus
@onready var btn_practice: Button = $VBoxMain/PanelCenter/HBoxActions/BtnPractice
@onready var btn_catalog: Button = $VBoxMain/PanelCenter/HBoxActions/BtnCatalog
@onready var btn_new_song: Button = $VBoxMain/PanelCenter/HBoxActions/BtnNewSong
@onready var btn_pause: Button = $VBoxMain/PanelCenter/HBoxActions/BtnPause
@onready var btn_save: Button = $VBoxMain/PanelCenter/HBoxActions/BtnSave
@onready var btn_main_menu: Button = $VBoxMain/PanelCenter/HBoxActions/BtnMainMenu

@onready var song_catalog_modal: Control = $SongCatalog
@onready var song_creator_modal: Control = $SongCreator

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
	btn_practice.pressed.connect(_on_btn_practice_pressed)
	btn_catalog.pressed.connect(open_catalog)
	btn_new_song.pressed.connect(open_song_creator)
	btn_pause.pressed.connect(_on_btn_pause_pressed)
	btn_save.pressed.connect(_on_btn_save_pressed)
	btn_main_menu.pressed.connect(_on_btn_main_menu_pressed)
	
	# Connessione modali musicali
	song_catalog_modal.closed.connect(close_catalog)
	song_catalog_modal.new_song_requested.connect(_on_catalog_new_song_requested)
	song_creator_modal.creation_finished.connect(_on_song_created_or_finished)
	song_creator_modal.creation_canceled.connect(close_song_creator)
	
	# Connessione EventBus
	EventBus.time_ticked.connect(_on_time_ticked)
	EventBus.action_started.connect(_on_action_started)
	EventBus.action_progress.connect(_on_action_progress)
	EventBus.action_completed.connect(_on_action_completed)
	EventBus.money_changed.connect(_on_money_changed)
	EventBus.language_changed.connect(_on_language_changed)
	EventBus.song_catalog_requested.connect(open_catalog)
	EventBus.song_creator_requested.connect(open_song_creator)
	
	# Configurazione semantica AccessKit e testi iniziali
	_refresh_ui_text()
	_update_hud_display()
	
	# Auto-focus sul primo elemento utile
	btn_practice.grab_focus()

func _process(delta: float) -> void:
	if GameManager.time_system:
		GameManager.time_system.advance_time(delta)
	if action_system and action_system.is_running:
		action_system.update_action(delta)

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
	btn_practice.text = tr("HUD_BTN_PRACTICE")
	btn_catalog.text = tr("HUD_BTN_CATALOG")
	btn_new_song.text = tr("HUD_BTN_NEW_SONG")
	var is_paused: bool = GameManager.time_system.is_paused if GameManager.time_system else false
	btn_pause.text = tr("HUD_BTN_RESUME") if is_paused else tr("HUD_BTN_PAUSE")
	btn_save.text = tr("HUD_BTN_SAVE")
	btn_main_menu.text = tr("HUD_BTN_MAIN_MENU")
	
	# Hook AccessKit semantici per NVDA
	AccessibilityManager.hook_control_accessibility(btn_practice, tr("HUD_BTN_PRACTICE_ACC_NAME"), tr("HUD_BTN_PRACTICE_ACC_DESC"))
	AccessibilityManager.hook_control_accessibility(btn_catalog, tr("HUD_BTN_CATALOG_ACC_NAME"), tr("HUD_BTN_CATALOG_ACC_DESC"))
	AccessibilityManager.hook_control_accessibility(btn_new_song, tr("HUD_BTN_NEW_SONG_ACC_NAME"), tr("HUD_BTN_NEW_SONG_ACC_DESC"))
	AccessibilityManager.hook_control_accessibility(btn_pause, tr("HUD_BTN_PAUSE_ACC_NAME"), tr("HUD_BTN_PAUSE_ACC_DESC"))
	AccessibilityManager.hook_control_accessibility(btn_save, tr("HUD_BTN_SAVE_ACC_NAME"), tr("HUD_BTN_SAVE_ACC_DESC"))
	AccessibilityManager.hook_control_accessibility(btn_main_menu, tr("HUD_BTN_MAIN_MENU_ACC_NAME"), tr("HUD_BTN_MAIN_MENU_ACC_DESC"))
	
	if not action_system or not action_system.is_running:
		label_status.text = tr("HUD_STATUS_IDLE")

func open_catalog() -> void:
	if song_creator_modal.visible:
		close_song_creator()
	song_catalog_modal.visible = true
	song_catalog_modal.refresh_catalog()
	GameManager.open_menu()

func close_catalog() -> void:
	song_catalog_modal.visible = false
	GameManager.close_menu()
	btn_catalog.grab_focus()

func open_song_creator() -> void:
	if song_catalog_modal.visible:
		close_catalog()
	song_creator_modal.visible = true
	song_creator_modal.start_new_song()
	GameManager.open_menu()

func close_song_creator() -> void:
	song_creator_modal.visible = false
	GameManager.close_menu()
	btn_new_song.grab_focus()

func _on_catalog_new_song_requested() -> void:
	close_catalog()
	open_song_creator()

func _on_song_created_or_finished(_song: SongData) -> void:
	close_song_creator()
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
		label_money.text = tr("HUD_MONEY") % GameManager.player_data.money

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
