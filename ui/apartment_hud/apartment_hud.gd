# res://ui/apartment_hud/apartment_hud.gd
class_name ApartmentHud
extends Control

## In-Game HUD Sovrimpresso in Pixel Art Retrò Arcade (V5.4.0)
## Fedele al concept visuale e all'architettura di Simmetria Universale (Luca & Holy Diver).
## Gestisce le barre vitali (Energia, Stress, Morale), l'inspection dialogue box con ritratto,
## l'indicatore di posizione/denaro e l'instradamento di tutte le 19 modali del simulatore.

signal modal_opened(modal_name: String)
signal modal_closed(modal_name: String)

# Top Bar / Profile
@onready var label_level: Label = $TopLeftProfile/HBox/VBox/LabelLevel
@onready var bar_energy: ProgressBar = $TopLeftProfile/HBox/VBox/BarEnergy
@onready var bar_stress: ProgressBar = $TopLeftProfile/HBox/VBox/BarStress
@onready var bar_morale: ProgressBar = $TopLeftProfile/HBox/VBox/BarMorale
@onready var texture_portrait_top: TextureRect = $TopLeftProfile/HBox/PortraitFrame/TexturePortraitTop

# Top Right Date / Time
@onready var label_datetime: Label = $TopRightTime/VBoxTime/LabelDateTime
@onready var label_period: Label = $TopRightTime/VBoxTime/LabelPeriod

# Bottom Left Inspection Dialogue Box
@onready var panel_dialogue: PanelContainer = $BottomLeftDialogue
@onready var label_speaker: Label = $BottomLeftDialogue/Margin/HBox/VBox/LabelSpeaker
@onready var label_text: Label = $BottomLeftDialogue/Margin/HBox/VBox/LabelText
@onready var label_hint: Label = $BottomLeftDialogue/Margin/HBox/VBox/LabelHint
@onready var texture_portrait_dialogue: TextureRect = $BottomLeftDialogue/Margin/HBox/TexturePortraitDialogue

# Bottom Right Location & Money
@onready var label_location: Label = $BottomRightInfo/VBox/LabelLocation
@onready var label_money: Label = $BottomRightInfo/VBox/LabelMoney

# Modali di Gioco
@onready var song_catalog_modal: Control = $Modals/SongCatalog
@onready var song_creator_modal: Control = $Modals/SongCreator
@onready var live_concert_modal: Control = $Modals/LiveConcert
@onready var economy_bank_modal: Control = $Modals/EconomyBank
@onready var daily_summary_modal: Control = $Modals/DailySummary
@onready var character_sheet_modal: Control = $Modals/CharacterSheet
@onready var band_hub_modal: Control = $Modals/BandHub
@onready var album_creator_modal: Control = $Modals/AlbumCreator
@onready var industry_hub_modal: Control = $Modals/IndustryHub
@onready var dilemma_modal: Control = $Modals/DilemmaModal
@onready var travel_modal: Control = $Modals/TravelModal
@onready var tour_modal: Control = $Modals/TourModal
@onready var festival_modal: Control = $Modals/FestivalModal
@onready var social_modal: Control = $Modals/SocialModal
@onready var chart_modal: Control = $Modals/ChartModal
@onready var system_menu_modal: Control = $Modals/SystemMenuModal
@onready var upgrades_modal: Control = $Modals/UpgradesModal
@onready var relax_modal: Control = $Modals/RelaxModal
@onready var legacy_modal: Control = $Modals/LegacyModal

var _all_modals: Array[Control] = []
var action_system: ActionSystem = null
const DEFAULT_AMBIENT_TEXT: String = "New York - Loft Apartment.\nFrecce/WASD/Numpad: cammina.\nTab: sfoglia arredi. Spazio: interagisci. Esc: menu."

func _ready() -> void:
	if GameManager and GameManager.player_data and GameManager.calendar_data:
		action_system = ActionSystem.new(GameManager.player_data, GameManager.calendar_data)
	_register_modals()
	_connect_events()
	_connect_modal_signals()
	hide_all_modals()
	reset_inspection()
	update_hud_display()

func _process(delta: float) -> void:
	if GameManager and GameManager.time_system:
		GameManager.time_system.advance_time(delta)
	if action_system and action_system.is_running:
		action_system.update_action(delta)

func _register_modals() -> void:
	_all_modals = [
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

func _connect_events() -> void:
	if EventBus:
		EventBus.money_changed.connect(func(_b, _d, _r): update_hud_display())
		EventBus.time_ticked.connect(func(_rem, _t, _p): update_hud_display())
		EventBus.action_completed.connect(func(_a, _r): update_hud_display())
		EventBus.day_ended.connect(_on_day_ended)
		EventBus.dilemma_triggered.connect(open_dilemma)
		EventBus.certification_awarded.connect(func(_d): AccessibilityManager.play_cue(Enums.AudioCueType.CERTIFICATION_AWARD))
		EventBus.chart_number_one_achieved.connect(func(_c, _t): AccessibilityManager.play_cue(Enums.AudioCueType.CHART_NUMBER_ONE))
		EventBus.award_won.connect(func(_a): AccessibilityManager.play_cue(Enums.AudioCueType.CERTIFICATION_AWARD))

func _connect_modal_signals() -> void:
	if song_catalog_modal and song_catalog_modal.has_signal("closed"):
		song_catalog_modal.closed.connect(func(): close_modal(song_catalog_modal))
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

func _on_relax_activity_selected(action: ActionData) -> void:
	if action_system:
		action_system.start_action(action)


func is_any_modal_open() -> bool:
	for m in _all_modals:
		if m and m.visible:
			return true
	return false

func hide_all_modals() -> void:
	for m in _all_modals:
		if m:
			m.visible = false

func open_modal(modal_node: Control) -> void:
	if not modal_node:
		return
	hide_all_modals()
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
	if GameManager:
		GameManager.close_menu()
	modal_closed.emit(modal_node.name)
	update_hud_display()

func show_inspection(text: String, speaker_name: String = "ALEX", hint_text: String = "[Spazio] Interagisci   [Esc] Indietro") -> void:
	if label_speaker:
		label_speaker.text = speaker_name.to_upper()
	if label_text:
		label_text.text = text
	if label_hint:
		label_hint.text = hint_text

func reset_inspection() -> void:
	show_inspection(DEFAULT_AMBIENT_TEXT, "DIARIO DI BORDO", "[Frecce] Muoviti   [Tab] Arredi   [Spazio] Azione   [Esc] Menu")

func update_hud_display() -> void:
	var player: PlayerData = GameManager.player_data if GameManager else null
	var calendar: CalendarData = GameManager.calendar_data if GameManager else null

	if player:
		if label_level:
			var tier_str: String = GameManager.career_system.get_tier_name(player.career_tier) if (GameManager and GameManager.career_system) else "Nessuno"
			label_level.text = "Tier %d - %s" % [player.career_tier + 1, tier_str]
		if bar_energy:
			bar_energy.value = player.energy
		if bar_stress:
			bar_stress.value = player.stress
		if bar_morale:
			bar_morale.value = player.morale
		if label_money:
			label_money.text = "€ %.2f" % player.money

	if calendar:
		if label_datetime:
			label_datetime.text = calendar.get_full_date_string()
		if label_period:
			label_period.text = "Ore %s (%s)" % [calendar.get_formatted_time_string(), _get_localized_period(calendar.current_period)]

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

func _on_day_ended(summary_data: Dictionary) -> void:
	hide_all_modals()
	if daily_summary_modal:
		daily_summary_modal.show_summary(summary_data)
		modal_opened.emit("DailySummary")

func open_dilemma(dilemma_dict: Dictionary) -> void:
	if is_any_modal_open() and daily_summary_modal and daily_summary_modal.visible:
		return
	hide_all_modals()
	if dilemma_modal:
		dilemma_modal.open(dilemma_dict)
		modal_opened.emit("DilemmaModal")

func open_modal_by_prop_id(prop_id: String) -> void:
	match prop_id:
		"guitar":
			open_modal(song_creator_modal)
		"kitchen":
			open_modal(relax_modal)
		"couch":
			open_modal(relax_modal)
		"turntable":
			open_modal(relax_modal)
		"bed":
			# Avanzamento / riposo o sleep
			if GameManager and GameManager.time_system:
				AccessibilityManager.announce("Riposo a letto. Avanzamento della fascia oraria.", true)
				GameManager.time_system.advance_to_next_period()
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
			if GameManager and GameManager.player_data:
				GameManager.player_data.morale = mini(Constants.MAX_MORALE, GameManager.player_data.morale + 5)
				GameManager.player_data.stress = maxi(Constants.MIN_STRESS, GameManager.player_data.stress - 5)
			AccessibilityManager.play_cue(Enums.AudioCueType.AREA_PERSONAL)
			AccessibilityManager.announce("Stereo da studio acceso! Riff rock diffusi nel loft.", true)
			show_inspection("Impianto stereo monitor acceso! La musica rock riempie la stanza, riducendo lo stress.", "STEREO", "[Spazio] Chiudi")
			update_hud_display()
		_:
			reset_inspection()
