# res://ui/main_menu/main_menu.gd
extends Control

## Controller della Schermata del Menu Principale e Impostazioni di World-tour
## Conforme al principio di Simmetria Universale (Luca con NVDA/tastiera e Holy Diver a monitor).

@onready var label_title: Label = $CenterContainer/VBoxMain/Header/LabelTitle
@onready var label_subtitle: Label = $CenterContainer/VBoxMain/Header/LabelSubtitle
@onready var vbox_menu: VBoxContainer = $CenterContainer/VBoxMain/VBoxMenu
@onready var btn_quick_start: Button = $CenterContainer/VBoxMain/VBoxMenu/BtnQuickStart
@onready var btn_settings: Button = $CenterContainer/VBoxMain/VBoxMenu/BtnSettings
@onready var btn_quit: Button = $CenterContainer/VBoxMain/VBoxMenu/BtnQuit

# Pannello Impostazioni
@onready var panel_settings: PanelContainer = $CenterContainer/VBoxMain/PanelSettings
@onready var label_settings_title: Label = $CenterContainer/VBoxMain/PanelSettings/VBoxSettings/LabelSettingsTitle
@onready var label_lang: Label = $CenterContainer/VBoxMain/PanelSettings/VBoxSettings/HBoxLang/LabelLang
@onready var opt_lang: OptionButton = $CenterContainer/VBoxMain/PanelSettings/VBoxSettings/HBoxLang/OptLang
@onready var btn_back_settings: Button = $CenterContainer/VBoxMain/PanelSettings/VBoxSettings/BtnBackSettings

func _ready() -> void:
	# Imposta stato FSM globale
	if GameManager:
		GameManager.change_state(Enums.GameState.MAIN_MENU)
		
	# Inizializzazione opzioni lingua
	_populate_language_options()
	
	# Connessione segnali bottoni
	btn_quick_start.pressed.connect(_on_quick_start_pressed)
	btn_settings.pressed.connect(_on_settings_pressed)
	btn_quit.pressed.connect(_on_quit_pressed)
	btn_back_settings.pressed.connect(_on_back_settings_pressed)
	opt_lang.item_selected.connect(_on_language_selected)
	
	# Connessione al bus per cambio lingua
	EventBus.language_changed.connect(_on_language_changed)
	
	# Assicura che il pannello impostazioni sia nascosto all'inizio
	panel_settings.visible = false
	vbox_menu.visible = true
	
	# Aggiorna testi secondo la lingua corrente
	_refresh_ui_text()
	
	# Auto-focus sul primo elemento
	btn_quick_start.grab_focus()

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

func _refresh_ui_text() -> void:
	# Aggiorna testi a video (Holy Diver)
	label_title.text = tr("GAME_TITLE")
	label_subtitle.text = tr("GAME_SUBTITLE")
	btn_quick_start.text = tr("MENU_QUICK_START")
	btn_settings.text = tr("MENU_SETTINGS")
	btn_quit.text = tr("MENU_QUIT")
	
	label_settings_title.text = tr("SETTINGS_TITLE")
	label_lang.text = tr("SETTINGS_LANGUAGE_LABEL")
	btn_back_settings.text = tr("SETTINGS_BACK")
	
	# Configurazione semantica per Screen Reader NVDA (Luca)
	AccessibilityManager.hook_control_accessibility(btn_quick_start, tr("MENU_QUICK_START"), tr("MENU_QUICK_START_DESC"))
	AccessibilityManager.hook_control_accessibility(btn_settings, tr("MENU_SETTINGS"), tr("MENU_SETTINGS_DESC"))
	AccessibilityManager.hook_control_accessibility(btn_quit, tr("MENU_QUIT"), tr("MENU_QUIT_DESC"))
	AccessibilityManager.hook_control_accessibility(opt_lang, tr("SETTINGS_LANGUAGE_LABEL"), tr("SETTINGS_LANGUAGE_DESC"))
	AccessibilityManager.hook_control_accessibility(btn_back_settings, tr("SETTINGS_BACK"), tr("SETTINGS_BACK_DESC"))

func _on_quick_start_pressed() -> void:
	# Avvia HUD di simulazione
	get_tree().change_scene_to_file("res://ui/hud/hud.tscn")

func _on_settings_pressed() -> void:
	vbox_menu.visible = false
	panel_settings.visible = true
	_populate_language_options()
	opt_lang.grab_focus()

func _on_back_settings_pressed() -> void:
	panel_settings.visible = false
	vbox_menu.visible = true
	btn_settings.grab_focus()

func _on_language_selected(index: int) -> void:
	var selected_code: String = str(opt_lang.get_item_metadata(index))
	if LocalizationManager:
		LocalizationManager.set_language(selected_code, true)

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
