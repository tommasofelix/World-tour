# res://tests/test_band_system.gd
extends Node

## Suite di Test Headless per il Sistema Band e Dinamiche Umane (World-tour V2.0)
## Valida BandMemberData -> BandSystem -> Reclutamento -> Sinergia Concerti -> Revenue Split -> BandHub UI

var tests_passed: int = 0
var tests_failed: int = 0

func _ready() -> void:
	print("\n========================================================")
	print("   SUITE TEST SISTEMA BAND & DINAMICHE UMANE (V2.0)   ")
	print("========================================================\n")
	
	test_candidate_generation()
	test_audition_flow()
	test_hiring_and_role_limits()
	test_band_chemistry_and_synergy()
	test_revenue_split_impact()
	test_post_concert_dynamics()
	test_concert_with_band_and_split()
	test_band_hub_ui_instantiation()
	
	print("\n--------------------------------------------------------")
	print("ESITO COMPLESSIVO TEST SISTEMA BAND:")
	print("  Test Superati: ", tests_passed)
	print("  Test Falliti:  ", tests_failed)
	print("--------------------------------------------------------\n")
	
	if tests_failed > 0:
		printerr("[ERRORE CRITICO] Il Sistema Band presenta anomalie!")
		get_tree().quit(1)
	else:
		print("[SUCCESSO] Il Sistema Band & Dinamiche Umane è convalidato al 100%!")
		get_tree().quit(0)

func assert_true(condition: bool, test_name: String) -> void:
	if condition:
		print("  [OK] ", test_name)
		tests_passed += 1
	else:
		printerr("  [FALLITO] ", test_name)
		tests_failed += 1

func assert_equal(actual: Variant, expected: Variant, test_name: String) -> void:
	if actual == expected:
		print("  [OK] %s (%s == %s)" % [test_name, str(actual), str(expected)])
		tests_passed += 1
	else:
		printerr("  [FALLITO] %s (Effettivo: %s, Atteso: %s)" % [test_name, str(actual), str(expected)])
		tests_failed += 1

# 1. Generazione Candidati
func test_candidate_generation() -> void:
	print("1. Verifica Generazione Candidati Audizioni:")
	var p := PlayerData.new()
	var cal := CalendarData.new()
	var band_sys := BandSystem.new(p, cal)
	
	assert_true(band_sys.candidates_pool.size() >= 4, "Almeno 4 candidati generati per le audizioni")
	var first_cand: BandMemberData = band_sys.candidates_pool[0]
	assert_true(not first_cand.member_name.is_empty(), "Candidato provvisto di nome valido")
	assert_true(first_cand.skill_level >= 10, "Livello abilità del candidato >= 10")
	
	band_sys.refresh_candidates_pool()
	assert_true(band_sys.candidates_pool.size() >= 4, "Refresh bacheca genera nuovi candidati")

# 2. Audizioni e Costi
func test_audition_flow() -> void:
	print("\n2. Verifica Flusso Audizioni e Costi:")
	var p := PlayerData.new()
	p.money = 20.0 # Meno del costo audizione (30 €)
	var band_sys := BandSystem.new(p)
	var cand := band_sys.candidates_pool[0]
	
	var fail_res := band_sys.audition_candidate(cand)
	assert_true(not fail_res.get("success", true), "Audizione rifiutata per fondi insufficienti (< 30 €)")
	assert_equal(fail_res.get("reason", ""), "money_insufficient", "Causa rifiuto: money_insufficient")
	
	p.money = 100.0
	var ok_res := band_sys.audition_candidate(cand)
	assert_true(ok_res.get("success", false), "Audizione riuscita con fondi sufficienti")
	assert_equal(p.money, 70.0, "Detratti 30.00 € dal saldo per l'audizione (100 -> 70)")
	assert_true(ok_res.get("compatibility", 0.0) > 0.0, "Compatibilità calcolata con successo")

# 3. Ingaggio e Limiti di Formazione
func test_hiring_and_role_limits() -> void:
	print("\n3. Verifica Ingaggio e Limiti di Formazione:")
	var p := PlayerData.new()
	var band_sys := BandSystem.new(p)
	
	var b1 := BandMemberData.new("m_bass", "Davide Bass", Enums.BandRole.BASS, Enums.BandPersonality.RELIABLE, Enums.MusicalGenre.ROCK, 20)
	var hire1 := band_sys.hire_candidate(b1)
	assert_true(hire1.get("success", false), "Primo membro (Basso) ingaggiato con successo")
	assert_equal(p.band_members.size(), 1, "Membri attivi = 1")
	
	# Tentativo di ingaggiare un secondo bassista
	var b2 := BandMemberData.new("m_bass2", "Elena Bass", Enums.BandRole.BASS, Enums.BandPersonality.PERFECTIONIST, Enums.MusicalGenre.ROCK, 22)
	var hire_dup := band_sys.hire_candidate(b2)
	assert_true(not hire_dup.get("success", true), "Ingaggio rifiutato per ruolo già coperto")
	assert_equal(hire_dup.get("reason", ""), "role_filled", "Causa rifiuto: role_filled")
	
	# Riempi la band fino a 3 membri
	var d1 := BandMemberData.new("m_drums", "Matteo Beats", Enums.BandRole.DRUMS, Enums.BandPersonality.WILD_PARTY, Enums.MusicalGenre.ROCK, 18)
	var k1 := BandMemberData.new("m_keys", "Sara Keys", Enums.BandRole.KEYBOARDS, Enums.BandPersonality.RELIABLE, Enums.MusicalGenre.ROCK, 25)
	band_sys.hire_candidate(d1)
	band_sys.hire_candidate(k1)
	assert_equal(p.band_members.size(), 3, "Formazione completa a 3 compagni")
	assert_true(p.has_full_band(), "Flag has_full_band() true")
	
	# Quarto compagno oltre il limite
	var g1 := BandMemberData.new("m_guit2", "Chiara Riff", Enums.BandRole.GUITAR_RHYTHM, Enums.BandPersonality.EGO_ARTIST, Enums.MusicalGenre.ROCK, 30)
	var hire_over := band_sys.hire_candidate(g1)
	assert_true(not hire_over.get("success", true), "Quarto compagno rifiutato (limite max raggiunto)")
	assert_equal(hire_over.get("reason", ""), "band_full", "Causa rifiuto: band_full")
	
	# Licenziamento
	var fire_res := band_sys.fire_member("m_bass")
	assert_true(fire_res.get("success", false), "Licenziamento membro riuscito")
	assert_equal(p.band_members.size(), 2, "Membri rimanenti = 2")

# 4. Chimica di Gruppo e Sinergia
func test_band_chemistry_and_synergy() -> void:
	print("\n4. Verifica Chimica di Gruppo e Sinergia Palco:")
	var p := PlayerData.new()
	var band_sys := BandSystem.new(p)
	
	# Senza band
	assert_equal(band_sys.get_band_synergy_bonus(), 0.0, "Sinergia senza band = 0.0%")
	
	# Aggiungi compagni affiatati (Affinità 80, Rispetto 80, Tensione 0)
	var m1 := BandMemberData.new("m1", "Drummer", Enums.BandRole.DRUMS)
	m1.affinity = 80.0
	m1.musical_respect = 80.0
	m1.tension = 0.0
	p.add_band_member(m1)
	
	var m2 := BandMemberData.new("m2", "Bassist", Enums.BandRole.BASS)
	m2.affinity = 80.0
	m2.musical_respect = 80.0
	m2.tension = 0.0
	p.add_band_member(m2)
	
	assert_equal(band_sys.get_average_affinity(), 80.0, "Media affinità = 80%")
	assert_equal(band_sys.get_average_respect(), 80.0, "Media rispetto = 80%")
	assert_equal(band_sys.get_average_tension(), 0.0, "Media tensione = 0%")
	
	var high_syn := band_sys.get_band_synergy_bonus()
	assert_true(high_syn > 15.0, "Sinergia con alta intesa > +15% (ottenuto: " + str(snappedf(high_syn, 0.1)) + "%)")
	
	# Tensione critica
	m1.tension = 90.0
	m2.tension = 90.0
	var low_syn := band_sys.get_band_synergy_bonus()
	assert_true(low_syn < 5.0, "Sinergia crolla con alta tensione (ottenuto: " + str(snappedf(low_syn, 0.1)) + "%)")

# 5. Politica Divisione Compensi (Revenue Split)
func test_revenue_split_impact() -> void:
	print("\n5. Verifica Politica Divisione Compensi (Revenue Split):")
	var p := PlayerData.new()
	var band_sys := BandSystem.new(p)
	var m := BandMemberData.new("m_ego", "Ego Guy", Enums.BandRole.GUITAR_RHYTHM, Enums.BandPersonality.EGO_ARTIST)
	m.affinity = 50.0
	m.musical_respect = 50.0
	m.tension = 10.0
	p.add_band_member(m)
	
	# Imposta quota predatoria (70% al leader)
	band_sys.set_revenue_split(Enums.RevenueSplit.LEADER_PREDATORY)
	assert_equal(p.revenue_split_mode, Enums.RevenueSplit.LEADER_PREDATORY, "Politica impostata a LEADER_PREDATORY")
	assert_true(m.tension >= 30.0, "Tensione aumentata con quota predatoria (attuale: %.0f%%)" % m.tension)
	assert_true(m.musical_respect < 50.0, "Rispetto calato con quota predatoria (attuale: %.0f%%)" % m.musical_respect)
	
	# Ritorna a divisione equa
	band_sys.set_revenue_split(Enums.RevenueSplit.EQUAL_SPLIT)
	assert_equal(p.revenue_split_mode, Enums.RevenueSplit.EQUAL_SPLIT, "Politica reimpostata a EQUAL_SPLIT")
	assert_true(m.tension <= 25.0, "Tensione calmierata con divisione paritaria (attuale: %.0f%%)" % m.tension)

# 6. Dinamiche Post-Concerto e Crisi
func test_post_concert_dynamics() -> void:
	print("\n6. Verifica Dinamiche Post-Concerto:")
	var p := PlayerData.new()
	var band_sys := BandSystem.new(p)
	var m := BandMemberData.new("m_crit", "Stressed", Enums.BandRole.BASS)
	m.tension = 80.0
	p.add_band_member(m)
	
	# Concerto fallimentare (< 50) genera tensione
	var crises := band_sys.process_post_concert_dynamics(35.0)
	assert_true(m.tension >= 85.0, "Tensione salita oltre soglia critica 85%")
	assert_true(m.is_threatening_to_quit(), "Membro minaccia abbandono")
	assert_equal(crises.size(), 1, "Rilevata 1 crisi di gruppo post-concerto")
	
	# Concerto trionfale (>= 75) rilassa gli animi
	band_sys.process_post_concert_dynamics(85.0)
	assert_true(m.tension < 85.0, "Concerto eccellente riduce la tensione sotto la soglia critica")

# 7. Risoluzione Concerto con Band e Revenue Split
func test_concert_with_band_and_split() -> void:
	print("\n7. Verifica Integrazione Live & Revenue Split:")
	GameManager.player_data = PlayerData.new()
	GameManager.calendar_data = CalendarData.new()
	GameManager.band_system = BandSystem.new(GameManager.player_data, GameManager.calendar_data)
	GameManager.skill_system = SkillSystem.new(GameManager.player_data)
	GameManager.concert_system = ConcertSystem.new(GameManager.player_data, GameManager.calendar_data, GameManager.skill_system)
	
	var p := GameManager.player_data
	p.money = 200.0
	p.popularity = 20.0
	
	# Aggiungi 3 membri
	p.add_band_member(BandMemberData.new("b1", "B1", Enums.BandRole.BASS))
	p.add_band_member(BandMemberData.new("d1", "D1", Enums.BandRole.DRUMS))
	p.add_band_member(BandMemberData.new("k1", "K1", Enums.BandRole.KEYBOARDS))
	
	var v := VenueData.new("pub", "The Pub", 100, 20.0, 10.0, 5)
	var s := SongData.new("s1", "Rock Hit", Enums.MusicalGenre.ROCK)
	s.status = Enums.SongStatus.PRODUCED
	s.quality_score = 70.0
	
	# Divisione Equa (4 membri totali = 25% al leader)
	p.revenue_split_mode = Enums.RevenueSplit.EQUAL_SPLIT
	var res := GameManager.concert_system.resolve_concert(v, [s], 10.0)
	
	assert_true(res.get("success", false), "Concerto con band risolto con successo")
	assert_true(res.get("band_synergy_bonus", 0.0) != 0.0, "Bonus sinergia band applicato al punteggio live")
	var gross: float = res.get("gross_revenue", 0.0)
	var player_cut: float = res.get("player_share", 0.0)
	assert_equal(player_cut, gross * 0.25, "Quota incasso leader = 25% su divisione equa (4 membri)")

# 8. Istanziazione Scena UI BandHub
func test_band_hub_ui_instantiation() -> void:
	print("\n8. Verifica Istanziazione Scena UI BandHub:")
	var hub_res: Resource = load("res://ui/band/band_hub.tscn")
	assert_true(hub_res != null, "Risorsa band_hub.tscn caricata")
	
	var hub: Control = hub_res.instantiate() as Control
	assert_true(hub != null, "Istanziazione BandHub riuscita")
	
	add_child(hub)
	var btn_close: Button = hub.get_node_or_null("PanelMain/VBox/HBoxBottom/BtnClose")
	var btn_refresh: Button = hub.get_node_or_null("PanelMain/VBox/HBoxBody/VBoxAuditions/BtnRefreshCandidates")
	var opt_split: OptionButton = hub.get_node_or_null("PanelMain/VBox/HBoxBottom/HBoxSplit/OptRevenueSplit")
	
	assert_true(btn_close != null, "BtnClose presente in BandHub")
	assert_true(btn_refresh != null, "BtnRefreshCandidates presente in BandHub")
	assert_true(opt_split != null, "OptRevenueSplit presente in BandHub")
	
	hub.refresh_hub()
	assert_equal(hub.vbox_members_list.get_child_count(), 3, "3 membri della band renderizzati nelle righe della UI")
	assert_true(hub.vbox_candidates_list.get_child_count() >= 4, "Bacheca audizioni renderizzata con candidati")
	
	remove_child(hub)
	hub.queue_free()
