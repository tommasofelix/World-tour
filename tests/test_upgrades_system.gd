# res://tests/test_upgrades_system.gd
extends Node

## Suite di Test Headless per Skills, Upgrade Hub & Strumentazione (Fase 9.1 & Sezione 4)
## Valida il modello UpgradeData, la persistenza PlayerData, il comparatore strumenti multicategoria,
## l'impatto di hardware studio su MusicSystem (incluso nastro analogico vs digitale),
## sala prove su BandSystem (insonorizzazione, prove, usura e quiete pubblica),
## sub-affitto passivo in EndDaySystem, usura e stage accidents con muletto in ConcertSystem,
## sound shaping (pedalboard ed amplificatori) e UpgradesModal a 5 schede.

var tests_passed: int = 0
var tests_failed: int = 0

const UpgradeData = preload("res://data/models/upgrade_data.gd")
var upgrades_scene: PackedScene = preload("res://ui/upgrades/upgrades_modal.tscn")
var upgrades_instance: Control = null
var hud_scene: PackedScene = preload("res://ui/hud/hud.tscn")
var hud_instance: Control = null

func _ready() -> void:
	print("\n========================================================")
	print("   SUITE TEST SKILLS, UPGRADES & STRUMENTAZIONE (SEZ. 4)")
	print("========================================================")
	
	test_upgrade_data_models()
	test_player_data_upgrades_persistence()
	test_instrument_comparator()
	test_music_system_studio_hardware()
	test_analog_tape_recording()
	test_band_system_rehearsals()
	test_rehearsal_sublet_and_noise_control()
	test_concert_system_instrument_bonus()
	test_sound_shaping_pedals_and_amps()
	test_luthier_wear_and_stage_accidents()
	test_band_equipment_assignment()
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
		print("[SUCCESSO] Skills, Upgrade Hub & Strumentazione Sezione 4 convalidati al 100%!")
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
		
	# Amplificatori e Pedali (Sezione 4)
	var amp_brit := UpgradeData.get_amp_model(UpgradeData.AmpType.BRITISH_TUBE)
	assert_equal(amp_brit["cost"], 600.0, "Costo ampli valvolare britannico = 600 €")
	var pedal_od := UpgradeData.get_pedal("overdrive")
	assert_equal(pedal_od["score_bonus"], 3.0, "Bonus pedale overdrive = +3.0")

# -------------------------------------------------------------
# TEST 2: Persistenza PlayerData Upgrades & Sezione 4
# -------------------------------------------------------------
func test_player_data_upgrades_persistence() -> void:
	print("\n[TEST 2] Persistenza PlayerData Upgrades:")
	var p := PlayerData.new()
	assert_equal(p.rehearsal_tier, 0, "Rehearsal tier default = 0")
	assert_equal(p.studio_hardware_tier, 0, "Studio hardware tier default = 0")
	assert_equal(p.get_instrument_tier("guitar"), 0, "Guitar tier default = 0")
	assert_equal(p.get_instrument_condition("guitar"), 100.0, "Integrità iniziale chitarra = 100%")
	assert_equal(p.has_backup_instrument, false, "Muletto iniziale assente")
	
	p.rehearsal_tier = 2
	p.studio_hardware_tier = 3
	p.set_instrument_tier("guitar", 2)
	p.set_instrument_tier("bass", 1)
	p.apply_instrument_wear("guitar", 25.0)
	p.has_backup_instrument = true
	p.current_amp_tier = UpgradeData.AmpType.BRITISH_TUBE
	p.owned_pedals.append("overdrive")
	p.active_pedalboard.append("overdrive")
	p.rehearsal_sublet_active = true
	p.recording_philosophy = UpgradeData.RecordingPhilosophy.ANALOG_TAPE
	
	var serialized := p.to_dict()
	assert_equal(serialized["rehearsal_tier"], 2, "to_dict salva rehearsal_tier")
	assert_equal(serialized["studio_hardware_tier"], 3, "to_dict salva studio_hardware_tier")
	assert_equal(serialized["owned_instruments"]["guitar"], 2, "to_dict salva guitar tier")
	assert_equal(serialized["instrument_condition"]["guitar"], 75.0, "to_dict salva usura chitarra")
	assert_equal(serialized["has_backup_instrument"], true, "to_dict salva muletto")
	assert_equal(serialized["current_amp_tier"], 1, "to_dict salva amplificatore")
	assert_equal(serialized["rehearsal_sublet_active"], true, "to_dict salva sub-affitto attivo")
	assert_equal(serialized["recording_philosophy"], 1, "to_dict salva filosofia nastro")
	
	var p2 := PlayerData.new()
	p2.from_dict(serialized)
	assert_equal(p2.rehearsal_tier, 2, "from_dict ripristina rehearsal_tier")
	assert_equal(p2.studio_hardware_tier, 3, "from_dict ripristina studio_hardware_tier")
	assert_equal(p2.get_instrument_tier("guitar"), 2, "from_dict ripristina guitar tier")
	assert_equal(p2.get_instrument_tier("bass"), 1, "from_dict ripristina bass tier")
	assert_equal(p2.get_instrument_condition("guitar"), 75.0, "from_dict ripristina usura")
	assert_equal(p2.has_backup_instrument, true, "from_dict ripristina muletto")
	assert_equal(p2.current_amp_tier, 1, "from_dict ripristina amplificatore")
	assert_equal(p2.rehearsal_sublet_active, true, "from_dict ripristina sub-affitto")
	assert_equal(p2.recording_philosophy, 1, "from_dict ripristina filosofia nastro")

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
# TEST 4B: Nastro Magnetico vs Digitale HD (Filosofia Registrazione)
# -------------------------------------------------------------
func test_analog_tape_recording() -> void:
	print("\n[TEST 4B] Registrazione Analogica su Nastro vs Digitale:")
	var p := PlayerData.new()
	p.money = 200.0
	p.energy = 100
	var cal := CalendarData.new()
	var skill_sys := SkillSystem.new(p)
	var music_sys := MusicSystem.new(p, cal, skill_sys)
	
	# Canzone Rock su Nastro Analogico
	p.recording_philosophy = UpgradeData.RecordingPhilosophy.ANALOG_TAPE
	var song_rock := music_sys.create_draft("Rock Tape Track", Enums.MusicalGenre.ROCK)
	var res_tape := music_sys.record_tracks(song_rock, false)
	assert_true(res_tape["success"], "Registrazione su nastro completata")
	assert_equal(p.money, 175.0, "Spesi 25 € per le bobine di nastro (200 -> 175)")
	assert_equal(song_rock.studio_bonus, 5.0, "Bonus calore nastro per Rock = +5.0")
	
	# Canzone Pop in Digitale HD
	p.energy = 100
	p.recording_philosophy = UpgradeData.RecordingPhilosophy.DIGITAL_HD
	var song_pop := music_sys.create_draft("Pop HD Track", Enums.MusicalGenre.POP)
	var res_hd := music_sys.record_tracks(song_pop, false)
	assert_true(res_hd["success"], "Registrazione digitale completata")
	assert_equal(p.money, 175.0, "Nessuna spesa bobine per Digitale HD (175.0 == 175.0)")
	assert_equal(song_pop.studio_bonus, 3.0, "Bonus definizione digitale per Pop = +3.0")

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
	
	# Caso 1: Sala Tier 0 (Garage: stress +10, energia -15)
	p.energy = 100
	p.stress = 0
	p.rehearsal_tier = 0
	var res_t0 := band_sys.hold_rehearsal_session()
	assert_true(res_t0["success"], "Prove riuscite con garage tier 0")
	assert_equal(res_t0["stress_gain"], 10, "Stress prove con garage tier 0 = 10")
	assert_equal(p.stress, 10, "Stress del giocatore incrementato a 10")
	assert_equal(p.energy, 85, "Energia scalata di 15 nel garage (100 -> 85)")
	
	# Caso 2: Sala Tier 1 (Pannelli Fonoassorbenti: affaticamento -30% -> energia -10)
	p.energy = 100
	p.rehearsal_tier = 1
	var res_t1 := band_sys.hold_rehearsal_session()
	assert_true(res_t1["success"], "Prove riuscite con sala tier 1")
	assert_equal(p.energy, 90, "Affaticamento ridotto del 30%: energia scalata di soli 10 punti (100 -> 90)")
	
	# Caso 3: Sala Tier 3 (Studio perfetto: stress 0, +8 morale)
	p.energy = 100
	p.stress = 0
	p.morale = 50
	p.rehearsal_tier = 3
	var res_t3 := band_sys.hold_rehearsal_session()
	assert_true(res_t3["success"], "Prove riuscite con sala tier 3")
	assert_equal(res_t3["stress_gain"], 0, "Stress prove con studio perfetto tier 3 = 0")
	assert_equal(p.stress, 0, "Stress del giocatore invariato a 0")
	assert_equal(p.morale, 58, "Morale aumentato di +8 nella lounge tier 3 (50 -> 58)")

# -------------------------------------------------------------
# TEST 5B: Sub-Affitto Sala Prove & Controllo Quiete Pubblica
# -------------------------------------------------------------
func test_rehearsal_sublet_and_noise_control() -> void:
	print("\n[TEST 5B] Sub-Affitto Sala Prove & Quiete Pubblica:")
	var p := PlayerData.new()
	p.money = 500.0
	p.energy = 100
	var cal := CalendarData.new()
	var band_sys := BandSystem.new(p, cal)
	var end_day := EndDaySystem.new(p, cal)
	
	p.add_band_member(BandMemberData.new("m2", "Alex Bass", Enums.BandRole.BASS))
	
	# Test Disturbo della quiete pubblica in Garage (Tier 0)
	p.rehearsal_tier = 0
	var res_noise := band_sys.hold_rehearsal_session(true) # Check attivo
	assert_true(res_noise["noise_incident"], "Incidente rumore rilevato nel garage")
	assert_equal(p.money, 350.0, "Sanzione vigili urbani di 150 € applicata (500 -> 350)")
	
	# Test Immunità isolamento acustico (Tier 2)
	p.rehearsal_tier = 2
	var res_pro := band_sys.hold_rehearsal_session(true)
	assert_equal(res_pro["noise_incident"], false, "Nessun incidente rumore con sala insonorizzata Tier 2")
	
	# Test Accredito passivo sub-affitto a fine giornata
	p.rehearsal_sublet_active = true
	var summary: Dictionary = end_day.process_day_end(1)
	assert_equal(summary["sublet_income"], 20.0, "Incasso passivo sub-affitto Tier 2 = +20 €")

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
# TEST 6B: Sound Shaping (Pedalboard & Amplificatori)
# -------------------------------------------------------------
func test_sound_shaping_pedals_and_amps() -> void:
	print("\n[TEST 6B] Sound Shaping (Pedalboard & Amplificatori):")
	var p := PlayerData.new()
	p.primary_instrument = "guitar"
	
	# Equipaggia Ampli Valvolare Britannico (+5 per Rock)
	p.current_amp_tier = UpgradeData.AmpType.BRITISH_TUBE
	assert_equal(p.get_sound_shaping_genre_bonus(Enums.MusicalGenre.ROCK), 5.0, "Bonus valvolare britannico per Rock = +5.0")
	assert_equal(p.get_sound_shaping_genre_bonus(Enums.MusicalGenre.POP), 0.0, "Nessun bonus britannico per Pop = 0.0")
	
	# Aggiungi e inserisci pedale Overdrive (+3 per Rock)
	p.owned_pedals.append("overdrive")
	p.equip_pedal("overdrive")
	assert_equal(p.get_sound_shaping_genre_bonus(Enums.MusicalGenre.ROCK), 8.0, "Bonus valvolare + overdrive per Rock = +8.0 (5 + 3)")
	
	# Limite massimo 3 pedali nella pedalboard
	p.owned_pedals.append("chorus")
	p.owned_pedals.append("tape_delay")
	p.owned_pedals.append("wah_wah")
	p.equip_pedal("chorus")
	p.equip_pedal("tape_delay")
	assert_equal(p.active_pedalboard.size(), 3, "3 pedali equipaggiati")
	var over_pedal := p.equip_pedal("wah_wah")
	assert_equal(over_pedal, false, "Quarto pedale rifiutato (limite 3)")

# -------------------------------------------------------------
# TEST 6C: Usura Strumento, Liutaio & Stage Accidents con Muletto
# -------------------------------------------------------------
func test_luthier_wear_and_stage_accidents() -> void:
	print("\n[TEST 6C] Usura Strumenti, Liutaio & Incidenti sul Palco:")
	var p := PlayerData.new()
	p.primary_instrument = "guitar"
	p.money = 300.0
	
	# Usura dopo concerto
	var cal := CalendarData.new()
	var concert_sys := ConcertSystem.new(p, cal)
	var venue := VenueData.new("v1", "Club Underground", 100, 0.0, 0.0, 10.0, 10.0)
	var s := SongData.new("s1", "Song", Enums.MusicalGenre.ROCK)
	s.status = Enums.SongStatus.PRODUCED
	s.quality_score = 70.0
	
	concert_sys.resolve_concert(venue, [s], 10.0)
	assert_equal(p.get_instrument_condition("guitar"), 92.0, "Usura concerto applicata (-8% -> 92%)")
	
	# Usura critica (< 20%) e incidente senza muletto
	p.instrument_condition["guitar"] = 15.0
	p.has_backup_instrument = false
	var res_accident := concert_sys.resolve_concert(venue, [s], 10.0, false, 0.0, true) # Force accident
	assert_true(res_accident["stage_accident"], "Incidente sul palco avvenuto")
	assert_equal(res_accident["accident_saved"], false, "Incidente non salvato senza muletto")
	assert_equal(res_accident["accident_penalty"], 15.0, "Penalità di -15 allo score applicata")
	
	# Incidente con Muletto di Riserva presente
	p.has_backup_instrument = true
	var res_saved := concert_sys.resolve_concert(venue, [s], 10.0, false, 0.0, true)
	assert_true(res_saved["stage_accident"], "Incidente sul palco avvenuto")
	assert_true(res_saved["accident_saved"], "Incidente salvato istantaneamente con il muletto")
	assert_equal(res_saved["accident_penalty"], 0.0, "Penalità azzerata grazie al muletto di riserva")
	
	# Riparazione dal Liutaio (Manutenzione Ordinaria, 30 €)
	p.money = 100.0
	var rep_res := p.repair_instrument("guitar", false)
	assert_true(rep_res["success"], "Riparazione liuteria riuscita")
	assert_equal(p.get_instrument_condition("guitar"), 100.0, "Integrità ripristinata al 100%")
	assert_equal(p.money, 70.0, "Costo liuteria 30 € detratto (100 -> 70)")

# -------------------------------------------------------------
# TEST 6D: Dotazione Strumentale Compagni Band & Sinergia
# -------------------------------------------------------------
func test_band_equipment_assignment() -> void:
	print("\n[TEST 6D] Assegnazione Equipaggiamento ai Compagni di Band:")
	var p := PlayerData.new()
	var cal := CalendarData.new()
	var band_sys := BandSystem.new(p, cal)
	
	var m := BandMemberData.new("b1", "Basso Dave", Enums.BandRole.BASS)
	p.add_band_member(m)
	
	var base_synergy: float = band_sys.get_band_synergy_bonus()
	
	# Equipaggia il bassista con Tier 2
	p.equip_band_member("b1", 2)
	assert_equal(m.equipped_gear_tier, 2, "Bassista equipaggiato con Tier 2")
	var boosted_synergy: float = band_sys.get_band_synergy_bonus()
	assert_true(boosted_synergy > base_synergy, "Sinergia aumentata dopo assegnazione basso pro (+%.1f > +%.1f)" % [boosted_synergy, base_synergy])

# -------------------------------------------------------------
# TEST 7: Interazione UpgradesModal (5 Schede & Sezione 4)
# -------------------------------------------------------------
func test_upgrades_modal_interaction() -> void:
	print("\n[TEST 7] Interazione UpgradesModal (5 Schede):")
	upgrades_instance = upgrades_scene.instantiate()
	add_child(upgrades_instance)
	
	upgrades_instance.open()
	assert_true(upgrades_instance.visible, "Modale Upgrades aperta con successo")
	
	# Verifica le 5 schede
	upgrades_instance.select_tab(1)
	assert_equal(upgrades_instance.current_tab, 1, "Scheda 1 (Alloggi) attiva")
	
	upgrades_instance.select_tab(2)
	assert_equal(upgrades_instance.current_tab, 2, "Scheda 2 (Sala Prove) attiva")
	
	upgrades_instance.select_tab(3)
	assert_equal(upgrades_instance.current_tab, 3, "Scheda 3 (Strumenti) attiva")
	
	upgrades_instance.select_tab(4)
	assert_equal(upgrades_instance.current_tab, 4, "Scheda 4 (Hardware) attiva")
	
	upgrades_instance.select_tab(5)
	assert_equal(upgrades_instance.current_tab, 5, "Scheda 5 (Sound Shaping & Liutaio) attiva")
	assert_true(upgrades_instance.panel_shaping.visible, "Pannello Sound Shaping visibile")
	
	# Test acquisti nella modale
	if GameManager and GameManager.player_data:
		GameManager.player_data.money = 3000.0
		
		# Test acquisto chitarra semi-pro
		upgrades_instance.select_tab(3)
		upgrades_instance.select_gear_category("guitar")
		upgrades_instance._on_buy_instrument(1)
		assert_equal(GameManager.player_data.get_instrument_tier("guitar"), 1, "Chitarra tier 1 acquistata nella modale")
		
		# Test toggle filosofia registrazione
		upgrades_instance.select_tab(4)
		upgrades_instance._on_toggle_philosophy_pressed()
		assert_equal(GameManager.player_data.recording_philosophy, 1, "Filosofia nastro attivata da pulsante")
		
		# Test acquisto amplificatore in Scheda 5
		upgrades_instance.select_tab(5)
		upgrades_instance._on_buy_amp(UpgradeData.AmpType.BRITISH_TUBE)
		assert_equal(GameManager.player_data.current_amp_tier, 1, "Ampli britannico equipaggiato da modale")
		
		# Test acquisto muletto in Scheda 5
		upgrades_instance._on_buy_backup_pressed()
		assert_equal(GameManager.player_data.has_backup_instrument, true, "Muletto acquistato da modale")
	
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
