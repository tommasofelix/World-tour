# res://ui/system_menu/system_menu_modal.gd
extends Control

## Modale Menu di Sistema & Pausa (Tasto Esc) di World-tour
## Implementa il menu a due livelli per pausa, salvataggio immediato,
## statistiche globali di carriera, impostazioni di accessibilità/lingua e ritorno al menu principale.
## Conforme a Simmetria Universale (Luca con NVDA/tastiera, Holy Diver a monitor).

signal resume_requested
signal save_requested
signal main_menu_requested

@onready var backdrop: ColorRect = $Backdrop
@onready var panel_main: PanelContainer = $PanelMain
@onready var label_title: Label = $PanelMain/Margin/VBox/LabelTitle
@onready var label_subtitle: Label = $PanelMain/Margin/VBox/LabelSubtitle
@onready var vbox_menu: VBoxContainer = $PanelMain/Margin/VBox/VBoxMenu
@onready var btn_resume: Button = $PanelMain/Margin/VBox/VBoxMenu/BtnResume
@onready var btn_save: Button = $PanelMain/Margin/VBox/VBoxMenu/BtnSave
@onready var btn_career_stats: Button = $PanelMain/Margin/VBox/VBoxMenu/BtnCareerStats
@onready var btn_settings: Button = $PanelMain/Margin/VBox/VBoxMenu/BtnSettings
@onready var btn_main_menu: Button = $PanelMain/Margin/VBox/VBoxMenu/BtnMainMenu
@onready var label_feedback: Label = $PanelMain/Margin/VBox/LabelFeedback

# Pannello Statistiche di Carriera
@onready var panel_career_stats: PanelContainer = $PanelMain/Margin/VBox/PanelCareerStats
@onready var label_life_stats: Label = $PanelMain/Margin/VBox/PanelCareerStats/Margin/VBoxCareerStats/ScrollStats/VBoxContent/LabelLifeStats
@onready var label_music_stats: Label = $PanelMain/Margin/VBox/PanelCareerStats/Margin/VBoxCareerStats/ScrollStats/VBoxContent/LabelMusicStats
@onready var label_live_stats: Label = $PanelMain/Margin/VBox/PanelCareerStats/Margin/VBoxCareerStats/ScrollStats/VBoxContent/LabelLiveStats
@onready var label_glory_stats: Label = $PanelMain/Margin/VBox/PanelCareerStats/Margin/VBoxCareerStats/ScrollStats/VBoxContent/LabelGloryStats
@onready var btn_read_speech: Button = $PanelMain/Margin/VBox/PanelCareerStats/Margin/VBoxCareerStats/HBoxStatsButtons/BtnReadSpeech
@onready var btn_back_stats: Button = $PanelMain/Margin/VBox/PanelCareerStats/Margin/VBoxCareerStats/HBoxStatsButtons/BtnBackStats

# Pannello Impostazioni interno
@onready var panel_settings: PanelContainer = $PanelMain/Margin/VBox/PanelSettings
@onready var label_settings_title: Label = $PanelMain/Margin/VBox/PanelSettings/Margin/VBoxSettings/LabelSettingsTitle
@onready var label_audio_info: Label = $PanelMain/Margin/VBox/PanelSettings/Margin/VBoxSettings/LabelAudioInfo
@onready var opt_lang: OptionButton = $PanelMain/Margin/VBox/PanelSettings/Margin/VBoxSettings/HBoxLang/OptLang
@onready var opt_day_duration: OptionButton = $PanelMain/Margin/VBox/PanelSettings/Margin/VBoxSettings/HBoxDayDuration/OptDayDuration
@onready var btn_back_settings: Button = $PanelMain/Margin/VBox/PanelSettings/Margin/VBoxSettings/BtnBackSettings

# Stato conferma uscita
var _confirming_main_menu: bool = false

func _ready() -> void:
	visible = false
	if panel_career_stats:
		panel_career_stats.visible = false
	if panel_settings:
		panel_settings.visible = false
	if label_feedback:
		label_feedback.text = ""

	btn_resume.pressed.connect(_on_resume_pressed)
	btn_save.pressed.connect(_on_save_pressed)
	if btn_career_stats:
		btn_career_stats.pressed.connect(_on_career_stats_pressed)
	btn_settings.pressed.connect(_on_settings_pressed)
	btn_main_menu.pressed.connect(_on_main_menu_pressed)
	btn_back_settings.pressed.connect(_on_back_settings_pressed)
	if btn_read_speech:
		btn_read_speech.pressed.connect(_on_read_speech_pressed)
	if btn_back_stats:
		btn_back_stats.pressed.connect(_on_back_stats_pressed)

	_populate_settings_options()
	_hook_accessibility()

func _hook_accessibility() -> void:
	AccessibilityManager.hook_control_accessibility(btn_resume, "Riprendi Partita (Esc o 1)", "Chiude il menu di sistema e riprende la simulazione.")
	AccessibilityManager.hook_control_accessibility(btn_save, "Salva Partita (2)", "Esegue il salvataggio immediato sul file savegame.json.")
	if btn_career_stats:
		AccessibilityManager.hook_control_accessibility(btn_career_stats, "Statistiche di Carriera (3)", "Apre la dashboard con lo storico completo delle metriche di vita e palco.")
	AccessibilityManager.hook_control_accessibility(btn_settings, "Impostazioni e Accessibilità (4)", "Apre le opzioni di lingua, volume e durata della giornata.")
	AccessibilityManager.hook_control_accessibility(btn_main_menu, "Torna al Menu Principale (5)", "Esce dalla partita corrente e torna alla schermata iniziale.")
	if btn_read_speech:
		AccessibilityManager.hook_control_accessibility(btn_read_speech, "Ascolta Riepilogo Vocale Completo (R)", "Legge vocalmente il resoconto completo di carriera per NVDA.")
	if btn_back_stats:
		AccessibilityManager.hook_control_accessibility(btn_back_stats, "Torna al Menu di Sistema (Esc)", "Ritorna all'elenco principale del menu di pausa.")

func _populate_settings_options() -> void:
	if opt_lang:
		opt_lang.clear()
		opt_lang.add_item("Italiano", 0)
		opt_lang.set_item_metadata(0, "it")
		opt_lang.add_item("English", 1)
		opt_lang.set_item_metadata(1, "en")

		var cur_lang: String = LocalizationManager.get_current_language() if LocalizationManager else "it"
		opt_lang.selected = 1 if cur_lang == "en" else 0
		opt_lang.item_selected.connect(_on_language_selected)

	if opt_day_duration:
		opt_day_duration.clear()
		opt_day_duration.add_item("Rapida (3 minuti)", 0)
		opt_day_duration.add_item("Standard (5 minuti - Predefinita)", 1)
		opt_day_duration.add_item("Rilassata (10 minuti)", 2)
		opt_day_duration.selected = 1
		opt_day_duration.item_selected.connect(_on_day_duration_selected)

func open() -> void:
	visible = true
	_confirming_main_menu = false
	if label_feedback:
		label_feedback.text = ""
	if panel_career_stats:
		panel_career_stats.visible = false
	if panel_settings:
		panel_settings.visible = false
	if vbox_menu:
		vbox_menu.visible = true

	btn_resume.grab_focus()
	AccessibilityManager.speak(
		"Menu di Sistema aperto in Pausa. Opzioni: 1 Riprendi, 2 Salva, 3 Statistiche di Carriera, 4 Impostazioni, 5 Torna al Menu Principale. Premi Esc per riprendere."
	)

func close() -> void:
	visible = false
	resume_requested.emit()

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if not (event is InputEventKey) or not event.is_pressed() or event.is_echo():
		return

	match event.keycode:
		KEY_ESCAPE:
			if panel_career_stats and panel_career_stats.visible:
				_on_back_stats_pressed()
			elif panel_settings and panel_settings.visible:
				_on_back_settings_pressed()
			elif _confirming_main_menu:
				_confirming_main_menu = false
				btn_main_menu.text = "5. Torna al Menu Principale"
				label_feedback.text = "Uscita annullata."
				AccessibilityManager.speak("Uscita al menu principale annullata.")
			else:
				_on_resume_pressed()
			get_viewport().set_input_as_handled()
		KEY_1, KEY_KP_1:
			if not (panel_settings and panel_settings.visible) and not (panel_career_stats and panel_career_stats.visible):
				_on_resume_pressed()
				get_viewport().set_input_as_handled()
		KEY_2, KEY_KP_2:
			if not (panel_settings and panel_settings.visible) and not (panel_career_stats and panel_career_stats.visible):
				_on_save_pressed()
				get_viewport().set_input_as_handled()
		KEY_3, KEY_KP_3:
			if not (panel_settings and panel_settings.visible) and not (panel_career_stats and panel_career_stats.visible):
				_on_career_stats_pressed()
				get_viewport().set_input_as_handled()
		KEY_4, KEY_KP_4:
			if not (panel_settings and panel_settings.visible) and not (panel_career_stats and panel_career_stats.visible):
				_on_settings_pressed()
				get_viewport().set_input_as_handled()
		KEY_5:
			if not (panel_settings and panel_settings.visible) and not (panel_career_stats and panel_career_stats.visible):
				_on_main_menu_pressed()
				get_viewport().set_input_as_handled()
		KEY_R:
			if panel_career_stats and panel_career_stats.visible:
				_on_read_speech_pressed()
				get_viewport().set_input_as_handled()
		KEY_ENTER, KEY_KP_ENTER:
			if _confirming_main_menu:
				_execute_main_menu_exit()
				get_viewport().set_input_as_handled()

func _on_resume_pressed() -> void:
	close()

func _on_save_pressed() -> void:
	if not SaveManager.is_save_allowed():
		label_feedback.text = "Impossibile salvare adesso (attività in corso)."
		AccessibilityManager.speak("Impossibile salvare in questo momento, operazione non consentita.")
		return

	var success: bool = SaveManager.save_game()
	if success:
		label_feedback.text = "Partita salvata con successo!"
		AccessibilityManager.speak("Partita salvata con successo nel file savegame.json.")
	else:
		label_feedback.text = "Errore durante il salvataggio."
		AccessibilityManager.speak("Errore durante il salvataggio della partita.")

func _on_career_stats_pressed() -> void:
	_confirming_main_menu = false
	btn_main_menu.text = "5. Torna al Menu Principale"
	vbox_menu.visible = false
	_refresh_career_stats_display()
	panel_career_stats.visible = true
	btn_read_speech.grab_focus()

	var speech_text: String = "Pannello Statistiche di Carriera aperto. "
	if GameManager and GameManager.player_data:
		speech_text += GameManager.player_data.get_linear_career_summary_speech()
	speech_text += " Premi R per riascoltare o Esc per tornare al menu."
	AccessibilityManager.speak(speech_text)

func _refresh_career_stats_display() -> void:
	if not GameManager or not GameManager.player_data:
		return

	var p: PlayerData = GameManager.player_data
	var days: int = int(p.get_career_stat("total_days_active", 1))
	var overtime: int = int(p.get_career_stat("total_overtime_nights", 0))
	var housing_name: String = HousingData.get_tier_name(p.current_housing_tier)
	var songs_written: int = int(p.get_career_stat("total_songs_written", 0))
	var singles: int = int(p.get_career_stat("total_singles_released", 0))
	var albums: int = int(p.get_career_stat("total_albums_released", 0))
	var streams: int = p.get_total_streams()
	var records_sold: float = p.get_total_records_sold()

	var concerts: int = int(p.get_career_stat("total_concerts_performed", 0))
	var audience: int = int(p.get_career_stat("total_audience_attended", 0))
	var live_earn: float = float(p.get_career_stat("total_live_earnings", 0.0))
	var merch_earn: float = float(p.get_career_stat("total_merch_earnings", 0.0))
	var encores: int = int(p.get_career_stat("total_encores_granted", 0))
	var stadiums: int = int(p.get_career_stat("total_stadium_concerts", 0))
	var stadium_sold_outs: int = int(p.get_career_stat("stadium_sold_outs", 0))
	var festivals: int = int(p.get_career_stat("total_festivals_performed", 0))
	var tours: int = int(p.get_career_stat("total_tours_completed", 0))

	var gold_count: int = p.get_certifications_count(Enums.CertificationTier.GOLD)
	var plat_count: int = p.get_certifications_count(Enums.CertificationTier.PLATINUM)
	var diam_count: int = p.get_certifications_count(Enums.CertificationTier.DIAMOND)
	var weeks_top1: int = int(p.get_career_stat("weeks_at_number_one", 0))
	var total_earn: float = p.get_total_career_earnings()

	if label_life_stats:
		label_life_stats.text = "Giorni attivi: %d | Notti in overtime: %d | Alloggio: %s | Saldo: %.2f € | Guadagni stimati: %.2f €" % [
			days, overtime, housing_name, p.money, total_earn
		]
	if label_music_stats:
		label_music_stats.text = "Brani composti: %d | Singoli: %d | Album: %d | Copie vendute: %.0f | Stream totali: %d" % [
			songs_written, singles, albums, records_sold, streams
		]
	if label_live_stats:
		label_live_stats.text = "Concerti: %d (Stadi: %d, Sold-out: %d) | Spettatori: %d | Incassi live: %.2f € | Merch: %.2f € | Bis: %d | Festival: %d | Tour: %d" % [
			concerts, stadiums, stadium_sold_outs, audience, live_earn, merch_earn, encores, festivals, tours
		]
	if label_glory_stats:
		var hof_str: String = "Sì" if p.hall_of_fame_inducted else "Non ancora"
		label_glory_stats.text = "Fan mondiali: %d | Dischi d'Oro: %d | Platino: %d | Diamante: %d | Settimane #1: %d | Hall of Fame: %s" % [
			p.fans, gold_count, plat_count, diam_count, weeks_top1, hof_str
		]

func _on_read_speech_pressed() -> void:
	if GameManager and GameManager.player_data:
		AccessibilityManager.speak(GameManager.player_data.get_linear_career_summary_speech())

func _on_back_stats_pressed() -> void:
	panel_career_stats.visible = false
	vbox_menu.visible = true
	btn_career_stats.grab_focus()
	AccessibilityManager.speak("Ritorno al Menu di Sistema.")

func _on_settings_pressed() -> void:
	_confirming_main_menu = false
	btn_main_menu.text = "5. Torna al Menu Principale"
	vbox_menu.visible = false
	panel_settings.visible = true
	btn_back_settings.grab_focus()
	AccessibilityManager.speak(
		"Pannello Impostazioni. Volume calibrato su standard anti-mascheramento. Puoi modificare la lingua e la durata della giornata. Premi Esc o il pulsante Torna per uscire."
	)

func _on_back_settings_pressed() -> void:
	panel_settings.visible = false
	vbox_menu.visible = true
	btn_settings.grab_focus()
	AccessibilityManager.speak("Ritorno al Menu di Sistema.")

func _on_language_selected(index: int) -> void:
	var lang: String = opt_lang.get_item_metadata(index)
	if LocalizationManager:
		LocalizationManager.set_language(lang)
	AccessibilityManager.speak("Lingua impostata su: " + opt_lang.get_item_text(index))

func _on_day_duration_selected(index: int) -> void:
	var seconds: float = 300.0
	match index:
		0: seconds = 180.0
		1: seconds = 300.0
		2: seconds = 600.0
	if GameManager and GameManager.calendar_data:
		GameManager.calendar_data.total_day_seconds = seconds
	AccessibilityManager.speak("Durata giornata impostata su: " + opt_day_duration.get_item_text(index))

func _on_main_menu_pressed() -> void:
	if not _confirming_main_menu:
		_confirming_main_menu = true
		btn_main_menu.text = "Premi INVIO per Confermare Uscita (o ESC per annullare)"
		label_feedback.text = "I progressi non salvati andranno persi. Premi INVIO per confermare, ESC per annullare."
		AccessibilityManager.speak("Attenzione: confermi l'uscita al Menu Principale? I dati non salvati andranno persi. Premi Invio per confermare, oppure Esc per annullare.")
	else:
		_execute_main_menu_exit()

func _execute_main_menu_exit() -> void:
	main_menu_requested.emit()
	if SaveManager.is_save_allowed():
		SaveManager.save_game()
	get_tree().change_scene_to_file("res://ui/main_menu/main_menu.tscn")
