# res://tests/test_main_menu.gd
extends Node

## Suite di Test Automatizzati per il Nuovo Menu Principale di World-tour
## Convalida a 0 ms senza latenze artificiali: architettura grafica, 4 pulsanti,
## catena di focus ciclica, gestione salvataggi e accessibilità NVDA.

var tests_passed: int = 0
var tests_failed: int = 0

func _ready() -> void:
	print("\n========================================================")
	print("   SUITE DI TEST NUOVO MENU PRINCIPALE (ASTRALIS v3.0.7)   ")
	print("========================================================\n")
	
	test_scene_structure()
	test_keyboard_focus_chain()
	test_settings_toggle()
	test_load_game_logic()
	test_accessibility_hooks()
	
	print("\n--------------------------------------------------------")
	print("ESITO COMPLESSIVO TEST MENU PRINCIPALE:")
	print("  Test Superati: %d" % tests_passed)
	print("  Test Falliti:  %d" % tests_failed)
	print("--------------------------------------------------------\n")
	
	if tests_failed > 0:
		print("[ERRORE CRITICO] Alcuni test del Menu Principale sono falliti!")
		get_tree().quit(1)
	else:
		print("[SUCCESSO] Il Nuovo Menu Principale è convalidato al 100%!")
		get_tree().quit(0)

func assert_true(condition: bool, test_name: String) -> void:
	if condition:
		print("  [OK] %s" % test_name)
		tests_passed += 1
	else:
		print("  [FALLITO] %s" % test_name)
		tests_failed += 1

func assert_eq(val1: Variant, val2: Variant, test_name: String) -> void:
	if val1 == val2:
		print("  [OK] %s (%s == %s)" % [test_name, str(val1), str(val2)])
		tests_passed += 1
	else:
		print("  [FALLITO] %s (Atteso: %s, Ottenuto: %s)" % [test_name, str(val2), str(val1)])
		tests_failed += 1

func test_scene_structure() -> void:
	print("1. Verifica Struttura e Nodi Grafici Scena:")
	var menu_scene: PackedScene = load("res://ui/main_menu/main_menu.tscn")
	assert_true(menu_scene != null, "Risorsa main_menu.tscn caricata")
	
	var menu: Control = menu_scene.instantiate() as Control
	assert_true(menu != null, "Istanziazione Control MainMenu riuscita")
	add_child(menu)
	
	var bg: TextureRect = menu.find_child("Background", true, false) as TextureRect
	assert_true(bg != null, "TextureRect Background presente")
	assert_true(bg.texture != null, "Texture di sfondo presente")
	
	var title_tex: TextureRect = menu.find_child("TitleTexture", true, false) as TextureRect
	assert_true(title_tex != null, "TextureRect TitleTexture presente")
	assert_true(title_tex.texture != null, "Texture del logo presente")
	
	var btn_ng: Button = menu.find_child("BtnNewGame", true, false) as Button
	var btn_lg: Button = menu.find_child("BtnLoadGame", true, false) as Button
	var btn_set: Button = menu.find_child("BtnSettings", true, false) as Button
	var btn_quit: Button = menu.find_child("BtnQuit", true, false) as Button
	var btn_qs: Button = menu.find_child("BtnQuickStart", true, false) as Button
	
	assert_true(btn_ng != null, "Pulsante NUOVA PARTITA presente")
	assert_true(btn_lg != null, "Pulsante CARICA PARTITA presente")
	assert_true(btn_set != null, "Pulsante IMPOSTAZIONI presente")
	assert_true(btn_quit != null, "Pulsante ESCI AL DESKTOP presente")
	assert_true(btn_qs != null, "Pulsante BtnQuickStart preservato")
	
	menu.queue_free()

func test_keyboard_focus_chain() -> void:
	print("\n2. Verifica Navigazione da Tastiera Ciclica (Zero Mouse):")
	var menu_scene: PackedScene = load("res://ui/main_menu/main_menu.tscn")
	var menu: Control = menu_scene.instantiate() as Control
	add_child(menu)
	
	var btn_ng: Button = menu.find_child("BtnNewGame", true, false) as Button
	var btn_lg: Button = menu.find_child("BtnLoadGame", true, false) as Button
	var btn_set: Button = menu.find_child("BtnSettings", true, false) as Button
	var btn_quit: Button = menu.find_child("BtnQuit", true, false) as Button
	
	# Ciclicità verso il basso: NG -> LG -> SET -> QUIT -> NG
	assert_eq(btn_ng.focus_neighbor_bottom, NodePath("../BtnLoadGame"), "Nuova Partita Giù -> Carica Partita")
	assert_eq(btn_lg.focus_neighbor_bottom, NodePath("../BtnSettings"), "Carica Partita Giù -> Impostazioni")
	assert_eq(btn_set.focus_neighbor_bottom, NodePath("../BtnQuit"), "Impostazioni Giù -> Esci al Desktop")
	assert_eq(btn_quit.focus_neighbor_bottom, NodePath("../BtnNewGame"), "Esci al Desktop Giù -> Ciclo su Nuova Partita")
	
	# Ciclicità verso l'alto: NG -> QUIT -> SET -> LG -> NG
	assert_eq(btn_ng.focus_neighbor_top, NodePath("../BtnQuit"), "Nuova Partita Su -> Ciclo su Esci al Desktop")
	assert_eq(btn_quit.focus_neighbor_top, NodePath("../BtnSettings"), "Esci al Desktop Su -> Impostazioni")
	assert_eq(btn_set.focus_neighbor_top, NodePath("../BtnLoadGame"), "Impostazioni Su -> Carica Partita")
	assert_eq(btn_lg.focus_neighbor_top, NodePath("../BtnNewGame"), "Carica Partita Su -> Nuova Partita")
	
	menu.queue_free()

func test_settings_toggle() -> void:
	print("\n3. Verifica Apertura e Chiusura Pannello Impostazioni:")
	var menu_scene: PackedScene = load("res://ui/main_menu/main_menu.tscn")
	var menu: Control = menu_scene.instantiate() as Control
	add_child(menu)
	
	var vbox_menu: VBoxContainer = menu.find_child("VBoxMenu", true, false) as VBoxContainer
	var panel_settings: PanelContainer = menu.find_child("PanelSettings", true, false) as PanelContainer
	
	assert_true(vbox_menu.visible, "Menu principale visibile all'avvio")
	assert_true(not panel_settings.visible, "Pannello impostazioni nascosto all'avvio")
	
	# Apertura impostazioni
	menu._on_settings_pressed()
	assert_true(not vbox_menu.visible, "Menu principale nascosto con impostazioni aperte")
	assert_true(panel_settings.visible, "Pannello impostazioni visibile")
	
	# Verifica e test selettore Sintesi Vocale (TTS)
	var opt_tts: OptionButton = menu.find_child("OptTTS", true, false) as OptionButton
	assert_true(opt_tts != null, "Selettore Sintesi Vocale OptTTS presente")
	if opt_tts:
		menu._on_tts_selected(1) # Disattivata
		assert_true(not AccessibilityManager.is_tts_enabled, "Sintesi vocale disattivata in AccessibilityManager")
		assert_true(not SaveManager.is_tts_enabled(), "Opzione salvata su settings.json come disattivata")
		menu._on_tts_selected(0) # Attiva
		assert_true(AccessibilityManager.is_tts_enabled, "Sintesi vocale riattivata")
		assert_true(SaveManager.is_tts_enabled(), "Opzione salvata su settings.json come attiva")

	# Chiusura impostazioni
	menu._on_back_settings_pressed()
	assert_true(vbox_menu.visible, "Menu principale ripristinato dopo chiusura impostazioni")
	assert_true(not panel_settings.visible, "Pannello impostazioni nascosto dopo chiusura")
	
	menu.queue_free()

func test_load_game_logic() -> void:
	print("\n4. Verifica Logica di Carica Partita:")
	var menu_scene: PackedScene = load("res://ui/main_menu/main_menu.tscn")
	var menu: Control = menu_scene.instantiate() as Control
	add_child(menu)
	
	var btn_lg: Button = menu.find_child("BtnLoadGame", true, false) as Button
	assert_true(btn_lg != null, "Pulsante Carica Partita pronto per l'interazione")
	
	# Se nessun salvataggio è presente, il click non deve causare eccezioni
	var announced_messages: Array = []
	var record_announcement = func(msg: String, _interrupt: bool): announced_messages.append(msg)
	EventBus.accessibility_announced.connect(record_announcement)
	
	menu._on_load_game_pressed()
	assert_true(announced_messages.size() > 0, "Annuncio vocale emesso alla pressione di Carica Partita")
	
	EventBus.accessibility_announced.disconnect(record_announcement)
	menu.queue_free()

func test_accessibility_hooks() -> void:
	print("\n5. Verifica Agganci Accessibilità NVDA:")
	var menu_scene: PackedScene = load("res://ui/main_menu/main_menu.tscn")
	var menu: Control = menu_scene.instantiate() as Control
	add_child(menu)
	
	var btn_ng: Button = menu.find_child("BtnNewGame", true, false) as Button
	var btn_lg: Button = menu.find_child("BtnLoadGame", true, false) as Button
	var btn_set: Button = menu.find_child("BtnSettings", true, false) as Button
	var btn_quit: Button = menu.find_child("BtnQuit", true, false) as Button
	var opt_tts_node: OptionButton = menu.find_child("OptTTS", true, false) as OptionButton
	
	assert_true(not btn_ng.get_accessibility_name().is_empty(), "Nuova Partita ha nome di accessibilità")
	assert_true(not btn_lg.get_accessibility_name().is_empty(), "Carica Partita ha nome di accessibilità")
	assert_true(not btn_set.get_accessibility_name().is_empty(), "Impostazioni ha nome di accessibilità")
	assert_true(not btn_quit.get_accessibility_name().is_empty(), "Esci al Desktop ha nome di accessibilità")
	assert_true(opt_tts_node != null and not opt_tts_node.get_accessibility_name().is_empty(), "OptTTS ha nome di accessibilità")
	
	assert_true(not btn_ng.get_accessibility_description().is_empty(), "Nuova Partita ha descrizione di accessibilità")
	assert_true(not btn_lg.get_accessibility_description().is_empty(), "Carica Partita ha descrizione di accessibilità")
	
	menu.queue_free()
