# res://ui/apartment_hud/apartment_hud.gd
class_name ApartmentHud
extends Control

## In-Game HUD Sovrimpresso in Pixel Art Retrò Arcade (V5.5.0)
## Fedele al concept visuale e all'architettura di Simmetria Universale (Luca & Holy Diver).
## Gestisce le barre vitali dinamiche con icone (Energia, Stress, Morale), l'inspection dialogue box
## con ritratti reattivi allo stato emotivo di Alex, l'indicatore meteo/tempo, economia e dock macro-categorie.

signal modal_opened(modal_name: String)
signal modal_closed(modal_name: String)
signal interaction_menu_opened(prop_id: String)
signal interaction_menu_closed()

# Preload Texture Pixel Art Ritratti Alex
const TEX_ALEX_NORMALE = preload("res://assets/img/gameplay/GUI/Portrait/Alex/alex_normale.png")
const TEX_ALEX_TRISTE = preload("res://assets/img/gameplay/GUI/Portrait/Alex/alex_triste.png")
const TEX_ALEX_ARRABBIATO = preload("res://assets/img/gameplay/GUI/Portrait/Alex/alex_arrabbiato.png")
const TEX_ALEX_DISPERATO = preload("res://assets/img/gameplay/GUI/Portrait/Alex/alex_disperato.png")

# Preload Texture Pixel Art Risorse & Status
const TEX_LIVELLO = preload("res://assets/img/gameplay/GUI/Elementi/Livello_Personaggio.png")
const TEX_ENERGIA = preload("res://assets/img/gameplay/GUI/Elementi/Energia.png")
const TEX_STRESS_NORMALE = preload("res://assets/img/gameplay/GUI/Elementi/Stress_nomrale.png")
const TEX_STRESS_CRITICO = preload("res://assets/img/gameplay/GUI/Elementi/Stress_critico.png")
const TEX_MORALE_NORMALE = preload("res://assets/img/gameplay/GUI/Elementi/Morale_Normale.png")
const TEX_MORALE_CRITICO = preload("res://assets/img/gameplay/GUI/Elementi/Morale_Critico.png")

# Preload Texture Meteo & Tempo
const TEX_MATTINO = preload("res://assets/img/gameplay/GUI/Elementi/Mattino.png")
const TEX_POMERIGGIO = preload("res://assets/img/gameplay/GUI/Elementi/Pomeriggio.png")
const TEX_TRAMONTO = preload("res://assets/img/gameplay/GUI/Elementi/Tramonto.png")
const TEX_NOTTE = preload("res://assets/img/gameplay/GUI/Elementi/Notte.png")

# Preload Texture Economia & Mappa
const TEX_POCHI_SOLDI = preload("res://assets/img/gameplay/GUI/Elementi/pochi_soldi.png")
const TEX_MOLTI_SOLDI = preload("res://assets/img/gameplay/GUI/Elementi/Molti_Soldi.png")
const TEX_MAPPA = preload("res://assets/img/gameplay/GUI/Elementi/Mappa.png")

# Preload Texture Dock Categorie
const TEX_DOCK_PERSONALE = preload("res://assets/img/gameplay/GUI/Elementi/Personale.png")
const TEX_DOCK_CREAZIONE = preload("res://assets/img/gameplay/GUI/Elementi/Creazione.png")
const TEX_DOCK_CARRIERA = preload("res://assets/img/gameplay/GUI/Elementi/Carriera.png")
const TEX_DOCK_STRUMENTI = preload("res://assets/img/gameplay/GUI/Elementi/Strumenti.png")
const TEX_DOCK_BAND = preload("res://assets/img/gameplay/GUI/Elementi/band_icon.png")

# Preload Texture Controlli Tempo
const TEX_BTN_RIPRENDI = preload("res://assets/img/gameplay/GUI/Elementi/Pulsante_Riprendi.png")
const TEX_BTN_TEMPO_X2 = preload("res://assets/img/gameplay/GUI/Elementi/Pulsante_tempo_x2.png")

# Preload Componenti Selettori Accessibili
const InstrumentPracticePicker = preload("res://ui/interaction_menu/instrument_practice_picker.gd")
const SkillStudyPicker = preload("res://ui/interaction_menu/skill_study_picker.gd")

# Top Bar / Profile
@onready var label_level: Label = get_node_or_null("TopLeftProfile/HBox/VBox/HBoxLevel/LabelLevel") if has_node("TopLeftProfile/HBox/VBox/HBoxLevel/LabelLevel") else get_node_or_null("TopLeftProfile/HBox/VBox/LabelLevel")
@onready var texture_level_icon: TextureRect = get_node_or_null("TopLeftProfile/HBox/VBox/HBoxLevel/TextureLevelIcon")
@onready var bar_energy: ProgressBar = get_node_or_null("TopLeftProfile/HBox/VBox/HBoxEnergy/BarEnergy") if has_node("TopLeftProfile/HBox/VBox/HBoxEnergy/BarEnergy") else get_node_or_null("TopLeftProfile/HBox/VBox/BarEnergy")
@onready var label_energy_val: Label = get_node_or_null("TopLeftProfile/HBox/VBox/HBoxEnergy/LabelEnergyVal")
@onready var texture_energy_icon: TextureRect = get_node_or_null("TopLeftProfile/HBox/VBox/HBoxEnergy/TextureEnergyIcon")

@onready var bar_stress: ProgressBar = get_node_or_null("TopLeftProfile/HBox/VBox/HBoxStress/BarStress") if has_node("TopLeftProfile/HBox/VBox/HBoxStress/BarStress") else get_node_or_null("TopLeftProfile/HBox/VBox/BarStress")
@onready var label_stress_val: Label = get_node_or_null("TopLeftProfile/HBox/VBox/HBoxStress/LabelStressVal")
@onready var texture_stress_icon: TextureRect = get_node_or_null("TopLeftProfile/HBox/VBox/HBoxStress/TextureStressIcon")

@onready var bar_morale: ProgressBar = get_node_or_null("TopLeftProfile/HBox/VBox/HBoxMorale/BarMorale") if has_node("TopLeftProfile/HBox/VBox/HBoxMorale/BarMorale") else get_node_or_null("TopLeftProfile/HBox/VBox/BarMorale")
@onready var label_morale_val: Label = get_node_or_null("TopLeftProfile/HBox/VBox/HBoxMorale/LabelMoraleVal")
@onready var texture_morale_icon: TextureRect = get_node_or_null("TopLeftProfile/HBox/VBox/HBoxMorale/TextureMoraleIcon")

@onready var texture_portrait_top: TextureRect = get_node_or_null("TopLeftProfile/HBox/PortraitFrame/TexturePortraitTop")

# Top Right Date / Time
@onready var label_datetime: Label = get_node_or_null("TopRightTime/VBoxTime/HBoxDate/LabelDateTime") if has_node("TopRightTime/VBoxTime/HBoxDate/LabelDateTime") else get_node_or_null("TopRightTime/VBoxTime/LabelDateTime")
@onready var label_period: Label = get_node_or_null("TopRightTime/VBoxTime/HBoxPeriod/LabelPeriod") if has_node("TopRightTime/VBoxTime/HBoxPeriod/LabelPeriod") else get_node_or_null("TopRightTime/VBoxTime/LabelPeriod")
@onready var texture_period_icon: TextureRect = get_node_or_null("TopRightTime/VBoxTime/HBoxPeriod/TexturePeriodIcon")
@onready var btn_time_pause: Button = get_node_or_null("TopRightTime/VBoxTime/HBoxTimeControls/BtnTimePause")
@onready var btn_time_speed: Button = get_node_or_null("TopRightTime/VBoxTime/HBoxTimeControls/BtnTimeSpeed")
@onready var btn_time_sleep: Button = get_node_or_null("TopRightTime/VBoxTime/HBoxTimeControls/BtnTimeSleep")

# Bottom Left Inspection Dialogue Box
@onready var panel_dialogue: PanelContainer = get_node_or_null("BottomLeftDialogue")
@onready var label_speaker: Label = get_node_or_null("BottomLeftDialogue/Margin/HBox/VBox/LabelSpeaker")
@onready var label_text: Label = get_node_or_null("BottomLeftDialogue/Margin/HBox/VBox/LabelText")
@onready var label_hint: Label = get_node_or_null("BottomLeftDialogue/Margin/HBox/VBox/LabelHint")
@onready var texture_portrait_dialogue: TextureRect = get_node_or_null("BottomLeftDialogue/Margin/HBox/TexturePortraitDialogue")

# Bottom Center Dock Macro-Categorie
@onready var panel_center_dock: PanelContainer = get_node_or_null("BottomCenterDock")
@onready var btn_dock_personal: Button = get_node_or_null("BottomCenterDock/Margin/HBoxDock/BtnDockPersonal")
@onready var btn_dock_creation: Button = get_node_or_null("BottomCenterDock/Margin/HBoxDock/BtnDockCreation")
@onready var btn_dock_career: Button = get_node_or_null("BottomCenterDock/Margin/HBoxDock/BtnDockCareer")
@onready var btn_dock_tools: Button = get_node_or_null("BottomCenterDock/Margin/HBoxDock/BtnDockTools")
@onready var btn_dock_band: Button = get_node_or_null("BottomCenterDock/Margin/HBoxDock/BtnDockBand")

# Bottom Right Location & Money
@onready var label_location: Label = get_node_or_null("BottomRightInfo/VBox/HBoxLocation/LabelLocation") if has_node("BottomRightInfo/VBox/HBoxLocation/LabelLocation") else get_node_or_null("BottomRightInfo/VBox/LabelLocation")
@onready var texture_location_icon: TextureRect = get_node_or_null("BottomRightInfo/VBox/HBoxLocation/TextureLocationIcon")
@onready var label_money: Label = get_node_or_null("BottomRightInfo/VBox/HBoxMoney/LabelMoney") if has_node("BottomRightInfo/VBox/HBoxMoney/LabelMoney") else get_node_or_null("BottomRightInfo/VBox/LabelMoney")
@onready var texture_money_icon: TextureRect = get_node_or_null("BottomRightInfo/VBox/HBoxMoney/TextureMoneyIcon")
@onready var label_fans: Label = get_node_or_null("BottomRightInfo/VBox/HBoxFans/LabelFans")

# Modali di Gioco
@onready var song_catalog_modal: Control = get_node_or_null("Modals/SongCatalog")
@onready var song_creator_modal: Control = get_node_or_null("Modals/SongCreator")
@onready var live_concert_modal: Control = get_node_or_null("Modals/LiveConcert")
@onready var economy_bank_modal: Control = get_node_or_null("Modals/EconomyBank")
@onready var daily_summary_modal: Control = get_node_or_null("Modals/DailySummary")
@onready var character_sheet_modal: Control = get_node_or_null("Modals/CharacterSheet")
@onready var band_hub_modal: Control = get_node_or_null("Modals/BandHub")
@onready var album_creator_modal: Control = get_node_or_null("Modals/AlbumCreator")
@onready var industry_hub_modal: Control = get_node_or_null("Modals/IndustryHub")
@onready var dilemma_modal: Control = get_node_or_null("Modals/DilemmaModal")
@onready var travel_modal: Control = get_node_or_null("Modals/TravelModal")
@onready var tour_modal: Control = get_node_or_null("Modals/TourModal")
@onready var festival_modal: Control = get_node_or_null("Modals/FestivalModal")
@onready var social_modal: Control = get_node_or_null("Modals/SocialModal")
@onready var chart_modal: Control = get_node_or_null("Modals/ChartModal")
@onready var system_menu_modal: Control = get_node_or_null("Modals/SystemMenuModal")
@onready var upgrades_modal: Control = get_node_or_null("Modals/UpgradesModal")
@onready var relax_modal: Control = get_node_or_null("Modals/RelaxModal")
@onready var legacy_modal: Control = get_node_or_null("Modals/LegacyModal")
@onready var interaction_menu: InteractionMenu = get_node_or_null("InteractionMenu")

var _all_modals: Array[Control] = []
var practice_picker: InstrumentPracticePicker = null
var study_picker: SkillStudyPicker = null
var _pending_picker_action: Dictionary = {}
var action_system: ActionSystem = null
var _current_running_action: Dictionary = {}
var is_stereo_on: bool = false
var _current_speaker: String = "ALEX"

const DEFAULT_AMBIENT_TEXT: String = "New York - Loft Apartment.\nFrecce/WASD/Numpad: cammina.\nTab: sfoglia arredi. Spazio: interagisci. Esc: menu."

func _ready() -> void:
	if GameManager and GameManager.player_data and GameManager.calendar_data:
		action_system = ActionSystem.new(GameManager.player_data, GameManager.calendar_data)
	_register_modals()
	_ensure_pickers()
	_connect_events()
	_connect_modal_signals()
	_connect_dock_buttons()
	_connect_time_buttons()
	hide_all_modals()
	reset_inspection()
	update_hud_display()

func _process(delta: float) -> void:
	if GameManager and GameManager.is_paused():
		return
	if GameManager and GameManager.time_system:
		GameManager.time_system.advance_time(delta)
	if action_system and action_system.is_running:
		action_system.update_action(delta)

func _register_modals() -> void:
	_all_modals = []
	var candidate_modals: Array = [
		song_catalog_modal,
		song_creator_modal,
		live_concert_modal,
		economy_bank_modal,
		daily_summary_modal,
		character_sheet_modal,
		band_hub_modal,
		album_creator_modal,
		industry_hub_modal,
		dilemma_modal,
		travel_modal,
		tour_modal,
		festival_modal,
		social_modal,
		chart_modal,
		system_menu_modal,
		upgrades_modal,
		relax_modal,
		legacy_modal
	]
	for m in candidate_modals:
		if m != null:
			_all_modals.append(m)

func _connect_events() -> void:
	if EventBus:
		EventBus.money_changed.connect(func(_b, _d, _r): update_hud_display())
		EventBus.time_ticked.connect(func(_rem, _t, _p): update_hud_display())
		EventBus.day_ended.connect(func(_d: int): update_hud_display())
		EventBus.daily_summary_ready.connect(_on_daily_summary_ready)
		EventBus.dilemma_triggered.connect(open_dilemma)
		EventBus.certification_awarded.connect(func(_d): AccessibilityManager.play_cue(Enums.AudioCueType.CERTIFICATION_AWARD))
		EventBus.chart_number_one_achieved.connect(func(_c, _t): AccessibilityManager.play_cue(Enums.AudioCueType.CHART_NUMBER_ONE))
		EventBus.award_won.connect(func(_a): AccessibilityManager.play_cue(Enums.AudioCueType.CERTIFICATION_AWARD))
		EventBus.action_completed.connect(_on_hud_action_completed)
		EventBus.action_canceled.connect(_on_hud_action_canceled)

func _connect_modal_signals() -> void:
	if song_catalog_modal and song_catalog_modal.has_signal("closed"):
		song_catalog_modal.closed.connect(func(): close_modal(song_catalog_modal))
	if song_catalog_modal and song_catalog_modal.has_signal("new_song_requested"):
		song_catalog_modal.new_song_requested.connect(func():
			close_modal(song_catalog_modal)
			open_modal(song_creator_modal)
		)
	if song_catalog_modal and song_catalog_modal.has_signal("edit_song_requested"):
		song_catalog_modal.edit_song_requested.connect(func(song):
			close_modal(song_catalog_modal)
			open_modal(song_creator_modal)
			if song_creator_modal and song_creator_modal.has_method("edit_existing_song"):
				song_creator_modal.edit_existing_song(song)
		)
	if song_creator_modal and song_creator_modal.has_signal("creation_canceled"):
		song_creator_modal.creation_canceled.connect(func(): close_modal(song_creator_modal))
	if song_creator_modal and song_creator_modal.has_signal("creation_finished"):
		song_creator_modal.creation_finished.connect(func(_s): close_modal(song_creator_modal))
	if live_concert_modal and live_concert_modal.has_signal("closed"):
		live_concert_modal.closed.connect(func(): close_modal(live_concert_modal))
	if economy_bank_modal and economy_bank_modal.has_signal("closed"):
		economy_bank_modal.closed.connect(func(): close_modal(economy_bank_modal))
	if daily_summary_modal and daily_summary_modal.has_signal("day_advanced"):
		daily_summary_modal.day_advanced.connect(func(): close_modal(daily_summary_modal))
	if character_sheet_modal and character_sheet_modal.has_signal("closed"):
		character_sheet_modal.closed.connect(func(): close_modal(character_sheet_modal))
	if band_hub_modal and band_hub_modal.has_signal("closed"):
		band_hub_modal.closed.connect(func(): close_modal(band_hub_modal))
	if album_creator_modal and album_creator_modal.has_signal("closed"):
		album_creator_modal.closed.connect(func(): close_modal(album_creator_modal))
	if industry_hub_modal and industry_hub_modal.has_signal("closed"):
		industry_hub_modal.closed.connect(func(): close_modal(industry_hub_modal))
	if dilemma_modal and dilemma_modal.has_signal("closed"):
		dilemma_modal.closed.connect(func(): close_modal(dilemma_modal))
	if travel_modal and travel_modal.has_signal("closed"):
		travel_modal.closed.connect(func(): close_modal(travel_modal))
	if tour_modal and tour_modal.has_signal("closed"):
		tour_modal.closed.connect(func(): close_modal(tour_modal))
	if festival_modal and festival_modal.has_signal("closed"):
		festival_modal.closed.connect(func(): close_modal(festival_modal))
	if social_modal and social_modal.has_signal("closed"):
		social_modal.closed.connect(func(): close_modal(social_modal))
	if chart_modal and chart_modal.has_signal("closed"):
		chart_modal.closed.connect(func(): close_modal(chart_modal))
	if upgrades_modal and upgrades_modal.has_signal("closed"):
		upgrades_modal.closed.connect(func(): close_modal(upgrades_modal))
	if relax_modal and relax_modal.has_signal("closed"):
		relax_modal.closed.connect(func(): close_modal(relax_modal))
	if relax_modal and relax_modal.has_signal("activity_selected"):
		relax_modal.activity_selected.connect(_on_relax_activity_selected)
	if legacy_modal and legacy_modal.has_signal("closed"):
		legacy_modal.closed.connect(func(): close_modal(legacy_modal))
	if system_menu_modal:
		if system_menu_modal.has_signal("resume_requested"):
			system_menu_modal.resume_requested.connect(func(): close_modal(system_menu_modal))
		if system_menu_modal.has_signal("closed"):
			system_menu_modal.closed.connect(func(): close_modal(system_menu_modal))
	if interaction_menu:
		if not interaction_menu.action_chosen.is_connected(_on_interaction_action_chosen):
			interaction_menu.action_chosen.connect(_on_interaction_action_chosen)
		if not interaction_menu.menu_closed.is_connected(_on_interaction_menu_closed):
			interaction_menu.menu_closed.connect(_on_interaction_menu_closed)

func _connect_dock_buttons() -> void:
	if btn_dock_personal and not btn_dock_personal.pressed.is_connected(_on_dock_personal_pressed):
		btn_dock_personal.pressed.connect(_on_dock_personal_pressed)
	if btn_dock_creation and not btn_dock_creation.pressed.is_connected(_on_dock_creation_pressed):
		btn_dock_creation.pressed.connect(_on_dock_creation_pressed)
	if btn_dock_career and not btn_dock_career.pressed.is_connected(_on_dock_career_pressed):
		btn_dock_career.pressed.connect(_on_dock_career_pressed)
	if btn_dock_tools and not btn_dock_tools.pressed.is_connected(_on_dock_tools_pressed):
		btn_dock_tools.pressed.connect(_on_dock_tools_pressed)
	if btn_dock_band and not btn_dock_band.pressed.is_connected(_on_dock_band_pressed):
		btn_dock_band.pressed.connect(_on_dock_band_pressed)

func _connect_time_buttons() -> void:
	if btn_time_pause and not btn_time_pause.pressed.is_connected(_on_time_pause_pressed):
		btn_time_pause.pressed.connect(_on_time_pause_pressed)
	if btn_time_speed and not btn_time_speed.pressed.is_connected(_on_time_speed_pressed):
		btn_time_speed.pressed.connect(_on_time_speed_pressed)
	if btn_time_sleep and not btn_time_sleep.pressed.is_connected(_on_time_sleep_pressed):
		btn_time_sleep.pressed.connect(_on_time_sleep_pressed)

func _on_dock_personal_pressed() -> void:
	open_modal(character_sheet_modal)

func _on_dock_creation_pressed() -> void:
	open_modal(song_catalog_modal)

func _on_dock_career_pressed() -> void:
	open_modal(live_concert_modal)

func _on_dock_tools_pressed() -> void:
	open_modal(upgrades_modal)

func _on_dock_band_pressed() -> void:
	open_modal(band_hub_modal)

func _on_time_pause_pressed() -> void:
	if GameManager and GameManager.time_system:
		GameManager.time_system.toggle_pause()
		var state_str: String = "In pausa" if GameManager.time_system.is_paused else "In riproduzione"
		AccessibilityManager.announce("Tempo di gioco: %s" % state_str, true)

func _on_time_speed_pressed() -> void:
	if GameManager and GameManager.time_system:
		var new_speed: float = 2.0 if GameManager.time_system.time_scale < 1.5 else 1.0
		GameManager.time_system.time_scale = new_speed
		AccessibilityManager.announce("Velocità del tempo: %.1fx" % new_speed, true)

func _on_time_sleep_pressed() -> void:
	if GameManager and GameManager.time_system and GameManager.calendar_data:
		if GameManager.calendar_data.current_period == Enums.TimePeriod.NIGHT:
			AccessibilityManager.announce("Buonanotte. Sonno profondo fino a domani mattina.", true)
			GameManager.time_system.trigger_sleep_now()
		else:
			AccessibilityManager.announce("Riposo breve fino alla fascia successiva.", true)
			GameManager.time_system.advance_to_next_period()
		update_hud_display()

func _on_relax_activity_selected(action: ActionData) -> void:
	if action_system:
		action_system.start_action(action)

func is_any_modal_open() -> bool:
	if interaction_menu and interaction_menu.visible and interaction_menu.is_menu_open:
		return true
	if practice_picker and practice_picker.visible and practice_picker.is_picker_open:
		return true
	if study_picker and study_picker.visible and study_picker.is_picker_open:
		return true
	for m in _all_modals:
		if m and m.visible:
			return true
	return false

func hide_all_modals() -> void:
	if interaction_menu:
		interaction_menu.visible = false
		interaction_menu.is_menu_open = false
	if practice_picker:
		practice_picker.visible = false
		practice_picker.is_picker_open = false
	clear_inspection()
	if study_picker:
		study_picker.visible = false
		study_picker.is_picker_open = false
	for m in _all_modals:
		if m:
			m.visible = false
	if has_node("Modals"):
		$Modals.visible = false

func open_interaction_menu_for_prop(prop_id: String, prop_name: String, actions: Array[Dictionary], screen_pos: Vector2 = Vector2.ZERO) -> void:
	clear_inspection()
	hide_all_modals()
	if interaction_menu:
		interaction_menu.open_menu(prop_id, prop_name, actions, screen_pos)
		modal_opened.emit("InteractionMenu")
		interaction_menu_opened.emit(prop_id)
		if GameManager:
			GameManager.open_menu()

func close_interaction_menu() -> void:
	if interaction_menu and interaction_menu.is_menu_open:
		interaction_menu.close_menu()

func _on_interaction_menu_closed() -> void:
	if GameManager:
		GameManager.close_menu()
	modal_closed.emit("InteractionMenu")
	interaction_menu_closed.emit()

func open_modal(modal_node: Control) -> void:
	if not modal_node:
		return
	clear_inspection()
	hide_all_modals()
	if has_node("Modals"):
		$Modals.visible = true
	modal_node.visible = true
	if modal_node.has_method("open"):
		modal_node.call("open")
	if GameManager:
		GameManager.open_menu()
	modal_opened.emit(modal_node.name)

func close_modal(modal_node: Control) -> void:
	if not modal_node:
		return
	modal_node.visible = false
	var any_modal_open: bool = false
	for m in _all_modals:
		if m and m.visible:
			any_modal_open = true
			break
	if not any_modal_open and has_node("Modals"):
		$Modals.visible = false
	if GameManager:
		GameManager.close_menu()
	modal_closed.emit(modal_node.name)
	update_hud_display()

func clear_inspection() -> void:
	if label_speaker:
		label_speaker.text = ""
	if label_text:
		label_text.text = ""
	if label_hint:
		label_hint.text = ""
	if panel_dialogue:
		panel_dialogue.visible = false

func show_inspection(text: String, speaker_name: String = "ALEX", hint_text: String = "[Spazio] Interagisci   [Esc] Indietro", should_announce: bool = true) -> void:
	if label_text:
		label_text.text = ""
	_current_speaker = speaker_name.to_upper()
	if label_speaker:
		label_speaker.text = _current_speaker
	if label_text:
		label_text.text = text
	if label_hint:
		label_hint.text = hint_text
	if panel_dialogue:
		panel_dialogue.visible = true
	_update_dialogue_portrait()

	if should_announce and not text.strip_edges().is_empty():
		var speech: String = text
		if not speaker_name.is_empty() and speaker_name.to_upper() != "ALEX" and speaker_name.to_upper() != "DIARIO DI BORDO":
			speech = "%s: %s" % [speaker_name, text]
		AccessibilityManager.announce(speech, true)

func reset_inspection() -> void:
	if label_speaker:
		label_speaker.text = "DIARIO DI BORDO"
	if label_text:
		label_text.text = DEFAULT_AMBIENT_TEXT
	if label_hint:
		label_hint.text = "[Frecce] Muoviti   [Tab] Arredi   [Spazio] Azione   [Esc] Menu"
	if panel_dialogue:
		panel_dialogue.visible = false

func get_alex_portrait_texture(player: PlayerData) -> Texture2D:
	if not player:
		return TEX_ALEX_NORMALE
	# 1. Stato Disperato: burnout / collasso fisico
	if player.energy <= 15.0 or player.stress >= 85.0:
		return TEX_ALEX_DISPERATO
	# 2. Stato Arrabbiato: forte tensione
	if player.stress >= 60.0:
		return TEX_ALEX_ARRABBIATO
	# 3. Stato Triste: crisi d'ispirazione / morale a terra
	if player.morale <= 30.0:
		return TEX_ALEX_TRISTE
	# 4. Stato Ordinario
	return TEX_ALEX_NORMALE

func _update_dialogue_portrait() -> void:
	if not texture_portrait_dialogue:
		return
	var player: PlayerData = GameManager.player_data if GameManager else null
	if _current_speaker == "ALEX":
		texture_portrait_dialogue.texture = get_alex_portrait_texture(player)
	else:
		# Se l'interlocutore non è Alex, mostriamo il ritratto neutrale o lo sprite associato
		texture_portrait_dialogue.texture = TEX_ALEX_NORMALE

func update_hud_display() -> void:
	var player: PlayerData = GameManager.player_data if GameManager else null
	var calendar: CalendarData = GameManager.calendar_data if GameManager else null

	if player:
		# Ritratto Alex in alto a sinistra
		if texture_portrait_top:
			texture_portrait_top.texture = get_alex_portrait_texture(player)
		_update_dialogue_portrait()

		# Livello Personaggio & Icona
		if label_level:
			var tier_str: String = GameManager.career_system.get_tier_name(player.career_tier) if (GameManager and GameManager.career_system) else "Garage Hero"
			label_level.text = "Lv. %d — %s ⭐" % [player.career_tier + 1, tier_str]
		if texture_level_icon and texture_level_icon.texture == null:
			texture_level_icon.texture = TEX_LIVELLO

		# Barra Energia
		if bar_energy:
			bar_energy.value = player.energy
		if label_energy_val:
			label_energy_val.text = "ENERGIA (%d%%)" % int(player.energy)
		if texture_energy_icon and texture_energy_icon.texture == null:
			texture_energy_icon.texture = TEX_ENERGIA

		# Barra Stress & Icona Dinamica
		if bar_stress:
			bar_stress.value = player.stress
		if label_stress_val:
			label_stress_val.text = "STRESS (%d%%)" % int(player.stress)
		if texture_stress_icon:
			texture_stress_icon.texture = TEX_STRESS_CRITICO if player.stress >= 60.0 else TEX_STRESS_NORMALE

		# Barra Morale & Icona Dinamica
		if bar_morale:
			bar_morale.value = player.morale
		if label_morale_val:
			label_morale_val.text = "MORALE (%d%%)" % int(player.morale)
		if texture_morale_icon:
			texture_morale_icon.texture = TEX_MORALE_CRITICO if player.morale <= 30.0 else TEX_MORALE_NORMALE

		# Economia & Saldo Dinamico
		if label_money:
			label_money.text = "Banconote: %.2f €" % player.money
		if texture_money_icon:
			texture_money_icon.texture = TEX_MOLTI_SOLDI if player.money >= 1000.0 else TEX_POCHI_SOLDI

		# Fanbase & Mappa
		if label_fans:
			label_fans.text = "Folla: %d Fan" % player.fans
		if label_location:
			label_location.text = "Mappa: NYC — Loft Apartment"
		if texture_location_icon and texture_location_icon.texture == null:
			texture_location_icon.texture = TEX_MAPPA

	if calendar:
		if label_datetime:
			label_datetime.text = "Giorno %d — %s, Settimana %d" % [calendar.day_number, calendar.get_weekday_name(), calendar.get_week_number()]
		if label_period:
			label_period.text = "%s %s" % [_get_localized_period(calendar.current_period), calendar.get_formatted_time_string()]
		if texture_period_icon:
			texture_period_icon.texture = get_period_weather_texture(calendar.current_period)

func get_period_weather_texture(period: int) -> Texture2D:
	match period:
		Enums.TimePeriod.MORNING:
			return TEX_MATTINO
		Enums.TimePeriod.AFTERNOON:
			return TEX_POMERIGGIO
		Enums.TimePeriod.EVENING:
			return TEX_TRAMONTO
		Enums.TimePeriod.NIGHT:
			return TEX_NOTTE
		_:
			return TEX_MATTINO

func _get_localized_period(period: int) -> String:
	match period:
		Enums.TimePeriod.MORNING:
			return "Mattina"
		Enums.TimePeriod.AFTERNOON:
			return "Pomeriggio"
		Enums.TimePeriod.EVENING:
			return "Sera"
		Enums.TimePeriod.NIGHT:
			return "Notte"
		_:
			return "Giorno"

func _get_localized_weekday(day_number: int) -> String:
	var days: Array[String] = ["Lunedì", "Martedì", "Mercoledì", "Giovedì", "Venerdì", "Sabato", "Domenica"]
	var index: int = (day_number - 1) % 7
	return days[index]

func _on_daily_summary_ready(summary_data: Dictionary) -> void:
	hide_all_modals()
	if has_node("Modals"):
		$Modals.visible = true
	if daily_summary_modal:
		daily_summary_modal.show_summary(summary_data)
		modal_opened.emit("DailySummary")

func open_dilemma(dilemma_dict: Dictionary) -> void:
	if is_any_modal_open() and daily_summary_modal and daily_summary_modal.visible:
		return
	hide_all_modals()
	if has_node("Modals"):
		$Modals.visible = true
	if dilemma_modal:
		dilemma_modal.open(dilemma_dict)
		modal_opened.emit("DilemmaModal")

func open_modal_by_prop_id(prop_id: String) -> void:
	match prop_id:
		"guitar":
			open_modal(song_creator_modal)
		"kitchen":
			if GameManager and GameManager.player_data:
				GameManager.player_data.energy = mini(Constants.MAX_ENERGY, GameManager.player_data.energy + 15)
				GameManager.player_data.stress = maxi(Constants.MIN_STRESS, GameManager.player_data.stress - 5)
			AccessibilityManager.play_cue(Enums.AudioCueType.AREA_PERSONAL)
			AccessibilityManager.announce("Espresso bollente preparato nella cucina del loft. Energia ripristinata!", true)
			show_inspection("Un ottimo caffè espresso appena fatto. Pronto a rimetterti al lavoro!", "CUCINA", "[Spazio] Chiudi")
			update_hud_display()
		"couch":
			if GameManager and GameManager.player_data:
				GameManager.player_data.stress = maxi(Constants.MIN_STRESS, GameManager.player_data.stress - 12)
				GameManager.player_data.morale = mini(Constants.MAX_MORALE, GameManager.player_data.morale + 5)
				GameManager.player_data.energy = mini(Constants.MAX_ENERGY, GameManager.player_data.energy + 5)
			AccessibilityManager.play_cue(Enums.AudioCueType.AREA_PERSONAL)
			AccessibilityManager.announce("Ti sei disteso sul divano a riposare. Tensione e stress diminuiti.", true)
			show_inspection("Ti rilassi sul divano vissuto del loft. Tensione allentata e mente rigenerata!", "DIVANO", "[Spazio] Chiudi")
			update_hud_display()
		"turntable":
			if GameManager and GameManager.player_data:
				GameManager.player_data.morale = mini(Constants.MAX_MORALE, GameManager.player_data.morale + 20)
				GameManager.player_data.stress = maxi(Constants.MIN_STRESS, GameManager.player_data.stress - 10)
				var got_spark: bool = randf() < 0.35
				if got_spark:
					if GameManager.player_data.has_method("add_skill_xp"):
						GameManager.player_data.add_skill_xp("composition", Constants.RECOVERY_MUSIC_SPARK_XP)
					AccessibilityManager.announce("Sessione vinili d'epoca sul giradischi! +20 Morale, -10 Stress e una Scintilla Creativa guadagnata!", true)
					show_inspection("L'ascolto dei vinili d'epoca ti ha ispirato: hai ottenuto una Scintilla Creativa (+15 XP Composizione)!", "GIRADISCHI", "[Spazio] Chiudi")
				else:
					AccessibilityManager.announce("Sessione vinili d'epoca sul giradischi! +20 Morale e -10 Stress.", true)
					show_inspection("Il calore analogico del vinile risuona nel loft, sciogliendo la tensione.", "GIRADISCHI", "[Spazio] Chiudi")
			AccessibilityManager.play_cue(Enums.AudioCueType.AREA_CREATION)
			update_hud_display()
		"bed":
			if GameManager and GameManager.time_system and GameManager.calendar_data:
				if GameManager.calendar_data.current_period == Enums.TimePeriod.NIGHT:
					AccessibilityManager.announce("È notte fonda. Buonanotte fino a domani mattina alle 06:00.", true)
					GameManager.time_system.trigger_sleep_now()
				else:
					show_inspection("Letto del Loft.\n[Z] Dormi fino a domani   [X] Salta alla fascia successiva   [Esc] Annulla", "LETTO", "[Z] Dormi   [X] Salta orario   [Esc] Annulla")
					AccessibilityManager.announce("Letto del Loft. Premi Z per dormire fino a domani mattina, X per riposare fino alla fascia successiva, oppure Esc per annullare.", true)
				update_hud_display()
		"arcade":
			if GameManager and GameManager.player_data:
				GameManager.player_data.morale = mini(Constants.MAX_MORALE, GameManager.player_data.morale + 10)
				GameManager.player_data.stress = maxi(Constants.MIN_STRESS, GameManager.player_data.stress - 5)
				AccessibilityManager.announce("Partita al cabinato arcade! Morale aumentato di 10.", true)
				AccessibilityManager.play_cue(Enums.AudioCueType.AREA_PERSONAL)
				update_hud_display()
		"desk":
			open_modal(band_hub_modal)
		"wardrobe":
			open_modal(character_sheet_modal)
		"toolbox":
			open_modal(upgrades_modal)
		"door":
			open_modal(live_concert_modal)
		"stereo":
			if not is_stereo_on:
				is_stereo_on = true
				if GameManager and GameManager.player_data:
					GameManager.player_data.morale = mini(Constants.MAX_MORALE, GameManager.player_data.morale + 5)
					GameManager.player_data.stress = maxi(Constants.MIN_STRESS, GameManager.player_data.stress - 5)
				AccessibilityManager.play_cue(Enums.AudioCueType.AREA_PERSONAL)
				AccessibilityManager.announce("Stereo acceso! Riff rock in diffusione nello studio.", true)
				show_inspection("Stereo acceso! I riff rock riempiono la stanza, allontanando lo stress. Premi di nuovo per spegnere.", "STEREO", "[Spazio] Spegni")
			else:
				is_stereo_on = false
				AccessibilityManager.announce("Stereo spento. Silenzio ripristinato nello studio.", true)
				show_inspection("Stereo spento. La stanza torna in silenzio. Premi di nuovo per accendere.", "STEREO", "[Spazio] Accendi")
			update_hud_display()
		_:
			reset_inspection()

func _ensure_pickers() -> void:
	if practice_picker == null:
		practice_picker = get_node_or_null("InstrumentPracticePicker")
		if practice_picker == null:
			practice_picker = InstrumentPracticePicker.new()
			practice_picker.name = "InstrumentPracticePicker"
			add_child(practice_picker)
		if not practice_picker.instrument_selected.is_connected(_on_practice_instrument_selected):
			practice_picker.instrument_selected.connect(_on_practice_instrument_selected)
		if not practice_picker.picker_closed.is_connected(_on_practice_picker_closed):
			practice_picker.picker_closed.connect(_on_practice_picker_closed)

	if study_picker == null:
		study_picker = get_node_or_null("SkillStudyPicker")
		if study_picker == null:
			study_picker = SkillStudyPicker.new()
			study_picker.name = "SkillStudyPicker"
			add_child(study_picker)
		if not study_picker.skill_selected.is_connected(_on_study_skill_selected):
			study_picker.skill_selected.connect(_on_study_skill_selected)
		if not study_picker.study_picker_closed.is_connected(_on_study_picker_closed):
			study_picker.study_picker_closed.connect(_on_study_picker_closed)

func _on_practice_instrument_selected(skill_id: String, skill_name: String) -> void:
	if practice_picker and practice_picker.is_picker_open:
		practice_picker.close_picker()
	if GameManager:
		GameManager.close_menu()
	modal_closed.emit("InstrumentPracticePicker")

	var act: Dictionary = _pending_picker_action.duplicate()
	_pending_picker_action = {}
	act["type"] = "action"
	act["xp_skill"] = skill_id
	act["title"] = "Scale e riff: %s" % skill_name
	act["result_message"] = "Sessione di scale e riff su %s terminata (+20 XP, -10 Energia)!" % skill_name
	execute_interaction_action("guitar", act)

func _on_practice_picker_closed() -> void:
	if GameManager:
		GameManager.close_menu()
	modal_closed.emit("InstrumentPracticePicker")
	_pending_picker_action = {}

func _on_study_skill_selected(skill_id: String, skill_name: String, method_type: int) -> void:
	if study_picker and study_picker.is_picker_open:
		study_picker.close_study_picker()
	if GameManager:
		GameManager.close_menu()
	modal_closed.emit("SkillStudyPicker")

	var act: Dictionary = _pending_picker_action.duplicate()
	_pending_picker_action = {}
	act["type"] = "action"
	act["xp_skill"] = skill_id
	var method_name: String = ""
	match method_type:
		PlayerData.StudyMethodType.MANUAL:
			method_name = "Studio manuale"
		PlayerData.StudyMethodType.ACADEMY:
			method_name = "Corso in Accademia"
		PlayerData.StudyMethodType.MENTOR:
			method_name = "Lezione col Maestro"
		_:
			method_name = "Studio"
	var xp_val: float = act.get("xp_amount", 35.0)
	act["title"] = "%s: %s" % [method_name, skill_name]
	act["result_message"] = "%s su %s completato con profitto (+%.0f XP)!" % [method_name, skill_name, xp_val]
	execute_interaction_action("study", act)

func _on_study_picker_closed() -> void:
	if GameManager:
		GameManager.close_menu()
	modal_closed.emit("SkillStudyPicker")
	_pending_picker_action = {}

func _on_interaction_action_chosen(prop_id: String, action: Dictionary) -> void:
	execute_interaction_action(prop_id, action)

func execute_interaction_action(prop_id: String, action: Dictionary) -> void:
	var a_type: String = action.get("type", "inspect")
	var dur: float = action.get("duration_seconds", 0.0)

	match a_type:
		"practice_picker":
			_ensure_pickers()
			hide_all_modals()
			_pending_picker_action = action
			var p_pos: Vector2 = Vector2.ZERO
			if interaction_menu:
				p_pos = interaction_menu.position
			var p_data: PlayerData = GameManager.player_data if GameManager else null
			practice_picker.open_picker(p_data, p_pos)
			modal_opened.emit("InstrumentPracticePicker")
			if GameManager:
				GameManager.open_menu()

		"study_picker":
			_ensure_pickers()
			hide_all_modals()
			_pending_picker_action = action
			var s_pos: Vector2 = Vector2.ZERO
			if interaction_menu:
				s_pos = interaction_menu.position
			var method_type: int = action.get("study_method", 0)
			var p_data_s: PlayerData = GameManager.player_data if GameManager else null
			study_picker.open_study_picker(p_data_s, method_type, s_pos)
			modal_opened.emit("SkillStudyPicker")
			if GameManager:
				GameManager.open_menu()

		"inspect":
			var desc: String = action.get("dialogue_text", action.get("description", ""))
			show_inspection(desc, prop_id.to_upper(), "[Spazio] Chiudi   [Tab] Altri arredi")
			AccessibilityManager.announce(desc, true)
			AccessibilityManager.play_cue(Enums.AudioCueType.HOTSPOT_PROXIMITY)

		"modal":
			var m_name: String = action.get("modal_name", "")
			match m_name:
				"SongCreator":
					open_modal(song_creator_modal)
				"LiveConcert":
					open_modal(live_concert_modal)
				"TourModal":
					open_modal(tour_modal)
				"TravelModal":
					open_modal(travel_modal)
				"FestivalModal":
					open_modal(festival_modal)
				"CharacterSheet":
					open_modal(character_sheet_modal)
				"SongCatalog":
					open_modal(song_catalog_modal)
				"BandHub":
					open_modal(band_hub_modal)
				"Upgrades":
					open_modal(upgrades_modal)
				_:
					open_modal(song_creator_modal)

		"toggle":
			if not is_stereo_on:
				is_stereo_on = true
				if GameManager and GameManager.player_data:
					GameManager.player_data.morale = mini(Constants.MAX_MORALE, GameManager.player_data.morale + 5)
					GameManager.player_data.stress = maxi(Constants.MIN_STRESS, GameManager.player_data.stress - 5)
				AccessibilityManager.play_cue(Enums.AudioCueType.AREA_PERSONAL)
				AccessibilityManager.announce("Stereo acceso! Riff rock in diffusione nello studio.", true)
				show_inspection("Stereo acceso! I riff rock riempiono la stanza, allontanando lo stress. Premi di nuovo per spegnere.", "STEREO", "[Spazio] Spegni")
			else:
				is_stereo_on = false
				AccessibilityManager.announce("Stereo spento. Silenzio ripristinato nello studio.", true)
				show_inspection("Stereo spento. La stanza torna in silenzio. Premi di nuovo per accendere.", "STEREO", "[Spazio] Accendi")
			update_hud_display()

		"sleep":
			if GameManager and GameManager.time_system:
				AccessibilityManager.announce("Buonanotte. Sonno profondo fino a domani mattina.", true)
				GameManager.time_system.trigger_sleep_now()
				update_hud_display()

		"advance_period":
			if dur > 0.0:
				if action_system == null:
					var p_data: PlayerData = GameManager.player_data if GameManager else null
					var c_data: CalendarData = GameManager.calendar_data if GameManager else null
					action_system = ActionSystem.new(p_data, c_data)
				else:
					if GameManager and GameManager.player_data:
						action_system.player_data = GameManager.player_data
					if GameManager and GameManager.calendar_data:
						action_system.calendar_data = GameManager.calendar_data
				_run_action_with_duration(action)
			else:
				if GameManager and GameManager.time_system:
					AccessibilityManager.announce("Avanzamento fascia oraria.", true)
					GameManager.time_system.advance_to_next_period()
				_apply_action_effects(action)

		"action", "crafting_music", "crafting_lyrics":
			if a_type in ["crafting_music", "crafting_lyrics"]:
				var req_energy: int = 15 if a_type == "crafting_music" else 10
				if GameManager and GameManager.player_data and GameManager.player_data.energy < req_energy:
					var no_e_msg := "Energia insufficiente per comporre (%d richiesta)." % req_energy
					show_inspection(no_e_msg, "ALEX", "[Spazio] Chiudi", true)
					AccessibilityManager.announce(no_e_msg, true)
					return
			if action_system == null:
				var p_data: PlayerData = GameManager.player_data if GameManager else null
				var c_data: CalendarData = GameManager.calendar_data if GameManager else null
				action_system = ActionSystem.new(p_data, c_data)
			else:
				if GameManager and GameManager.player_data:
					action_system.player_data = GameManager.player_data
				if GameManager and GameManager.calendar_data:
					action_system.calendar_data = GameManager.calendar_data
			if dur > 0.0:
				_run_action_with_duration(action)
			else:
				_apply_action_effects(action)

func _run_action_with_duration(action: Dictionary) -> void:
	_current_running_action = action
	var act_id: String = action.get("id", "loft_act")
	var act_name: String = action.get("title", "Azione")
	var dur: float = action.get("duration_seconds", 5.0)
	var e_cost: int = maxi(0, -action.get("energy_delta", 0))
	var s_gain: int = maxi(0, action.get("stress_delta", 0))
	var xp: float = action.get("xp_amount", 0.0)
	var skill: String = action.get("xp_skill", "instrument")
	var money: float = action.get("money_cost", 0.0)
	var a_type_check: String = action.get("type", "")
	var e_delta_val: int = action.get("energy_delta", 0)
	var s_delta_val: int = action.get("stress_delta", 0)

	# Se l'azione è delegata a MusicSystem, azzeriamo i delta su ActionSystem per evitare la doppia detrazione
	if a_type_check in ["crafting_music", "crafting_lyrics"]:
		e_delta_val = 0
		s_delta_val = 0
		e_cost = 0
		s_gain = 0

	var is_rec: bool = (xp <= 0.0)
	var act_data := ActionData.new(
		act_id,
		act_name,
		dur,
		e_cost,
		s_gain,
		xp,
		skill,
		is_rec,
		e_delta_val,
		s_delta_val,
		action.get("morale_delta", 0),
		money,
		action.get("inspiration_chance", 0.0)
	)

	var check: Dictionary = action_system.can_start_action(act_data)
	if not check.get("can_start", false):
		show_inspection(check.get("reason", "Impossibile avviare azione."), "ALEX", "[Spazio] Chiudi", true)
		return

	show_inspection("In corso: %s (%ds)..." % [act_name, int(dur)], "ALEX", "[Esc] Annulla", true)
	action_system.start_action(act_data)

func _apply_action_effects(action: Dictionary) -> void:
	if not GameManager or not GameManager.player_data:
		return
	var player: PlayerData = GameManager.player_data
	var e_delta: int = action.get("energy_delta", 0)
	var s_delta: int = action.get("stress_delta", 0)
	var m_delta: int = action.get("morale_delta", 0)
	var money: float = action.get("money_cost", 0.0)
	var xp: float = action.get("xp_amount", 0.0)
	var skill: String = action.get("xp_skill", "")
	var is_gamble: bool = action.get("is_gamble", false)
	var insp_chance: float = action.get("inspiration_chance", 0.0)
	var insp_pts: int = int(action.get("inspiration_points_gain", 0))

	if money > 0.0:
		player.modify_money(-money)
	if e_delta != 0:
		player.energy = clampf(player.energy + e_delta, 0.0, Constants.MAX_ENERGY)
	if s_delta != 0:
		player.stress = clampf(player.stress + s_delta, Constants.MIN_STRESS, Constants.MAX_STRESS)
	if m_delta != 0:
		if is_gamble:
			var won: bool = randf() < 0.5
			var gamble_delta: int = m_delta if won else -5
			player.morale = clampf(player.morale + gamble_delta, Constants.MIN_MORALE, Constants.MAX_MORALE)
		else:
			player.morale = clampf(player.morale + m_delta, Constants.MIN_MORALE, Constants.MAX_MORALE)
	if xp > 0.0 and not skill.is_empty():
		if player.has_method("add_xp_to_skill"):
			player.add_xp_to_skill(skill, xp)
		elif player.has_method("add_skill_xp"):
			player.add_skill_xp(skill, xp)
	if insp_pts > 0:
		player.add_inspiration(insp_pts)
	if insp_chance > 0.0 and randf() < insp_chance:
		player.add_inspiration(1)
		if player.has_method("add_xp_to_skill"):
			player.add_xp_to_skill("composition", Constants.RECOVERY_MUSIC_SPARK_XP)
		elif player.has_method("add_skill_xp"):
			player.add_skill_xp("composition", Constants.RECOVERY_MUSIC_SPARK_XP)

	var res_msg: String = action.get("result_message", "Azione completata!")
	AccessibilityManager.play_cue(Enums.AudioCueType.AREA_PERSONAL)
	show_inspection(res_msg, "ALEX", "[Spazio] Chiudi", true)
	update_hud_display()

func _on_hud_action_completed(_action_id: String, _reward: Dictionary) -> void:
	var a_type: String = _current_running_action.get("type", "")
	if a_type == "advance_period":
		if GameManager and GameManager.time_system:
			GameManager.time_system.advance_to_next_period()
	elif a_type == "crafting_music":
		if GameManager and GameManager.player_data and GameManager.music_system:
			var drafts := GameManager.player_data.get_active_draft_songs()
			var target_draft: SongData = null
			for d in drafts:
				if d.music_progress < 100.0:
					target_draft = d
					break
			if target_draft:
				var res := GameManager.music_system.work_on_music_progress(target_draft.id, 1.0)
				_current_running_action["result_message"] = "Composizione musica completata per '%s'! Avanzamento: %.0f%%." % [target_draft.title, target_draft.music_progress]
			elif not drafts.is_empty():
				_current_running_action["result_message"] = "Tutti i cantieri aperti hanno già completato la musica! Apri il Song Creator per scrivere i testi, rifinirli o inciderli."
			else:
				_current_running_action["result_message"] = "Nessun cantiere aperto! Crea prima un nuovo progetto dal Song Creator."
	elif a_type == "crafting_lyrics":
		if GameManager and GameManager.player_data and GameManager.music_system:
			var drafts := GameManager.player_data.get_active_draft_songs()
			var target_draft: SongData = null
			for d in drafts:
				if d.lyrics_progress < 100.0:
					target_draft = d
					break
			if target_draft:
				var res := GameManager.music_system.work_on_lyrics_progress(target_draft.id, 1.0)
				_current_running_action["result_message"] = "Scrittura testo completata per '%s'! Avanzamento: %.0f%%." % [target_draft.title, target_draft.lyrics_progress]
			elif not drafts.is_empty():
				_current_running_action["result_message"] = "Tutti i cantieri aperti hanno già completato i testi! Apri il Song Creator per comporre la musica, rifinirli o inciderli."
			else:
				_current_running_action["result_message"] = "Nessun cantiere aperto! Crea prima un nuovo progetto dal Song Creator."

	var res_msg: String = _current_running_action.get("result_message", "Azione completata con successo!")
	_current_running_action = {}
	update_hud_display()
	AccessibilityManager.play_cue(Enums.AudioCueType.AREA_PERSONAL)
	show_inspection(res_msg, "ALEX", "[Spazio] Chiudi", false)

func _on_hud_action_canceled(_action_id: String) -> void:
	_current_running_action = {}
	clear_inspection()
	update_hud_display()
