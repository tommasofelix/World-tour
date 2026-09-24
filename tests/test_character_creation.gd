# res://tests/test_character_creation.gd
extends Node

## Suite di Test Automatizzati per la Creazione del Personaggio (Sezione 1.1)

var tests_passed: int = 0
var tests_failed: int = 0

func _ready() -> void:
	print("\n========================================================")
	print("   SUITE TEST CREAZIONE PERSONAGGIO (SEZIONE 1.1)   ")
	print("========================================================\n")
	
	test_scene_instantiation()
	test_background_and_trait_application()
	test_serialization_and_effective_name()
	test_dropdown_items()
	
	print("\n--------------------------------------------------------")
	print("ESITO COMPLESSIVO TEST CREAZIONE PERSONAGGIO:")
	print("  Test Superati: %d" % tests_passed)
	print("  Test Falliti:  %d" % tests_failed)
	print("--------------------------------------------------------\n")
	
	if tests_failed > 0:
		print("[ERRORE CRITICO] Alcuni test di creazione personaggio sono falliti!")
		get_tree().quit(1)
	else:
		print("[SUCCESSO] Il sistema di Creazione Personaggio è convalidato al 100%!")
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

func test_scene_instantiation() -> void:
	print("1. Verifica Istanziazione e Nodi Scena CharacterCreation:")
	var scene: PackedScene = load("res://ui/character/character_creation.tscn")
	assert_true(scene != null, "Caricamento risorsa character_creation.tscn riuscito")
	var inst: Node = scene.instantiate()
	assert_true(inst != null, "Istanziazione CharacterCreation riuscita")
	
	var edit_name: LineEdit = inst.find_child("EditName", true, false)
	var edit_stage: LineEdit = inst.find_child("EditStageName", true, false)
	var spin_age: SpinBox = inst.find_child("SpinAge", true, false)
	var opt_inst: OptionButton = inst.find_child("OptInstrument", true, false)
	var opt_bg: OptionButton = inst.find_child("OptBackground", true, false)
	var opt_tr: OptionButton = inst.find_child("OptTrait", true, false)
	var label_sum: Label = inst.find_child("LabelSummary", true, false)
	var btn_start: Button = inst.find_child("BtnStart", true, false)
	var btn_quick: Button = inst.find_child("BtnQuickDefault", true, false)
	var btn_back: Button = inst.find_child("BtnBack", true, false)
	
	assert_true(edit_name != null, "Nodo EditName presente")
	assert_true(edit_stage != null, "Nodo EditStageName presente")
	assert_true(spin_age != null, "Nodo SpinAge presente")
	assert_true(opt_inst != null, "Nodo OptInstrument presente")
	assert_true(opt_bg != null, "Nodo OptBackground presente")
	assert_true(opt_tr != null, "Nodo OptTrait presente")
	assert_true(label_sum != null, "Nodo LabelSummary presente")
	assert_true(btn_start != null, "Nodo BtnStart presente")
	assert_true(btn_quick != null, "Nodo BtnQuickDefault presente")
	assert_true(btn_back != null, "Nodo BtnBack presente")
	
	inst.free()

func test_background_and_trait_application() -> void:
	print("\n2. Verifica Applicazione Modificatori Background e Tratti in PlayerData:")
	
	# Autodidatta
	var p_self := PlayerData.new()
	p_self.background_id = "self_taught"
	p_self.apply_starting_background_and_trait()
	assert_eq(p_self.money, 50.0, "Autodidatta riceve 50 € di saldo iniziale")
	assert_eq(p_self.skills["instrument"]["level"], 12, "Autodidatta riceve Livello 12 in Strumento")
	
	# Conservatorio
	var p_cons := PlayerData.new()
	p_cons.background_id = "conservatory"
	p_cons.apply_starting_background_and_trait()
	assert_eq(p_cons.money, 30.0, "Conservatorio riceve 30 € di saldo iniziale")
	assert_eq(p_cons.skills["composition"]["level"], 14, "Conservatorio riceve Livello 14 in Composizione")
	assert_eq(p_cons.skills["instrument"]["level"], 12, "Conservatorio riceve Livello 12 in Strumento")
	
	# Musicista di Strada (Busker)
	var p_busk := PlayerData.new()
	p_busk.background_id = "busker"
	p_busk.apply_starting_background_and_trait()
	assert_eq(p_busk.money, 25.0, "Busker riceve 25 € di saldo iniziale")
	assert_eq(p_busk.skills["performance"]["level"], 14, "Busker riceve Livello 14 in Presenza Scenica")
	assert_eq(p_busk.skills["charisma"]["level"], 12, "Busker riceve Livello 12 in Carisma")
	
	# Ribelle Punk
	var p_punk := PlayerData.new()
	p_punk.background_id = "punk_rebel"
	p_punk.apply_starting_background_and_trait()
	assert_eq(p_punk.money, 20.0, "Punk riceve 20 € di saldo iniziale")
	assert_eq(p_punk.skills["performance"]["level"], 15, "Punk riceve Livello 15 in Presenza Scenica")
	
	# Producer da Cameretta
	var p_prod := PlayerData.new()
	p_prod.background_id = "bedroom_producer"
	p_prod.apply_starting_background_and_trait()
	assert_eq(p_prod.money, 40.0, "Producer riceve 40 € di saldo iniziale")
	assert_eq(p_prod.skills["production"]["level"], 15, "Producer riceve Livello 15 in Produzione")
	assert_eq(p_prod.skills["composition"]["level"], 12, "Producer riceve Livello 12 in Composizione")

func test_serialization_and_effective_name() -> void:
	print("\n3. Verifica Serializzazione Stage Name, Età ed Effective Name:")
	var p := PlayerData.new()
	p.player_name = "Marco"
	p.stage_name = "Silver Fox"
	p.age = 24
	p.primary_instrument = "Basso"
	p.background_id = "punk_rebel"
	p.trait_id = "stage_animal"
	
	assert_eq(p.get_effective_name(), "Silver Fox", "get_effective_name() restituisce il nome d'arte quando presente")
	
	var serialized: Dictionary = p.to_dict()
	assert_eq(str(serialized.get("stage_name", "")), "Silver Fox", "to_dict() include stage_name")
	assert_eq(int(serialized.get("age", 0)), 24, "to_dict() include age")
	
	var p_restored := PlayerData.new()
	p_restored.from_dict(serialized)
	assert_eq(p_restored.player_name, "Marco", "from_dict() ripristina player_name")
	assert_eq(p_restored.stage_name, "Silver Fox", "from_dict() ripristina stage_name")
	assert_eq(p_restored.age, 24, "from_dict() ripristina age")
	assert_eq(p_restored.primary_instrument, "Basso", "from_dict() ripristina primary_instrument")
	assert_eq(p_restored.background_id, "punk_rebel", "from_dict() ripristina background_id")
	assert_eq(p_restored.trait_id, "stage_animal", "from_dict() ripristina trait_id")
	
	p_restored.stage_name = ""
	assert_eq(p_restored.get_effective_name(), "Marco", "get_effective_name() ripiega su player_name quando stage_name è vuoto")

func test_dropdown_items() -> void:
	print("\n4. Verifica Opzioni nei Dropdown di Creazione:")
	var scene: PackedScene = load("res://ui/character/character_creation.tscn")
	var inst: Node = scene.instantiate()
	
	# Simula _ready() inserendolo temporaneamente nell'albero
	add_child(inst)
	
	var opt_inst: OptionButton = inst.find_child("OptInstrument", true, false)
	var opt_bg: OptionButton = inst.find_child("OptBackground", true, false)
	var opt_tr: OptionButton = inst.find_child("OptTrait", true, false)
	var label_sum: Label = inst.find_child("LabelSummary", true, false)
	
	assert_eq(opt_inst.item_count, 6, "6 strumenti musicali disponibili (Chitarra El., Ac., Basso, Batteria, Tastiere, Voce)")
	assert_eq(opt_bg.item_count, 5, "5 background di partenza disponibili (Autodidatta, Conservatorio, Busker, Punk, Producer)")
	assert_eq(opt_tr.item_count, 5, "5 tratti caratteriali disponibili (Carismatico, Perfezionista, Animale da Palco, Insonne, Resiliente)")
	assert_true(label_sum.text.contains("Riepilogo Musicista"), "LabelSummary inizializzato con il testo riassuntivo")
	
	inst.queue_free()
