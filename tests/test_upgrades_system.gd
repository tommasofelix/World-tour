# res://tests/test_upgrades_system.gd
extends Node

## Suite di Test Headless per Skills, Upgrade Hub & Strumentazione (Fase 9.1 / SP-15)
## Valida il modello UpgradeData, la persistenza PlayerData, il comparatore strumenti multicategoria,
## l'impatto di hardware studio su MusicSystem, sala prove su BandSystem, e la modale UpgradesModal.

var tests_passed: int = 0
var tests_failed: int = 0

const UpgradeData = preload("res://data/models/upgrade_data.gd")
var upgrades_scene: PackedScene = preload("res://ui/upgrades/upgrades_modal.tscn")
var upgrades_instance: Control = null
var hud_scene: PackedScene = preload("res://ui/hud/hud.tscn")
var hud_instance: Control = null

func _ready() -> void:
	print("\n========================================================")
	print("   SUITE TEST SKILLS, UPGRADES & STRUMENTAZIONE (F9.1)")
	print("========================================================")
	
	test_upgrade_data_models()
	test_player_data_upgrades_persistence()
	test_instrument_comparator()
	test_music_system_studio_hardware()
	test_band_system_rehearsals()
	test_concert_system_instrument_bonus()
	test_upgrades_modal_interaction()
	test_hud_player_overview_bar()
	
	print("\n--------------------------------------------------------")
	print("ESITO COMPLESSIVO TEST UPGRADES & STRUMENTAZIONE V5.0:")
	print("  Test Superati: %d" % tests_passed)
	print("  Test Falliti:  %d" % tests_failed)
	print("--------------------------------------------------------\n")
	
	if upgrades_instance:
		upgrades_instance.queue_free()
	if hud_instance:
		hud_instance.queue_free()
		
	if tests_failed == 0:
		print("[SUCCESSO] Skills, Upgrade Hub & Strumentazione convalidati al 100%!")
		get_tree().quit(0)
	else:
		printerr("[ERRORE CRITICO] Alcuni test degli upgrades sono falliti!")
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

# -------------------------------------------------------------
# TEST 1: Modello Dati UpgradeData
# -------------------------------------------------------------
func test_upgrade_data_models() -> void:
	print("\n[TEST 1] Modello Dati UpgradeData:")
	
	assert_equal(UpgradeData.get_rehearsal_stress(UpgradeData.RehearsalTier.NONE), 10, "Stress sala Tier 0 = 10")
	assert_equal(UpgradeData.get_rehearsal_stress(UpgradeData.RehearsalTier.MASTER_STUDIO), 0, "Stress sala Tier 3 = 0")
	
	assert_equal(UpgradeData.get_studio_hardware_cap(UpgradeData.StudioHardwareTier.BASIC_MIC), 60.0, "Cap hardware Tier 0 = 60")
	assert_equal(UpgradeData.get_studio_hardware_cap(UpgradeData.StudioHardwareTier.ANALOG_CONSOLE), 100.0, "Cap hardware Tier 3 = 100")
	assert_equal(UpgradeData.get_studio_hardware_bonus(UpgradeData.StudioHardwareTier.ANALOG_CONSOLE), 15.0, "Bonus hardware Tier 3 = +15")
	
	for cat in ["guitar", "bass", "drums", "vocals", "keyboards"]:
		var inst_0 := UpgradeData.get_instrument(cat, 0)
		var inst_3 := UpgradeData.get_instrument(cat, 3)
		assert_true(not inst_0.is_empty(), "Strumento starter presente per %s" % cat)
		assert_true(not inst_3.is_empty(), "Strumento master presente per %s" % cat)
		assert_true(inst_3["cost"] > 0, "Costo master valido per %s" % cat)

# -------------------------------------------------------------
# TEST 2: Persistenza PlayerData Upgrades
# -------------------------------------------------------------
func test_player_data_upgrades_persistence() -> void:
	print("\n[TEST 2] Persistenza PlayerData Upgrades:")
	var p := PlayerData.new()
	assert_equal(p.rehearsal_tier, 0, "Rehearsal tier default = 0")
	assert_equal(p.studio_hardware_tier, 0, "Studio hardware tier default = 0")
	assert_equal(p.get_instrument_tier("guitar"), 0, "Guitar tier default = 0")
	
	p.rehearsal_tier = 2
	p.studio_hardware_tier = 3
	p.set_instrument_tier("guitar", 2)
	p.set_instrument_tier("bass", 1)
	
	var serialized := p.to_dict()
	assert_equal(serialized["rehearsal_tier"], 2, "to_dict salva rehearsal_tier")
	assert_equal(serialized["studio_hardware_tier"], 3, "to_dict salva studio_hardware_tier")
	assert_equal(serialized["owned_instruments"]["guitar"], 2, "to_dict salva guitar tier")
	
	var p2 := PlayerData.new()
	p2.from_dict(serialized)
	assert_equal(p2.rehearsal_tier, 2, "from_dict ripristina rehearsal_tier")
	assert_equal(p2.studio_hardware_tier, 3, "from_dict ripristina studio_hardware_tier")
	assert_equal(p2.get_instrument_tier("guitar"), 2, "from_dict ripristina guitar tier")
	assert_equal(p2.get_instrument_tier("bass"), 1, "from_dict ripristina bass tier")

# -------------------------------------------------------------
# TEST 3: Comparatore Strumenti Multicategoria
# -------------------------------------------------------------
func test_instrument_comparator() -> void:
	print("\n[TEST 3] Comparatore Strumenti:")
	var cmp := UpgradeData.compare_instruments("guitar", 0, 2)
	assert_true(cmp["valid"], "Comparazione valida tra tier 0 e 2")
	assert_equal(cmp["diff_skill"], 12, "Delta tecnica per chitarra tier 2 = +12")
	assert_equal(cmp["diff_charisma"], 8, "Delta carisma per chitarra tier 2 = +8")
	assert_true(cmp["cost"] == 1500.0, "Costo chitarra tier 2 = 1.500 €")
	
	var cmp_same := UpgradeData.compare_instruments("bass", 1, 1)
	assert_true(cmp_same["comparison_text"].contains("attualmente in dotazione"), "Testo per stesso modello posseduto")

# -------------------------------------------------------------
# TEST 4: Impatto Hardware Studio su MusicSystem
# -------------------------------------------------------------
func test_music_system_studio_hardware() -> void:
	print("\n[TEST 4] Impatto Hardware Studio su MusicSystem:")
	var p := PlayerData.new()
	var cal := CalendarData.new()
	var skill_sys := SkillSystem.new(p)
	# Imposta abilità strumento al massimo (90)
	p.skills["instrument"]["level"] = 90
	
	var music_sys := MusicSystem.new(p, cal, skill_sys)
	var song1 := music_sys.create_draft("Test Home Track 1", Enums.MusicalGenre.ROCK)
	
	# Caso 1: Hardware Tier 0 (Cap 60, Bonus 0)
	p.studio_hardware_tier = 0
	var res1 := music_sys.record_tracks(song1, false)
	assert_true(res1["success"], "Registrazione casalinga riuscita con hw tier 0")
	assert_equal(song1.exec_skill_used, 60.0, "Resa esecutiva limitata dal cap casalingo a 60")
	assert_equal(song1.studio_bonus, 0.0, "Studio bonus hw tier 0 = 0")
	
	# Caso 2: Hardware Tier 3 (Cap 100, Bonus +15)
	p.energy = 100
	var song2 := music_sys.create_draft("Test Home Track 2", Enums.MusicalGenre.ROCK)
	p.studio_hardware_tier = 3
	var res2 := music_sys.record_tracks(song2, false)
	assert_true(res2["success"], "Registrazione casalinga riuscita con hw tier 3")
	assert_equal(song2.exec_skill_used, 90.0, "Resa esecutiva non più limitata (raggiunge il livello 90)")
	assert_equal(song2.studio_bonus, 15.0, "Studio bonus hw tier 3 = +15 (pari a studio pro a costo zero)")

# -------------------------------------------------------------
# TEST 5: Impatto Sala Prove su BandSystem
# -------------------------------------------------------------
func test_band_system_rehearsals() -> void:
	print("\n[TEST 5] Impatto Sala Prove su BandSystem:")
	var p := PlayerData.new()
	var cal := CalendarData.new()
	var band_sys := BandSystem.new(p, cal)
	
	# Prove senza band devono fallire
	var res_no_band := band_sys.hold_rehearsal_session()
	assert_true(not res_no_band["success"], "Prove rifiutate se non c'è una band")
	
	# Recluta un membro
	var cand := BandMemberData.new("m1", "Dave", Enums.BandRole.BASS, Enums.BandPersonality.RELIABLE, 0, 50)
	p.add_band_member(cand)
	
	# Caso 1: Sala Tier 0 (Garage: stress +10)
	p.energy = 100
	p.stress = 0
	p.rehearsal_tier = 0
	var res_t0 := band_sys.hold_rehearsal_session()
	assert_true(res_t0["success"], "Prove riuscite con garage tier 0")
	assert_equal(res_t0["stress_gain"], 10, "Stress prove con garage tier 0 = 10")
	assert_equal(p.stress, 10, "Stress del giocatore incrementato a 10")
	
	# Caso 2: Sala Tier 3 (Studio perfetto: stress 0)
	p.energy = 100
	p.stress = 0
	p.rehearsal_tier = 3
	var res_t3 := band_sys.hold_rehearsal_session()
	assert_true(res_t3["success"], "Prove riuscite con sala tier 3")
	assert_equal(res_t3["stress_gain"], 0, "Stress prove con studio perfetto tier 3 = 0")
	assert_equal(p.stress, 0, "Stress del giocatore invariato a 0")
	
	# Test Sinergia Strumenti Band
	p.set_instrument_tier("bass", 2) # Basso vintage: +8% sinergia
	var synergy := band_sys.get_band_synergy_bonus()
	assert_true(synergy > 0.0, "Sinergia della band potenziata dal basso professionale (+%.1f)" % synergy)

# -------------------------------------------------------------
# TEST 6: Bonus Strumento Primario nei Concerti
# -------------------------------------------------------------
func test_concert_system_instrument_bonus() -> void:
	print("\n[TEST 6] Bonus Strumenti nei Concerti:")
	var p := PlayerData.new()
	p.primary_instrument = "guitar"
	p.skills["charisma"]["level"] = 20
	p.skills["performance"]["level"] = 20
	p.skills["instrument"]["level"] = 20
	
	var cal := CalendarData.new()
	var concert_sys := ConcertSystem.new(p, cal)
	var venue := VenueData.new("v1", "Pub Underground", 100, 0.0, 0.0, 10.0, 10.0)
	
	var s := SongData.new("s1", "Rock Anthem", Enums.MusicalGenre.ROCK)
	s.status = Enums.SongStatus.PRODUCED
	s.quality_score = 70.0
	var setlist: Array[SongData] = [s]
	
	# Concerto senza chitarra speciale
	p.energy = 100
	p.money = 500.0
	p.popularity = 20.0
	p.set_instrument_tier("guitar", 0)
	var res1 := concert_sys.resolve_concert(venue, setlist, 10.0)
	var score1: float = float(res1["concert_score"])
	
	# Concerto con Custom Shop Signature (+15 Carisma)
	p.energy = 100
	p.money = 500.0
	p.popularity = 20.0
	p.set_instrument_tier("guitar", 3)
	var res2 := concert_sys.resolve_concert(venue, setlist, 10.0)
	var score2: float = float(res2["concert_score"])
	
	assert_true(score2 > score1, "Concert Score superiore con chitarra signature (%.1f > %.1f)" % [score2, score1])

# -------------------------------------------------------------
# TEST 7: Interazione UpgradesModal
# -------------------------------------------------------------
func test_upgrades_modal_interaction() -> void:
	print("\n[TEST 7] Interazione UpgradesModal:")
	upgrades_instance = upgrades_scene.instantiate()
	add_child(upgrades_instance)
	
	upgrades_instance.open()
	assert_true(upgrades_instance.visible, "Modale Upgrades aperta con successo")
	
	# Verifica cambio schede
	upgrades_instance.select_tab(1)
	assert_equal(upgrades_instance.current_tab, 1, "Scheda 1 (Alloggi) attiva")
	assert_true(upgrades_instance.panel_housing.visible, "Pannello alloggi visibile")
	
	upgrades_instance.select_tab(2)
	assert_equal(upgrades_instance.current_tab, 2, "Scheda 2 (Sala Prove) attiva")
	assert_true(upgrades_instance.panel_rehearsal.visible, "Pannello sala prove visibile")
	
	upgrades_instance.select_tab(3)
	assert_equal(upgrades_instance.current_tab, 3, "Scheda 3 (Strumenti) attiva")
	assert_true(upgrades_instance.panel_gear.visible, "Pannello negozio strumenti visibile")
	
	# Test acquisto chitarra semi-pro nella modale
	if GameManager and GameManager.player_data:
		GameManager.player_data.money = 2000.0
		upgrades_instance.select_gear_category("guitar")
		upgrades_instance._on_buy_instrument(1)
		assert_equal(GameManager.player_data.get_instrument_tier("guitar"), 1, "Chitarra tier 1 acquistata nella modale")
		assert_true(GameManager.player_data.money < 2000.0, "Saldo scalato dopo acquisto chitarra")
		
		# Test acquisto insonorizzazione sala prove
		upgrades_instance.select_tab(2)
		upgrades_instance._on_buy_rehearsal(UpgradeData.RehearsalTier.ACOUSTIC_PANELS)
		assert_equal(GameManager.player_data.rehearsal_tier, 1, "Pannelli fonoassorbenti acquistati nella modale")
		
		# Test acquisto hardware studio
		upgrades_instance.select_tab(4)
		upgrades_instance._on_buy_studio_hardware(UpgradeData.StudioHardwareTier.USB_CONDENSER)
		assert_equal(GameManager.player_data.studio_hardware_tier, 1, "Microfono USB acquistato nella modale")
	
	upgrades_instance.close()
	assert_true(not upgrades_instance.visible, "Modale Upgrades chiusa con successo")

# -------------------------------------------------------------
# TEST 8: Barra Player Overview nell'HUD (Città | Status | Livelli)
# -------------------------------------------------------------
func test_hud_player_overview_bar() -> void:
	print("\n[TEST 8] Barra Player Overview nell'HUD:")
	hud_instance = hud_scene.instantiate()
	add_child(hud_instance)
	
	hud_instance._update_hud_display()
	var text: String = hud_instance.label_player_summary.text
	assert_true(text.contains("Città:"), "Barra contiene 'Città:'")
	assert_true(text.contains("Status:"), "Barra contiene 'Status:'")
	assert_true(text.contains("Livello:"), "Barra contiene 'Livello:'")
	assert_true(text.contains("Scrittura testi Lv."), "Barra indica il livello di Scrittura testi")
	assert_true(text.contains("Composizione Lv."), "Barra indica il livello di Composizione")
	assert_true(text.contains("Produzione Lv."), "Barra indica il livello di Produzione")
	print("  [OK] Testo formattato seconda barra: \"%s\"" % text)
