# res://tests/test_localization.gd
extends Node

## Suite di Test Automatizzati per il Sistema di Localizzazione (i18n) e Main Menu

var tests_passed: int = 0
var tests_failed: int = 0

func _ready() -> void:
	print("\n========================================================")
	print("   SUITE TEST LOCALIZZAZIONE (i18n) & MAIN MENU   ")
	print("========================================================\n")
	
	test_dictionary_parity()
	test_localization_manager_switching()
	test_event_bus_signal()
	test_player_data_language_persistence()
	test_save_manager_settings()
	test_main_menu_instantiation()
	
	print("\n--------------------------------------------------------")
	print("ESITO COMPLESSIVO TEST LOCALIZZAZIONE:")
	print("  Test Superati: %d" % tests_passed)
	print("  Test Falliti:  %d" % tests_failed)
	print("--------------------------------------------------------\n")
	
	if tests_failed > 0:
		print("[ERRORE CRITICO] Alcuni test di localizzazione sono falliti!")
		get_tree().quit(1)
	else:
		print("[SUCCESSO] Il sistema di localizzazione e Main Menu è convalidato al 100%!")
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

func test_dictionary_parity() -> void:
	print("1. Verifica Parità e Integrità Dizionari (it.json / en.json):")
	var it_file := FileAccess.open("res://localization/it.json", FileAccess.READ)
	assert_true(it_file != null, "Apertura localization/it.json riuscita")
	var it_json := JSON.new()
	assert_true(it_json.parse(it_file.get_as_text()) == OK, "Parsing JSON it.json valido")
	it_file.close()
	
	var en_file := FileAccess.open("res://localization/en.json", FileAccess.READ)
	assert_true(en_file != null, "Apertura localization/en.json riuscita")
	var en_json := JSON.new()
	assert_true(en_json.parse(en_file.get_as_text()) == OK, "Parsing JSON en.json valido")
	en_file.close()
	
	var it_dict: Dictionary = it_json.data
	var en_dict: Dictionary = en_json.data
	
	assert_true(it_dict.size() > 0, "Dizionario italiano contiene chiavi (%d)" % it_dict.size())
	assert_eq(it_dict.size(), en_dict.size(), "Numero identico di chiavi tra italiano e inglese")
	
	var missing_in_en := 0
	var empty_values := 0
	for k in it_dict:
		if not en_dict.has(k):
			missing_in_en += 1
		if str(it_dict[k]).strip_edges().is_empty() or str(en_dict.get(k, "")).strip_edges().is_empty():
			empty_values += 1
			
	assert_eq(missing_in_en, 0, "Nessuna chiave mancante in en.json")
	assert_eq(empty_values, 0, "Nessun valore vuoto nei dizionari")

func test_localization_manager_switching() -> void:
	print("\n2. Verifica Cambio Lingua e TranslationServer:")
	LocalizationManager.set_language("it", false)
	assert_eq(LocalizationManager.get_current_language(), "it", "Lingua attiva impostata su 'it'")
	assert_eq(tr("MENU_QUICK_START"), "Avvio Rapido (Test)", "tr('MENU_QUICK_START') restituisce testo italiano")
	assert_eq(tr("PERIOD_MORNING"), "Mattina", "tr('PERIOD_MORNING') restituisce 'Mattina'")
	
	LocalizationManager.set_language("en", false)
	assert_eq(LocalizationManager.get_current_language(), "en", "Lingua attiva impostata su 'en'")
	assert_eq(tr("MENU_QUICK_START"), "Quick Start (Test)", "tr('MENU_QUICK_START') restituisce testo inglese")
	assert_eq(tr("PERIOD_MORNING"), "Morning", "tr('PERIOD_MORNING') restituisce 'Morning'")
	
	# Test fallback su lingua sconosciuta
	LocalizationManager.set_language("xx_invalid", false)
	assert_eq(LocalizationManager.get_current_language(), "it", "Fallback automatico su 'it' per codice sconosciuto")

func test_event_bus_signal() -> void:
	print("\n3. Verifica Emissione Segnale language_changed:")
	var box := {"lang": ""}
	var callback := func(new_l: String) -> void:
		box["lang"] = new_l
		
	EventBus.language_changed.connect(callback)
	LocalizationManager.set_language("en", false)
	assert_eq(box["lang"], "en", "Segnale language_changed ricevuto con 'en'")
	
	LocalizationManager.set_language("it", false)
	assert_eq(box["lang"], "it", "Segnale language_changed ricevuto con 'it'")
	EventBus.language_changed.disconnect(callback)

func test_player_data_language_persistence() -> void:
	print("\n4. Verifica Persistenza Lingua in PlayerData:")
	var p := PlayerData.new()
	assert_eq(p.language, "it", "Lingua di default in PlayerData = 'it'")
	p.language = "en"
	var d := p.to_dict()
	assert_eq(d.get("language", ""), "en", "to_dict() include 'language': 'en'")
	
	var p2 := PlayerData.new()
	p2.from_dict(d)
	assert_eq(p2.language, "en", "from_dict() ripristina 'language': 'en'")

func test_save_manager_settings() -> void:
	print("\n5. Verifica Persistenza Globale Impostazioni (SaveManager):")
	var res := SaveManager.save_settings({"test_key": 123, "language": "en"})
	assert_true(res, "Salvataggio impostazioni riuscito")
	var loaded := SaveManager.load_settings()
	assert_eq(int(loaded.get("test_key", 0)), 123, "Lettura chiave impostazioni corretta")
	assert_eq(str(loaded.get("language", "")), "en", "Lettura lingua salvata corretta")
	# Teardown di isolamento: ripristina la lingua di default 'it' per i lanci in-game successivi
	SaveManager.save_settings({"language": "it"})

func test_main_menu_instantiation() -> void:
	print("\n6. Verifica Istanziazione e Nodi Scena Main Menu:")
	var menu_scene: PackedScene = load("res://ui/main_menu/main_menu.tscn")
	assert_true(menu_scene != null, "Caricamento risorsa main_menu.tscn riuscito")
	var instance: Node = menu_scene.instantiate()
	assert_true(instance != null, "Istanziazione Main Menu riuscita")
	
	var btn_qs: Button = instance.find_child("BtnQuickStart", true, false)
	var btn_set: Button = instance.find_child("BtnSettings", true, false)
	var btn_q: Button = instance.find_child("BtnQuit", true, false)
	var opt_l: OptionButton = instance.find_child("OptLang", true, false)
	
	assert_true(btn_qs != null, "Pulsante BtnQuickStart presente")
	assert_true(btn_set != null, "Pulsante BtnSettings presente")
	assert_true(btn_q != null, "Pulsante BtnQuit presente")
	assert_true(opt_l != null, "OptionButton OptLang presente")
	
	instance.free()
