# res://tests/test_dilemma_system.gd
extends Node

## Suite di Test Headless per i Bivi Etico-Narrativi e Scelte Morali (World-tour V3.0)

const DilemmaSystemScript = preload("res://systems/dilemma_system.gd")
const DilemmaDataScript = preload("res://data/models/dilemma_data.gd")
const ContractDataScript = preload("res://data/models/contract_data.gd")

var tests_passed: int = 0
var tests_failed: int = 0

func _ready() -> void:
	print("\n========================================================")
	print("   SUITE TEST BIVI ETICI & DILEMMI NARRATIVI (V3.0)    ")
	print("========================================================")
	
	test_dilemmas_catalog_integrity()
	test_dilemma_eligibility()
	test_dilemma_resolution_option_a()
	test_dilemma_resolution_option_b()
	test_no_repeat_resolved_dilemmas()
	
	print("\n--------------------------------------------------------")
	print("ESITO COMPLESSIVO TEST BIVI ETICI:")
	print("  Test Superati: %d" % tests_passed)
	print("  Test Falliti:  %d" % tests_failed)
	print("--------------------------------------------------------\n")
	
	if tests_failed == 0:
		print("[SUCCESSO] Il sistema dei Bivi Etici V3.0 è convalidato al 100%!")
		get_tree().quit(0)
	else:
		printerr("[ERRORE CRITICO] Alcuni test dei bivi etici sono falliti!")
		get_tree().quit(1)

func assert_true(condition: bool, message: String) -> void:
	if condition:
		tests_passed += 1
		print("  [OK] %s" % message)
	else:
		tests_failed += 1
		printerr("  [FALLITO] %s" % message)

func assert_equal(actual: Variant, expected: Variant, message: String) -> void:
	if actual == expected:
		tests_passed += 1
		print("  [OK] %s (%s == %s)" % [message, str(actual), str(expected)])
	else:
		tests_failed += 1
		printerr("  [FALLITO] %s (Atteso: %s, Ottenuto: %s)" % [message, str(expected), str(actual)])

# 1. Catalogo Dilemmi
func test_dilemmas_catalog_integrity() -> void:
	print("\n1. Verifica Integrità del Catalogo Dilemmi:")
	var player := PlayerData.new()
	var dil_sys = DilemmaSystemScript.new(player)
	
	assert_true(dil_sys.dilemmas_catalog.size() >= 8, "Almeno 8 dilemmi etici nel catalogo")
	for d in dil_sys.dilemmas_catalog:
		assert_true(not d.title.is_empty(), "Dilemma '%s' provvisto di titolo" % d.id)
		assert_true(not d.description.is_empty(), "Dilemma '%s' provvisto di descrizione" % d.id)
		assert_true(not d.option_a_title.is_empty(), "Dilemma '%s' provvisto di Opzione A" % d.id)
		assert_true(not d.option_b_title.is_empty(), "Dilemma '%s' provvisto di Opzione B" % d.id)

# 2. Idoneità Dilemmi
func test_dilemma_eligibility() -> void:
	print("\n2. Verifica Requisiti di Idoneità (Fan, Contratti):")
	var player := PlayerData.new()
	player.fans = 0
	player.reputation = 5.0
	var dil_sys = DilemmaSystemScript.new(player)
	
	# Dilemma censura major richiede contratto attivo
	var censorship_d: DilemmaData = null
	for d in dil_sys.dilemmas_catalog:
		if d.id == "dilemma_label_censorship":
			censorship_d = d
			break
			
	assert_true(censorship_d != null, "Dilemma censura major presente")
	assert_true(not censorship_d.is_eligible(player), "Censura major ineleggibile senza contratto attivo")
	
	# Attiviamo contratto
	var c = ContractDataScript.new("c1", "Apex", Enums.ContractType.MAJOR_LABEL, 50000.0, 0.15, 3, 60.0)
	c.is_active = true
	player.active_contract = c
	assert_true(censorship_d.is_eligible(player), "Censura major idonea con contratto attivo")

# 3. Risoluzione Opzione A (Compromesso Commerciale)
func test_dilemma_resolution_option_a() -> void:
	print("\n3. Verifica Risoluzione Opzione A (Spot Bibita Gassata):")
	var player := PlayerData.new()
	player.money = 500.0
	player.morale = 70
	player.fans = 200
	
	var member := BandMemberData.new("b1", "Marco Bass", Enums.BandRole.BASS, Enums.BandPersonality.RELIABLE)
	member.tension = 20.0
	player.add_band_member(member)
	
	var dil_sys = DilemmaSystemScript.new(player)
	var res: Dictionary = dil_sys.resolve_dilemma("dilemma_commercial_ad", 1)
	
	assert_true(res.success, "Risoluzione dilemma riuscita")
	assert_equal(player.money, 4500.0, "Incassati 4.000 € dello spot (500 -> 4500)")
	assert_equal(player.morale, 55, "Morale calato di 15 per la svendita commerciale (70 -> 55)")
	assert_equal(player.fans, 170, "Fan puristi persi: 30 (200 -> 170)")
	assert_equal(member.tension, 32.0, "Tensione del bassista aumentata a 32%")
	assert_true(player.resolved_dilemmas.has("dilemma_commercial_ad"), "Dilemma archiviato tra i risolti")

# 4. Risoluzione Opzione B (Integrità Artistica)
func test_dilemma_resolution_option_b() -> void:
	print("\n4. Verifica Risoluzione Opzione B (Rifiuto Spot Bibita Gassata):")
	var player := PlayerData.new()
	player.money = 500.0
	player.morale = 70
	player.reputation = 20.0
	
	var member := BandMemberData.new("b2", "Elena Drums", Enums.BandRole.DRUMS, Enums.BandPersonality.PERFECTIONIST)
	member.respect = 40.0
	member.tension = 30.0
	player.add_band_member(member)
	
	var dil_sys = DilemmaSystemScript.new(player)
	var res: Dictionary = dil_sys.resolve_dilemma("dilemma_commercial_ad", 2)
	
	assert_true(res.success, "Risoluzione Opzione B riuscita")
	assert_equal(player.money, 500.0, "Nessun introito monetario (500 == 500)")
	assert_equal(player.morale, 85, "Morale aumentato di 15 per integrità morale (70 -> 85)")
	assert_equal(player.reputation, 24.0, "Reputazione cresciuta di 4 punti (20 -> 24)")
	assert_equal(member.respect, 50.0, "Rispetto della batterista salito a 50%")
	assert_equal(member.tension, 22.0, "Tensione della band calata a 22%")

# 5. Divieto di Ripetizione Dilemmi Risolti
func test_no_repeat_resolved_dilemmas() -> void:
	print("\n5. Verifica Esclusione Dilemmi Già Risolti:")
	var player := PlayerData.new()
	player.fans = 500
	player.reputation = 30.0
	player.resolved_dilemmas.append("dilemma_commercial_ad")
	
	var dil_sys = DilemmaSystemScript.new(player)
	var eligible: Array = dil_sys.get_eligible_dilemmas()
	
	var contains_ad: bool = false
	for d in eligible:
		if d.id == "dilemma_commercial_ad":
			contains_ad = true
			break
			
	assert_true(not contains_ad, "Dilemma già risolto escluso da future proposte")
