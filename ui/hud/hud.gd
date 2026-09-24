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
@onready var btn_wait: Button = $VBoxMain/PanelTop/HBoxTop/BtnWait
@onready var btn_sleep: Button = $VBoxMain/PanelTop/HBoxTop/BtnSleep
@onready var btn_save: Button = $VBoxMain/PanelTop/HBoxTop/BtnSave
@onready var btn_main_menu: Button = $VBoxMain/PanelTop/HBoxTop/BtnMainMenu

@onready var label_player_summary: Label = $VBoxMain/PanelPlayerOverview/Margin/LabelPlayerSummary
@onready var label_status: Label = $VBoxMain/PanelCenter/LabelStatus
@onready var hbox_categories: HBoxContainer = $VBoxMain/PanelCenter/HBoxCategories
@onready var btn_tab_personal: Button = $VBoxMain/PanelCenter/HBoxCategories/BtnTabPersonal
@onready var btn_tab_creation: Button = $VBoxMain/PanelCenter/HBoxCategories/BtnTabCreation
@onready var btn_tab_career: Button = $VBoxMain/PanelCenter/HBoxCategories/BtnTabCareer
@onready var btn_tab_upgrades: Button = $VBoxMain/PanelCenter/HBoxCategories/BtnTabUpgrades

@onready var btn_character: Button = $VBoxMain/PanelCenter/HBoxActions/BtnCharacter
@onready var btn_practice: Button = $VBoxMain/PanelCenter/HBoxActions/BtnPractice
@onready var btn_catalog: Button = $VBoxMain/PanelCenter/HBoxActions/BtnCatalog
@onready var btn_new_song: Button = $VBoxMain/PanelCenter/HBoxActions/BtnNewSong
@onready var btn_concert: Button = $VBoxMain/PanelCenter/HBoxActions/BtnConcert
@onready var btn_economy: Button = $VBoxMain/PanelCenter/HBoxActions/BtnEconomy
@onready var btn_band: Button = $VBoxMain/PanelCenter/HBoxActions/BtnBand
@onready var btn_industry: Button = $VBoxMain/PanelCenter/HBoxActions/BtnIndustry
@onready var btn_agenda: Button = $VBoxMain/PanelCenter/HBoxActions/BtnAgenda
@onready var btn_travel: Button = $VBoxMain/PanelCenter/HBoxActions/BtnTravel
@onready var btn_tour: Button = $VBoxMain/PanelCenter/HBoxActions/BtnTour
@onready var btn_festival: Button = $VBoxMain/PanelCenter/HBoxActions/BtnFestival
@onready var btn_social: Button = $VBoxMain/PanelCenter/HBoxActions/BtnSocial
@onready var btn_chart: Button = $VBoxMain/PanelCenter/HBoxActions/BtnChart
@onready var btn_upgrades: Button = $VBoxMain/PanelCenter/HBoxActions/BtnUpgrades
@onready var btn_relax: Button = $VBoxMain/PanelCenter/HBoxActions/BtnRelax
@onready var btn_legacy: Button = $VBoxMain/PanelCenter/HBoxActions/BtnLegacy

@onready var song_catalog_modal: Control = $SongCatalog
@onready var song_creator_modal: Control = $SongCreator
@onready var live_concert_modal: Control = $LiveConcert
@onready var economy_bank_modal: Control = $EconomyBank
@onready var daily_summary_modal: Control = $DailySummary
@onready var character_sheet_modal: Control = $CharacterSheet
@onready var band_hub_modal: Control = $BandHub
@onready var album_creator_modal: Control = $AlbumCreator
@onready var industry_hub_modal: Control = $IndustryHub
@onready var dilemma_modal: Control = $DilemmaModal
@onready var travel_modal: Control = $TravelModal
@onready var tour_modal: Control = $TourModal
@onready var festival_modal: Control = $FestivalModal
@onready var social_modal: Control = $SocialModal
@onready var chart_modal: Control = $ChartModal
@onready var system_menu_modal: Control = $SystemMenuModal
@onready var upgrades_modal: Control = $UpgradesModal
@onready var relax_modal: Control = $RelaxModal
@onready var legacy_modal: Control = $LegacyModal

const ModalRouter = preload("res://ui/hud/modal_router.gd")

var current_category_tab: int = 1
var modal_router: ModalRouter = null

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
	
	# Inizializzazione del coordinatore modale specializzato
	modal_router = ModalRouter.new()
	modal_router.setup(self)

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
	btn_band.pressed.connect(open_band_hub)
	btn_industry.pressed.connect(open_industry_hub)
	btn_agenda.pressed.connect(_on_btn_agenda_pressed)
	btn_travel.pressed.connect(open_travel_modal)
	btn_tour.pressed.connect(open_tour_modal)
	btn_festival.pressed.connect(open_festival_modal)
	btn_social.pressed.connect(open_social_modal)
	btn_chart.pressed.connect(open_chart_modal)
	btn_speed.pressed.connect(_on_btn_speed_pressed)
	btn_pause.pressed.connect(_on_btn_pause_pressed)
	if btn_wait:
		btn_wait.pressed.connect(_on_btn_wait_pressed)
	if btn_sleep:
		btn_sleep.pressed.connect(_on_btn_sleep_pressed)
	btn_save.pressed.connect(_on_btn_save_pressed)
	btn_main_menu.pressed.connect(_on_btn_main_menu_pressed)
	
	# Connessione Tab Categorie, Upgrades, Relax e Legacy
	btn_tab_personal.pressed.connect(func(): select_category_tab(1))
	btn_tab_creation.pressed.connect(func(): select_category_tab(2))
	btn_tab_career.pressed.connect(func(): select_category_tab(3))
	btn_tab_upgrades.pressed.connect(func(): select_category_tab(4))
	btn_upgrades.pressed.connect(open_upgrades_modal)
	if btn_relax:
		btn_relax.pressed.connect(open_relax_modal)
	if btn_legacy:
		btn_legacy.pressed.connect(open_legacy_modal)
		AccessibilityManager.hook_control_accessibility(btn_legacy, "Albo d'Oro e Legacy (W)", "Apre le certificazioni, premi ufficiali, Hall of Fame e concerto d'addio.")
	
	AccessibilityManager.hook_control_accessibility(btn_tab_personal, "Area 1: Hub Personale", "Mostra le azioni di identità, agenda, bilancio e viaggi.")
	AccessibilityManager.hook_control_accessibility(btn_tab_creation, "Area 2: Creazione e Produzione", "Mostra catalogo brani, nuovo brano e creazione album.")
	AccessibilityManager.hook_control_accessibility(btn_tab_career, "Area 3: Carriera e Band", "Mostra concerti, band, tour, festival, social, classifiche e contratti.")
	AccessibilityManager.hook_control_accessibility(btn_tab_upgrades, "Area 4: Skills e Upgrade", "Mostra alloggi, sala prove, strumenti musicali e hardware di registrazione.")
	AccessibilityManager.hook_control_accessibility(btn_upgrades, "Miglioramenti e Strumentazione (U)", "Apre la gestione e acquisto di upgrade per alloggio, sala prove e strumenti.")
	
	AccessibilityManager.hook_control_accessibility(btn_tour, "Tournée e Concerti (O)", "Apre la gestione e pianificazione delle tournée multi-tappa.")
	AccessibilityManager.hook_control_accessibility(btn_festival, "Grandi Festival Estivi (F)", "Apre la schermata dei festival estivi e la selezione degli slot.")
	AccessibilityManager.hook_control_accessibility(btn_social, "Social Media (Y)", "Apre il canale social della band per pubblicare contenuti e gestire il feed dei fan.")
	AccessibilityManager.hook_control_accessibility(btn_chart, "Classifiche Musicali (H)", "Apre la Hit Parade settimanale dei singoli e degli album e la lista dei rivali.")
	
	# Inizializza la visualizzazione sulla prima categoria (Hub Personale)
	select_category_tab(1)
		
	# Connessione Fine Giornata (EndDaySystem)
	if GameManager:
		if not GameManager.end_day_system and GameManager.player_data and GameManager.calendar_data:
			GameManager.end_day_system = EndDaySystem.new(GameManager.player_data, GameManager.calendar_data)
		if GameManager.end_day_system:
			GameManager.end_day_system.summary_ready.connect(open_daily_summary)
		if GameManager.player_data and GameManager.player_data.songs.is_empty():
			GameManager.player_data.populate_starter_test_songs()
	
	# Connessione EventBus di gioco
	EventBus.time_ticked.connect(_on_time_ticked)
	EventBus.speed_changed.connect(_on_speed_changed)
	EventBus.action_started.connect(_on_action_started)
	EventBus.action_progress.connect(_on_action_progress)
	EventBus.action_completed.connect(_on_action_completed)
	EventBus.money_changed.connect(_on_money_changed)
	EventBus.language_changed.connect(_on_language_changed)
	EventBus.city_changed.connect(func(_o, _n): _update_hud_display())
	EventBus.contract_signed.connect(func(_d): _update_hud_display())
	EventBus.contract_canceled.connect(func(_d): _update_hud_display())
	EventBus.contract_completed.connect(func(_d): _update_hud_display())
	EventBus.manager_hired.connect(func(_d): _update_hud_display())
	EventBus.manager_fired.connect(func(_d): _update_hud_display())
	EventBus.skill_leveled_up.connect(func(_s, _l): _update_hud_display())
	EventBus.career_tier_promoted.connect(func(_t, _n): _update_hud_display())
	EventBus.housing_changed.connect(func(_t, _r): _update_hud_display())
	EventBus.certification_awarded.connect(func(_d): AccessibilityManager.play_cue(Enums.AudioCueType.CERTIFICATION_AWARD))
	EventBus.chart_number_one_achieved.connect(func(_c, _t): AccessibilityManager.play_cue(Enums.AudioCueType.CHART_NUMBER_ONE))
	EventBus.award_won.connect(func(_a): AccessibilityManager.play_cue(Enums.AudioCueType.CERTIFICATION_AWARD))
	
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

## Verifica se almeno una finestra modale è attualmente aperta e visibile
func _is_any_modal_open() -> bool:
	return modal_router.is_any_modal_open() if modal_router else false

## Chiude e occulta sistematicamente tutte le finestre modali del gioco
func _hide_all_modals() -> void:
	if modal_router:
		modal_router.hide_all_modals()

func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventKey) or not event.is_pressed() or event.is_echo():
		return
	
	# Se una modale è aperta, non intercettare scorciatoie di navigazione HUD
	if _is_any_modal_open():
		return
	
	match event.keycode:
		KEY_ESCAPE:
			open_system_menu()
			get_viewport().set_input_as_handled()
		KEY_1, KEY_KP_1:
			select_category_tab(1)
			get_viewport().set_input_as_handled()
		KEY_2, KEY_KP_2:
			select_category_tab(2)
			get_viewport().set_input_as_handled()
		KEY_3, KEY_KP_3:
			select_category_tab(3)
			get_viewport().set_input_as_handled()
		KEY_4, KEY_KP_4:
			select_category_tab(4)
			get_viewport().set_input_as_handled()
		KEY_KP_7:
			_navigate_prev_hud_block()
			get_viewport().set_input_as_handled()
		KEY_KP_9:
			_navigate_next_hud_block()
			get_viewport().set_input_as_handled()
		KEY_I:
			speak_hud_info()
			get_viewport().set_input_as_handled()
		KEY_C:
			open_character_sheet()
			get_viewport().set_input_as_handled()
		KEY_G:
			open_band_hub()
			get_viewport().set_input_as_handled()
		KEY_K:
			open_industry_hub()
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
		KEY_A:
			_on_btn_agenda_pressed()
			get_viewport().set_input_as_handled()
		KEY_V:
			open_travel_modal()
			get_viewport().set_input_as_handled()
		KEY_O:
			open_tour_modal()
			get_viewport().set_input_as_handled()
		KEY_F:
			open_festival_modal()
			get_viewport().set_input_as_handled()
		KEY_Y:
			open_social_modal()
			get_viewport().set_input_as_handled()
		KEY_H:
			open_chart_modal()
			get_viewport().set_input_as_handled()
		KEY_U:
			open_upgrades_modal()
			get_viewport().set_input_as_handled()
		KEY_P:
			open_album_creator()
			get_viewport().set_input_as_handled()
		KEY_T:
			_on_btn_speed_pressed()
			get_viewport().set_input_as_handled()
		KEY_SPACE:
			_on_btn_pause_pressed()
			get_viewport().set_input_as_handled()
		KEY_X:
			_on_btn_wait_pressed()
			get_viewport().set_input_as_handled()
		KEY_Z:
			_on_btn_sleep_pressed()
			get_viewport().set_input_as_handled()
		KEY_R:
			open_relax_modal()
			get_viewport().set_input_as_handled()
		KEY_W:
			open_legacy_modal()
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
	btn_band.text = tr("HUD_BTN_BAND")
	btn_industry.text = tr("HUD_BTN_INDUSTRY")
	btn_agenda.text = "Agenda (A)"
	btn_travel.text = "Viaggi (V)"
	if btn_tour:
		btn_tour.text = "Tour (O)"
	if btn_festival:
		btn_festival.text = "Festival (F)"
	if btn_social:
		btn_social.text = "Social (Y)"
	if btn_chart:
		btn_chart.text = "Classifiche (H)"
	if btn_legacy:
		btn_legacy.text = "Legacy (W)"
	
	var current_spd: float = GameManager.time_system.time_scale if GameManager and GameManager.time_system else 1.0
	btn_speed.text = tr("HUD_BTN_SPEED") % current_spd
	
	var is_paused: bool = GameManager.time_system.is_paused if GameManager.time_system else false
	btn_pause.text = tr("HUD_BTN_RESUME") if is_paused else tr("HUD_BTN_PAUSE")
	if btn_wait:
		btn_wait.text = "Aspetta (X)"
	if btn_sleep:
		btn_sleep.text = "Dormi (Z)"
	btn_save.text = tr("HUD_BTN_SAVE")
	btn_main_menu.text = tr("HUD_BTN_MAIN_MENU")
	
	# Hook AccessKit semantici per NVDA
	AccessibilityManager.hook_control_accessibility(btn_character, tr("HUD_BTN_CHARACTER_ACC_NAME"), tr("HUD_BTN_CHARACTER_ACC_DESC"))
	AccessibilityManager.hook_control_accessibility(btn_practice, tr("HUD_BTN_PRACTICE_ACC_NAME"), tr("HUD_BTN_PRACTICE_ACC_DESC"))
	if btn_relax:
		btn_relax.text = "Relax (R)"
		AccessibilityManager.hook_control_accessibility(btn_relax, "Relax e Recupero Attivo (R)", "Apre il menu per prendere un caffè, fare una passeggiata o ascoltare un disco.")
	AccessibilityManager.hook_control_accessibility(btn_catalog, tr("HUD_BTN_CATALOG_ACC_NAME"), tr("HUD_BTN_CATALOG_ACC_DESC"))
	AccessibilityManager.hook_control_accessibility(btn_new_song, tr("HUD_BTN_NEW_SONG_ACC_NAME"), tr("HUD_BTN_NEW_SONG_ACC_DESC"))
	AccessibilityManager.hook_control_accessibility(btn_concert, tr("HUD_BTN_CONCERT_ACC_NAME"), tr("HUD_BTN_CONCERT_ACC_DESC"))
	AccessibilityManager.hook_control_accessibility(btn_economy, tr("HUD_BTN_ECONOMY_ACC_NAME"), tr("HUD_BTN_ECONOMY_ACC_DESC"))
	AccessibilityManager.hook_control_accessibility(btn_band, tr("HUD_BTN_BAND_ACC_NAME"), tr("HUD_BTN_BAND_ACC_DESC"))
	AccessibilityManager.hook_control_accessibility(btn_industry, tr("HUD_BTN_INDUSTRY_ACC_NAME"), tr("HUD_BTN_INDUSTRY_ACC_DESC"))
	AccessibilityManager.hook_control_accessibility(btn_agenda, "Agenda Impegni Band", "Consulta gli impegni, concerti e scadenze dei prossimi 7 giorni (Tasto rapido A).")
	AccessibilityManager.hook_control_accessibility(btn_travel, "Mappa Geografica e Viaggi", "Esplora le scene musicali delle altre città e viaggia (Tasto rapido V).")
	AccessibilityManager.hook_control_accessibility(btn_speed, tr("HUD_BTN_SPEED_ACC_NAME"), tr("HUD_BTN_SPEED_ACC_DESC"))
	AccessibilityManager.hook_control_accessibility(btn_pause, tr("HUD_BTN_PAUSE_ACC_NAME"), tr("HUD_BTN_PAUSE_ACC_DESC"))
	if btn_wait:
		AccessibilityManager.hook_control_accessibility(btn_wait, "Aspetta fascia successiva (X)", "Avanza il tempo fino all'inizio della prossima fascia oraria.")
	if btn_sleep:
		AccessibilityManager.hook_control_accessibility(btn_sleep, "Vai a dormire (Z)", "Conclude in anticipo la giornata e va a dormire, ottenendo un bonus riposo se prima delle 04:00.")
	AccessibilityManager.hook_control_accessibility(btn_save, tr("HUD_BTN_SAVE_ACC_NAME"), tr("HUD_BTN_SAVE_ACC_DESC"))
	AccessibilityManager.hook_control_accessibility(btn_main_menu, tr("HUD_BTN_MAIN_MENU_ACC_NAME"), tr("HUD_BTN_MAIN_MENU_ACC_DESC"))
	
	if not action_system or not action_system.is_running:
		label_status.text = tr("HUD_STATUS_IDLE")

func _on_btn_agenda_pressed() -> void:
	if GameManager and GameManager.schedule_system:
		var speech: String = GameManager.schedule_system.get_linear_agenda_speech(7)
		AccessibilityManager.announce(speech, true)
		label_status.text = speech

func _on_btn_speed_pressed() -> void:
	if GameManager and GameManager.time_system:
		var new_spd: float = GameManager.time_system.cycle_speed()
		btn_speed.text = tr("HUD_BTN_SPEED") % new_spd
		var msg: String = tr("HUD_SPEED_CHANGED") % new_spd
		AccessibilityManager.announce(msg, true)

func _on_speed_changed(new_speed: float) -> void:
	btn_speed.text = tr("HUD_BTN_SPEED") % new_speed

# --- Instradamento Modali (Delegato a ModalRouter) ---

func open_catalog(show_albums: bool = false) -> void:
	if modal_router: modal_router.open_catalog(show_albums)

func close_catalog() -> void:
	if modal_router: modal_router.close_catalog()

func open_song_creator() -> void:
	if modal_router: modal_router.open_song_creator()

func close_song_creator() -> void:
	if modal_router: modal_router.close_song_creator()

func open_song_editor(song: SongData) -> void:
	if modal_router: modal_router.open_song_editor(song)

func open_live_concert() -> void:
	if modal_router: modal_router.open_live_concert()

func close_live_concert() -> void:
	if modal_router: modal_router.close_live_concert()

func open_economy_bank() -> void:
	if modal_router: modal_router.open_economy_bank()

func close_economy_bank() -> void:
	if modal_router: modal_router.close_economy_bank()

func open_character_sheet() -> void:
	if modal_router: modal_router.open_character_sheet()

func close_character_sheet() -> void:
	if modal_router: modal_router.close_character_sheet()

func open_band_hub() -> void:
	if modal_router: modal_router.open_band_hub()

func close_band_hub() -> void:
	if modal_router: modal_router.close_band_hub()

func open_album_creator() -> void:
	if modal_router: modal_router.open_album_creator()

func close_album_creator() -> void:
	if modal_router: modal_router.close_album_creator()

func open_industry_hub() -> void:
	if modal_router: modal_router.open_industry_hub()

func close_industry_hub() -> void:
	if modal_router: modal_router.close_industry_hub()

func open_travel_modal() -> void:
	if modal_router: modal_router.open_travel_modal()

func close_travel_modal() -> void:
	if modal_router: modal_router.close_travel_modal()

func open_tour_modal() -> void:
	if modal_router: modal_router.open_tour_modal()

func close_tour_modal() -> void:
	if modal_router: modal_router.close_tour_modal()

func open_festival_modal() -> void:
	if modal_router: modal_router.open_festival_modal()

func close_festival_modal() -> void:
	if modal_router: modal_router.close_festival_modal()

func open_social_modal() -> void:
	if modal_router: modal_router.open_social_modal()

func close_social_modal() -> void:
	if modal_router: modal_router.close_social_modal()

func open_chart_modal() -> void:
	if modal_router: modal_router.open_chart_modal()

func close_chart_modal() -> void:
	if modal_router: modal_router.close_chart_modal()

func open_system_menu() -> void:
	if modal_router: modal_router.open_system_menu()

func close_system_menu() -> void:
	if modal_router: modal_router.close_system_menu()

func open_upgrades_modal() -> void:
	if modal_router: modal_router.open_upgrades_modal()

func close_upgrades_modal() -> void:
	if modal_router: modal_router.close_upgrades_modal()

func open_relax_modal() -> void:
	if modal_router: modal_router.open_relax_modal()

func close_relax_modal() -> void:
	if modal_router: modal_router.close_relax_modal()

func open_legacy_modal() -> void:
	if modal_router: modal_router.open_legacy_modal()

func close_legacy_modal() -> void:
	if modal_router: modal_router.close_legacy_modal()

func open_daily_summary(summary_data: Dictionary) -> void:
	if modal_router: modal_router.open_daily_summary(summary_data)

func _on_dilemma_triggered(dilemma_dict: Dictionary) -> void:
	if modal_router: modal_router.on_dilemma_triggered(dilemma_dict)

func close_dilemma_modal() -> void:
	if modal_router: modal_router.close_dilemma_modal()

func select_category_tab(tab_idx: int) -> void:
	current_category_tab = tab_idx
	
	# Categoria 1: Hub Personale (Personaggio, Agenda, Bilancio, Viaggi, Allenamento, Relax)
	var is_personal: bool = (tab_idx == 1)
	if btn_character: btn_character.visible = is_personal
	if btn_agenda: btn_agenda.visible = is_personal
	if btn_economy: btn_economy.visible = is_personal
	if btn_travel: btn_travel.visible = is_personal
	if btn_practice: btn_practice.visible = is_personal
	if btn_relax: btn_relax.visible = is_personal
	
	# Categoria 2: Creazione & Produzione (Catalogo, Nuovo Brano)
	var is_creation: bool = (tab_idx == 2)
	if btn_catalog: btn_catalog.visible = is_creation
	if btn_new_song: btn_new_song.visible = is_creation
	
	# Categoria 3: Carriera & Band (Concerti, Band, Tour, Festival, Social, Classifiche, Industria, Legacy)
	var is_career: bool = (tab_idx == 3)
	if btn_concert: btn_concert.visible = is_career
	if btn_band: btn_band.visible = is_career
	if btn_tour: btn_tour.visible = is_career
	if btn_festival: btn_festival.visible = is_career
	if btn_social: btn_social.visible = is_career
	if btn_chart: btn_chart.visible = is_career
	if btn_industry: btn_industry.visible = is_career
	if btn_legacy: btn_legacy.visible = is_career
	
	# Categoria 4: Skills & Upgrade (Miglioramenti Alloggio/Sala/Strumenti)
	var is_upgrades: bool = (tab_idx == 4)
	if btn_upgrades: btn_upgrades.visible = is_upgrades
	
	# Focus, cue sonoro e annuncio vocale per NVDA
	match tab_idx:
		1:
			AccessibilityManager.play_cue(Enums.AudioCueType.AREA_PERSONAL)
			if btn_tab_personal: btn_tab_personal.grab_focus()
			AccessibilityManager.speak("Area 1: Hub Personale. Opzioni: Personaggio C, Agenda A, Bilancio B, Viaggi V, Allenamento Rapido 1, Relax R.")
		2:
			AccessibilityManager.play_cue(Enums.AudioCueType.AREA_CREATION)
			if btn_tab_creation: btn_tab_creation.grab_focus()
			AccessibilityManager.speak("Area 2: Creazione e Produzione. Opzioni: Catalogo M, Nuovo Brano N, Album P.")
		3:
			AccessibilityManager.play_cue(Enums.AudioCueType.AREA_CAREER)
			if btn_tab_career: btn_tab_career.grab_focus()
			AccessibilityManager.speak("Area 3: Carriera e Band. Opzioni: Concerti L, Band G, Tour O, Festival F, Social Y, Classifiche H, Industria K, Legacy W.")
		4:
			AccessibilityManager.play_cue(Enums.AudioCueType.AREA_UPGRADES)
			if btn_tab_upgrades: btn_tab_upgrades.grab_focus()
			AccessibilityManager.speak("Area 4: Skills e Upgrade. Opzioni: Miglioramenti e Strumentazione U.")

var _current_hud_block_index: int = 1

func _navigate_next_hud_block() -> void:
	_current_hud_block_index = (_current_hud_block_index + 1) % 3
	_focus_hud_block(_current_hud_block_index)

func _navigate_prev_hud_block() -> void:
	_current_hud_block_index = (_current_hud_block_index - 1 + 3) % 3
	_focus_hud_block(_current_hud_block_index)

func _focus_hud_block(block_idx: int) -> void:
	match block_idx:
		0:
			if btn_pause: btn_pause.grab_focus()
			AccessibilityManager.speak("Blocco Top Bar selezionato: controlli orologio, velocità e pausa.")
		1:
			match current_category_tab:
				1: if btn_tab_personal: btn_tab_personal.grab_focus()
				2: if btn_tab_creation: btn_tab_creation.grab_focus()
				3: if btn_tab_career: btn_tab_career.grab_focus()
				4: if btn_tab_upgrades: btn_tab_upgrades.grab_focus()
				_: if btn_tab_personal: btn_tab_personal.grab_focus()
			AccessibilityManager.speak("Blocco Macro-Aree tematiche selezionato: Area %d attiva." % current_category_tab)
		2:
			_focus_first_visible_action()
			AccessibilityManager.speak("Blocco Azioni rapide selezionato per l'Area %d." % current_category_tab)

func _focus_first_visible_action() -> void:
	match current_category_tab:
		1:
			if btn_character and btn_character.visible: btn_character.grab_focus()
		2:
			if btn_catalog and btn_catalog.visible: btn_catalog.grab_focus()
		3:
			if btn_concert and btn_concert.visible: btn_concert.grab_focus()
		4:
			if btn_upgrades and btn_upgrades.visible: btn_upgrades.grab_focus()

func speak_hud_info() -> void:
	var info_text: String = ""
	if label_time:
		info_text += label_time.text + ". "
	if label_energy:
		info_text += label_energy.text + ", "
	if label_stress:
		info_text += label_stress.text + ", "
	if label_morale:
		info_text += label_morale.text + ", "
	if label_money:
		info_text += label_money.text + ". "
	if GameManager and GameManager.time_system:
		var speed_str: String = "1x"
		match GameManager.time_system.time_scale:
			1.0: speed_str = "1x normale"
			2.0: speed_str = "2x veloce"
			3.0: speed_str = "3x rapida"
		var paused_str: String = "In pausa" if GameManager.time_system.is_paused else "In esecuzione"
		info_text += "Simulazione %s a velocità %s." % [paused_str, speed_str]
	AccessibilityManager.speak(info_text)



func _update_hud_display() -> void:
	if GameManager.calendar_data:
		var cd: CalendarData = GameManager.calendar_data
		var t_str: String = cd.get_formatted_time_string()
		var p_str: String = _get_localized_period(cd.current_period)
		var d_num: int = cd.day_number
		var w_name: String = cd.get_weekday_name()
		var s_name: String = cd.get_season_name()
		var y_num: int = cd.get_year()
		label_time.text = "Giorno %d (%s) — Ore %s (%s) [%s A%d]" % [d_num, w_name, t_str, p_str, s_name, y_num]
		label_time.set_accessibility_name("Orologio: Giorno %d, %s, ore %s, %s. Stagione %s, Anno %d" % [d_num, w_name, t_str, p_str, s_name, y_num])
		
	if GameManager.player_data:
		label_energy.text = tr("HUD_ENERGY") % GameManager.player_data.energy
		if label_stress:
			label_stress.text = tr("HUD_STRESS") % GameManager.player_data.stress
		if label_morale:
			label_morale.text = tr("HUD_MORALE") % GameManager.player_data.morale
		label_money.text = tr("HUD_MONEY") % GameManager.player_data.money
		
		if label_player_summary:
			var city_name: String = GameManager.player_data.get_current_city_name()
			var tier_name: String = "Principiante"
			if GameManager.career_system:
				tier_name = GameManager.career_system.get_tier_name(GameManager.player_data.career_tier)
				
			var lv_songwriting: int = GameManager.player_data.get_skill_level("songwriting")
			var lv_comp: int = GameManager.player_data.get_skill_level("composition")
			var lv_inst: int = GameManager.player_data.get_skill_level("instrument")
			var lv_prod: int = GameManager.player_data.get_skill_level("production")
			var inst_name: String = GameManager.player_data.primary_instrument.capitalize()
			
			var summary_text: String = "Città: %s | Status: %s | Livello: Scrittura testi Lv. %d, Composizione Lv. %d, %s Lv. %d, Produzione Lv. %d" % [
				city_name,
				tier_name,
				lv_songwriting,
				lv_comp,
				inst_name,
				lv_inst,
				lv_prod
			]
			label_player_summary.text = summary_text
			label_player_summary.set_accessibility_name("Panoramica Carriera: %s" % summary_text)

func _on_time_ticked(_remaining_sec: float, _time_str: String, _period: int) -> void:
	_update_hud_display()

func _on_btn_practice_pressed() -> void:
	if action_system:
		action_system.start_action(quick_practice_action)

func _on_btn_pause_pressed() -> void:
	if GameManager.time_system:
		var paused: bool = GameManager.time_system.toggle_pause()
		btn_pause.text = tr("HUD_BTN_RESUME") if paused else tr("HUD_BTN_PAUSE")

func _on_btn_wait_pressed() -> void:
	if _is_any_modal_open():
		return
	if GameManager and GameManager.time_system:
		var advanced: bool = GameManager.time_system.skip_to_next_period()
		if not advanced:
			AccessibilityManager.announce("Impossibile avanzare: giornata al termine o già a notte inoltrata.", true)

func _on_btn_sleep_pressed() -> void:
	if _is_any_modal_open():
		return
	if GameManager and GameManager.time_system:
		GameManager.time_system.sleep_early()

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
