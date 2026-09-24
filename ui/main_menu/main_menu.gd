# res://ui/main_menu/main_menu.gd
extends Control

## Controller della Schermata del Menu Principale e Impostazioni di World-tour
## Conforme al principio di Simmetria Universale (Luca con NVDA/tastiera e Holy Diver a monitor).

@onready var label_title: Label = $CenterContainer/VBoxMain/Header/LabelTitle
@onready var label_subtitle: Label = $CenterContainer/VBoxMain/Header/LabelSubtitle
@onready var vbox_menu: VBoxContainer = $CenterContainer/VBoxMain/VBoxMenu
@onready var btn_new_game: Button = $CenterContainer/VBoxMain/VBoxMenu/BtnNewGame
@onready var btn_load_game: Button = $CenterContainer/VBoxMain/VBoxMenu/BtnLoadGame
@onready var btn_settings: Button = $CenterContainer/VBoxMain/VBoxMenu/BtnSettings
@onready var btn_quit: Button = $CenterContainer/VBoxMain/VBoxMenu/BtnQuit
@onready var btn_quick_start: Button = $CenterContainer/VBoxMain/VBoxMenu/BtnQuickStart

# Pannello Impostazioni
@onready var panel_settings: PanelContainer = $CenterContainer/VBoxMain/PanelSettings
@onready var label_settings_title: Label = $CenterContainer/VBoxMain/PanelSettings/VBoxSettings/LabelSettingsTitle
@onready var label_lang: Label = $CenterContainer/VBoxMain/PanelSettings/VBoxSettings/HBoxLang/LabelLang
@onready var opt_lang: OptionButton = $CenterContainer/VBoxMain/PanelSettings/VBoxSettings/HBoxLang/OptLang
@onready var label_day_duration: Label = $CenterContainer/VBoxMain/PanelSettings/VBoxSettings/HBoxDayDuration/LabelDayDuration
@onready var opt_day_duration: OptionButton = $CenterContainer/VBoxMain/PanelSettings/VBoxSettings/HBoxDayDuration/OptDayDuration
@onready var btn_back_settings: Button = $CenterContainer/VBoxMain/PanelSettings/VBoxSettings/BtnBackSettings

func _ready() -> void:
	# Imposta stato FSM globale
	if GameManager:
		GameManager.change_state(Enums.GameState.MAIN_MENU)
		
	# Inizializzazione opzioni lingua e durata giornata
	_populate_language_options()
	_populate_day_duration_options()
	
	# Connessione segnali bottoni
	if not btn_new_game.pressed.is_connected(_on_new_game_pressed):
		btn_new_game.pressed.connect(_on_new_game_pressed)
	if not btn_load_game.pressed.is_connected(_on_load_game_pressed):
		btn_load_game.pressed.connect(_on_load_game_pressed)
	if not btn_settings.pressed.is_connected(_on_settings_pressed):
		btn_settings.pressed.connect(_on_settings_pressed)
	if not btn_quit.pressed.is_connected(_on_quit_pressed):
		btn_quit.pressed.connect(_on_quit_pressed)
	if not btn_quick_start.pressed.is_connected(_on_quick_start_pressed):
		btn_quick_start.pressed.connect(_on_quick_start_pressed)
	if not btn_back_settings.pressed.is_connected(_on_back_settings_pressed):
		btn_back_settings.pressed.connect(_on_back_settings_pressed)
	if not opt_lang.item_selected.is_connected(_on_language_selected):
		opt_lang.item_selected.connect(_on_language_selected)
	if not opt_day_duration.item_selected.is_connected(_on_day_duration_selected):
		opt_day_duration.item_selected.connect(_on_day_duration_selected)
	
	# Connessione al bus per cambio lingua
	if not EventBus.language_changed.is_connected(_on_language_changed):
		EventBus.language_changed.connect(_on_language_changed)
	
	# Assicura che il pannello impostazioni sia nascosto all'inizio
	panel_settings.visible = false
	vbox_menu.visible = true
	
	# Aggiorna testi secondo la lingua corrente
	_refresh_ui_text()
	
	# Auto-focus sul primo elemento (Nuova Partita)
	btn_new_game.grab_focus()

func _populate_language_options() -> void:
	opt_lang.clear()
	opt_lang.add_item("Italiano", 0)
	opt_lang.set_item_metadata(0, "it")
	opt_lang.add_item("English", 1)
	opt_lang.set_item_metadata(1, "en")
	
	var cur_lang: String = LocalizationManager.get_current_language() if LocalizationManager else "it"
	if cur_lang == "en":
		opt_lang.select(1)
	else:
		opt_lang.select(0)

func _populate_day_duration_options() -> void:
	opt_day_duration.clear()
	opt_day_duration.add_item("5 Minuti (Default)", 0)
	opt_day_duration.set_item_metadata(0, 300.0)
	opt_day_duration.add_item("10 Minuti", 1)
	opt_day_duration.set_item_metadata(1, 600.0)
	opt_day_duration.add_item("15 Minuti", 2)
	opt_day_duration.set_item_metadata(2, 900.0)
	opt_day_duration.add_item("20 Minuti", 3)
	opt_day_duration.set_item_metadata(3, 1200.0)
	
	var cur_dur: float = SaveManager.get_day_duration() if SaveManager else Constants.DEFAULT_DAY_DURATION_SECONDS
	if is_equal_approx(cur_dur, 600.0):
		opt_day_duration.select(1)
	elif is_equal_approx(cur_dur, 900.0):
		opt_day_duration.select(2)
	elif is_equal_approx(cur_dur, 1200.0):
		opt_day_duration.select(3)
	else:
		opt_day_duration.select(0)

func _refresh_ui_text() -> void:
	# Aggiorna testi a video (Holy Diver)
	label_title.text = tr("GAME_TITLE")
	label_subtitle.text = tr("GAME_SUBTITLE")
	btn_new_game.text = tr("MENU_NEW_GAME").to_upper()
	btn_load_game.text = tr("MENU_LOAD_GAME").to_upper()
	btn_settings.text = tr("MENU_SETTINGS").to_upper()
	btn_quit.text = tr("MENU_QUIT_DESKTOP").to_upper()
	btn_quick_start.text = tr("MENU_TEST_MODE")
	
	label_settings_title.text = tr("SETTINGS_TITLE").to_upper()
	label_lang.text = tr("SETTINGS_LANGUAGE_LABEL")
	label_day_duration.text = "Durata Giornata:"
	btn_back_settings.text = tr("SETTINGS_BACK").to_upper()
	
	# Configurazione semantica per Screen Reader NVDA (Luca)
	AccessibilityManager.hook_control_accessibility(btn_new_game, tr("MENU_NEW_GAME"), tr("MENU_NEW_GAME_DESC"))
	
	var load_desc: String = tr("MENU_LOAD_GAME_DESC")
	var has_save: bool = SaveManager.has_savegame() if SaveManager else false
	if not has_save:
		load_desc += " (" + tr("MENU_LOAD_GAME_NO_SAVE") + ")"
	AccessibilityManager.hook_control_accessibility(btn_load_game, tr("MENU_LOAD_GAME"), load_desc)
	
	AccessibilityManager.hook_control_accessibility(btn_settings, tr("MENU_SETTINGS"), tr("MENU_SETTINGS_DESC"))
	AccessibilityManager.hook_control_accessibility(btn_quit, tr("MENU_QUIT_DESKTOP"), tr("MENU_QUIT_DESKTOP_DESC"))
	AccessibilityManager.hook_control_accessibility(btn_quick_start, tr("MENU_TEST_MODE"), tr("MENU_TEST_MODE_DESC"))
	AccessibilityManager.hook_control_accessibility(opt_lang, tr("SETTINGS_LANGUAGE_LABEL"), tr("SETTINGS_LANGUAGE_DESC"))
	AccessibilityManager.hook_control_accessibility(opt_day_duration, "Durata Giornata", "Seleziona la durata reale di ogni giornata di gioco: 5, 10, 15 o 20 minuti.")
	AccessibilityManager.hook_control_accessibility(btn_back_settings, tr("SETTINGS_BACK"), tr("SETTINGS_BACK_DESC"))

func _on_new_game_pressed() -> void:
	# Apre la schermata di creazione e personalizzazione del personaggio
	get_tree().change_scene_to_file.call_deferred("res://ui/character/character_creation.tscn")

func _on_load_game_pressed() -> void:
	if not SaveManager or not SaveManager.has_savegame():
		AccessibilityManager.announce(tr("MENU_LOAD_GAME_NO_SAVE"), true)
		return
	
	var success: bool = SaveManager.load_game()
	if success:
		AccessibilityManager.announce("Partita caricata con successo. Accesso alla simulazione.", true)
		get_tree().change_scene_to_file.call_deferred("res://ui/hud/hud.tscn")
	else:
		AccessibilityManager.announce("Impossibile caricare la partita salvata.", true)

func _on_quick_start_pressed() -> void:
	# Inizializza partita in modalità test (con 10 brani dello starter pack e 500 € di liquidità)
	if GameManager:
		GameManager.start_new_game("Alex", "Chitarra Elettrica", "self_taught", true)
	# Avvia HUD di simulazione
	get_tree().change_scene_to_file.call_deferred("res://ui/hud/hud.tscn")

func _on_settings_pressed() -> void:
	vbox_menu.visible = false
	panel_settings.visible = true
	_populate_language_options()
	_populate_day_duration_options()
	opt_lang.grab_focus()

func _on_back_settings_pressed() -> void:
	panel_settings.visible = false
	vbox_menu.visible = true
	btn_settings.grab_focus()

func _on_language_selected(index: int) -> void:
	var selected_code: String = str(opt_lang.get_item_metadata(index))
	if LocalizationManager:
		LocalizationManager.set_language(selected_code, true)

func _on_day_duration_selected(index: int) -> void:
	var dur: float = float(opt_day_duration.get_item_metadata(index))
	if SaveManager:
		SaveManager.set_day_duration(dur)
	if GameManager and GameManager.calendar_data:
		GameManager.calendar_data.day_duration = dur
		GameManager.calendar_data.remaining_seconds = dur
		GameManager.calendar_data.update_period()
	var mins: int = int(dur / 60.0)
	AccessibilityManager.announce("Durata della giornata impostata a %d minuti." % mins, true)

func _on_language_changed(new_lang: String) -> void:
	_refresh_ui_text()
	var msg: String = tr("SETTINGS_LANG_CHANGED_ANNOUNCEMENT")
	AccessibilityManager.announce(msg, true)

func _on_quit_pressed() -> void:
	get_tree().quit()

func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventKey) or not event.is_pressed() or event.is_echo():
		return
	var key_event := event as InputEventKey
	if key_event.keycode == KEY_ESCAPE:
		if panel_settings.visible:
			_on_back_settings_pressed()
			get_viewport().set_input_as_handled()
	elif key_event.keycode == KEY_T:
		# Scorciatoia rapida sviluppatore per modalità collaudo
		if vbox_menu.visible and not panel_settings.visible:
			AccessibilityManager.announce("Avvio rapido modalità test.", true)
			_on_quick_start_pressed()
			get_viewport().set_input_as_handled()
