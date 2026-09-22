# res://tests/test_concert_system.gd
extends Node

## Suite di Test Automatizzati per il Sistema Concerti dal Vivo (Phase 4 / Vertical Slice V1.2)
## Copre: VenueData, ConcertSystem (pre-requisiti, soundcheck, stage events, closer bonus, economics),
## conversioni fan, e istanziazione accessibile della UI LiveConcert.

var tests_passed: int = 0
var tests_failed: int = 0

func _ready() -> void:
	print("\n========================================================")
	print("   SUITE TEST SISTEMA CONCERTI DAL VIVO (FASE 4)       ")
	print("========================================================\n")
	
	test_venue_data_model_and_catalog()
	test_playable_songs_filtering()
	test_concert_prerequisites_and_validation()
	test_soundcheck_mechanics()
	test_stage_events_and_skill_checks()
	test_concert_resolution_and_economics()
	test_setlist_closer_traits_bonus()
	test_live_concert_ui_scene_instantiation()
	
	print("\n--------------------------------------------------------")
	print("ESITO COMPLESSIVO TEST SISTEMA CONCERTI:")
	print("  Test Superati: %d" % tests_passed)
	print("  Test Falliti:  %d" % tests_failed)
	print("--------------------------------------------------------\n")
	
	if tests_failed > 0:
		print("[ERRORE CRITICO] Alcuni test del sistema concerti sono falliti!")
		get_tree().quit(1)
	else:
		print("[SUCCESSO] Il sistema Concerti dal Vivo e Loop Live è convalidato al 100%!")
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

# 1. Test VenueData Model e Catalogo Default
func test_venue_data_model_and_catalog() -> void:
	print("1. Verifica VenueData Model e Catalogo Default:")
	var venues: Array[VenueData] = VenueData.get_default_venues()
	assert_eq(venues.size(), 4, "Catalogo contiene esattamente 4 locali iniziali")
	
	var garage: VenueData = venues[0]
	assert_eq(garage.id, "venue_garage", "Primo locale è il garage")
	assert_eq(garage.capacity, 15, "Capacità garage = 15")
	assert_eq(garage.rent_cost, 0.0, "Affitto garage = 0")
	assert_eq(garage.min_popularity, 0.0, "Minima popolarità garage = 0")
	
	var pub: VenueData = venues[1]
	assert_eq(pub.id, "venue_pub", "Secondo locale è il pub")
	assert_eq(pub.capacity, 60, "Capacità pub = 60")
	assert_eq(pub.rent_cost, 50.0, "Affitto pub = 50")
	
	var club: VenueData = venues[2]
	assert_eq(club.id, "venue_small_club", "Terzo locale è il piccolo club")
	assert_eq(club.capacity, 180, "Capacità club = 180")
	assert_eq(club.rent_cost, 250.0, "Affitto club = 250")
	
	var trendy: VenueData = venues[3]
	assert_eq(trendy.id, "venue_trendy_club", "Quarto locale è club di tendenza")
	assert_eq(trendy.capacity, 450, "Capacità club tendenza = 450")
	assert_eq(trendy.rent_cost, 700.0, "Affitto club tendenza = 700")
	
	# Verifica serializzazione to_dict e from_dict
	var v_dict: Dictionary = pub.to_dict()
	var loaded_v: VenueData = VenueData.new()
	loaded_v.from_dict(v_dict)
	assert_eq(loaded_v.id, "venue_pub", "from_dict deserializza id corretto")
	assert_eq(loaded_v.capacity, 60, "from_dict deserializza capacità corretta")
	assert_eq(loaded_v.rent_cost, 50.0, "from_dict deserializza affitto corretto")
	assert_true(loaded_v.get_localized_name().length() > 0, "get_localized_name restituisce una stringa valida")

# 2. Test Filtraggio Canzoni Eseguibili (get_playable_songs)
func test_playable_songs_filtering() -> void:
	print("\n2. Verifica Filtraggio Canzoni Eseguibili in Scaletta:")
	var player: PlayerData = PlayerData.new()
	
	var s_draft: SongData = SongData.new("s1", "Bozza Grezza", Enums.MusicalGenre.ROCK)
	s_draft.status = Enums.SongStatus.DRAFT
	
	var s_prod: SongData = SongData.new("s2", "Master Terminato", Enums.MusicalGenre.ROCK)
	s_prod.status = Enums.SongStatus.PRODUCED
	s_prod.quality_score = 80.0
	
	var s_rel: SongData = SongData.new("s3", "Singolo Rilasciato", Enums.MusicalGenre.METAL)
	s_rel.status = Enums.SongStatus.RELEASED
	s_rel.quality_score = 90.0
	
	player.songs = [s_draft, s_prod, s_rel]
	
	var playable: Array[SongData] = player.get_playable_songs()
	assert_eq(playable.size(), 2, "Solo brani PRODUCED e RELEASED sono eseguibili live")
	assert_eq(playable[0].id, "s2", "Primo brano è s2")
	assert_eq(playable[1].id, "s3", "Secondo brano è s3")

# 3. Test Pre-requisiti Concerto e Validazione
func test_concert_prerequisites_and_validation() -> void:
	print("\n3. Verifica Validazione Requisiti Concerto:")
	var player: PlayerData = PlayerData.new()
	var concert_sys: ConcertSystem = ConcertSystem.new(player)
	var venues: Array[VenueData] = VenueData.get_default_venues()
	var pub: VenueData = venues[1] # Richiede 50$ affitto, 25 energia, popolarità 5
	
	var valid_song: SongData = SongData.new("s1", "Song 1", Enums.MusicalGenre.ROCK)
	valid_song.status = Enums.SongStatus.RELEASED
	var setlist: Array[SongData] = [valid_song]
	
	# Caso 1: Scaletta vuota
	var check_empty: Dictionary = concert_sys.can_play_concert(pub, [])
	assert_eq(check_empty["allowed"], false, "Scaletta vuota rifiutata")
	
	# Caso 2: Energia insufficiente
	player.energy = 10
	player.money = 200.0
	player.popularity = 20.0
	var check_energy: Dictionary = concert_sys.can_play_concert(pub, setlist)
	assert_eq(check_energy["allowed"], false, "Energia insufficiente rifiutata")
	
	# Caso 3: Soldi insufficienti per l'affitto
	player.energy = 100
	player.money = 20.0 # Meno dei 50$ del pub
	player.popularity = 20.0
	var check_money: Dictionary = concert_sys.can_play_concert(pub, setlist)
	assert_eq(check_money["allowed"], false, "Fondi per affitto insufficienti rifiutati")
	
	# Caso 4: Popolarità insufficiente per il locale
	player.energy = 100
	player.money = 200.0
	player.popularity = 2.0 # Meno dei 5 minimi del pub
	var check_pop: Dictionary = concert_sys.can_play_concert(pub, setlist)
	assert_eq(check_pop["allowed"], false, "Popolarità insufficiente rifiutata")
	
	# Caso 5: Tutti i requisiti soddisfatti
	player.popularity = 15.0
	var check_ok: Dictionary = concert_sys.can_play_concert(pub, setlist)
	assert_eq(check_ok["allowed"], true, "Tutti i requisiti soddisfatti approvati")

# 4. Test Soundcheck
func test_soundcheck_mechanics() -> void:
	print("\n4. Verifica Meccaniche Soundcheck:")
	var player: PlayerData = PlayerData.new()
	player.energy = 50
	var concert_sys: ConcertSystem = ConcertSystem.new(player)
	
	var res: Dictionary = concert_sys.perform_soundcheck()
	assert_true(res["success"], "perform_soundcheck eseguito con successo")
	assert_eq(player.energy, 35, "Soundcheck consuma 15 punti energia (50 - 15 = 35)")
	assert_eq(res["acoustic_bonus"], 5.0, "Bonus acustico pari a +5.0%")
	
	# Tentativo con energia insufficiente
	player.energy = 10
	var fail_check: Dictionary = concert_sys.perform_soundcheck()
	assert_eq(fail_check["success"], false, "Soundcheck rifiutato con energia < 15")

# 5. Test Eventi di Palco e Check Abilità
func test_stage_events_and_skill_checks() -> void:
	print("\n5. Verifica Generazione Eventi di Palco e Branch Abilità:")
	var player: PlayerData = PlayerData.new()
	player.skills["charisma"] = 25
	player.skills["performance"] = 4
	var skill_sys: SkillSystem = SkillSystem.new(player)
	var concert_sys: ConcertSystem = ConcertSystem.new(player, null, skill_sys)
	
	# Con is_soundcheck_done = true, non deve mai generare AUDIO_FEEDBACK
	var generated_events: Array[int] = []
	for i in range(25):
		var ev_dict: Dictionary = concert_sys.generate_stage_event(true)
		generated_events.append(ev_dict["type"])
	
	assert_true(not (Enums.StageEventType.AUDIO_FEEDBACK in generated_events), "Con soundcheck effettuato, AUDIO_FEEDBACK non si verifica mai")
	
	# Test Risoluzione Scelta 1 (Carisma alto)
	player.skills["charisma"] = {"level": 25, "xp": 0.0}
	player.skills["performance"] = {"level": 4, "xp": 0.0}
	
	var ev_broken: Dictionary = {
		"type": Enums.StageEventType.BROKEN_STRING,
		"title": "Corda Spezzata",
		"description": "Una corda cede durante il bridge",
		"choice_1_skill": "charisma",
		"choice_2_skill": "performance"
	}
	
	var res_a: Dictionary = concert_sys.resolve_stage_event_choice(ev_broken, 1)
	assert_eq(res_a["skill_tested"], "charisma", "Scelta 1 testa Carisma")
	assert_true(res_a["score_delta"] != 0.0, "Delta score valorizzato")
	assert_true(res_a["xp_awarded"] > 0, "Guadagno XP positivo")

# 6. Test Risoluzione Concerto ed Economia
func test_concert_resolution_and_economics() -> void:
	print("\n6. Verifica Risoluzione Concerto ed Economia:")
	var player: PlayerData = PlayerData.new()
	player.money = 100.0
	player.energy = 50
	player.fans = 20
	player.popularity = 25.0
	
	var concert_sys: ConcertSystem = ConcertSystem.new(player)
	var venues: Array[VenueData] = VenueData.get_default_venues()
	var pub: VenueData = venues[1] # cap 60, rent 50, fair_price 5
	
	var song1: SongData = SongData.new("s1", "Banger 1", Enums.MusicalGenre.ROCK)
	song1.status = Enums.SongStatus.RELEASED
	song1.quality_score = 80.0
	var setlist: Array[SongData] = [song1]
	
	# Concerto con prezzo 5$
	var initial_money: float = player.money
	var result: Dictionary = concert_sys.resolve_concert(pub, setlist, 5.0, false, 0.0)
	assert_true(result["success"], "Concerto risolto con successo")
	assert_true(result["audience"] > 0, "Pubblico presente al concerto")
	assert_true(result["audience"] <= pub.capacity, "Pubblico non supera la capienza del locale")
	assert_eq(result["gross_revenue"], float(result["audience"]) * 5.0, "Incasso lordo = spettatori * prezzo biglietto")
	assert_eq(result["rent_cost"], 50.0, "Affitto pagato = 50.0")
	assert_eq(result["net_revenue"], result["gross_revenue"] - 50.0, "Ricavo netto = lordo - affitto")
	assert_eq(player.money, initial_money + result["net_revenue"], "Saldo giocatore aggiornato correttamente")
	assert_true(player.fans >= 20, "Fan acquisiti o mantenuti")

# 7. Test Closer Bonus della Scaletta (Tratti STAGE_BEAST e CULT_CLASSIC)
func test_setlist_closer_traits_bonus() -> void:
	print("\n7. Verifica Bonus di Chiusura Scaletta (Closer Traits):")
	var player1: PlayerData = PlayerData.new()
	player1.popularity = 50.0
	player1.energy = 100
	player1.money = 500.0
	var concert_sys1: ConcertSystem = ConcertSystem.new(player1)
	
	var player2: PlayerData = PlayerData.new()
	player2.popularity = 50.0
	player2.energy = 100
	player2.money = 500.0
	var concert_sys2: ConcertSystem = ConcertSystem.new(player2)
	
	var venues: Array[VenueData] = VenueData.get_default_venues()
	var garage: VenueData = venues[0]
	
	# Canzone standard
	var song_norm: SongData = SongData.new("sn", "Normal Song", Enums.MusicalGenre.ROCK)
	song_norm.status = Enums.SongStatus.RELEASED
	song_norm.quality_score = 70.0
	
	# Canzone con STAGE_BEAST
	var song_beast: SongData = SongData.new("sb", "Stage Beast Song", Enums.MusicalGenre.ROCK)
	song_beast.status = Enums.SongStatus.RELEASED
	song_beast.quality_score = 70.0
	song_beast.special_trait = Enums.SongTrait.STAGE_BEAST
	
	# Risoluzione scaletta standard vs scaletta con closer STAGE_BEAST
	var res_norm: Dictionary = concert_sys1.resolve_concert(garage, [song_norm], 0.0, false, 0.0)
	var res_beast: Dictionary = concert_sys2.resolve_concert(garage, [song_beast], 0.0, false, 0.0)
	
	assert_true(res_beast["concert_score"] > res_norm["concert_score"], "Closer con STAGE_BEAST incrementa il punteggio concerto")
	
	# Canzone con CULT_CLASSIC
	var player3: PlayerData = PlayerData.new()
	player3.popularity = 50.0
	player3.energy = 100
	player3.money = 500.0
	var concert_sys3: ConcertSystem = ConcertSystem.new(player3)
	
	var song_cult: SongData = SongData.new("sc", "Cult Classic Song", Enums.MusicalGenre.ROCK)
	song_cult.status = Enums.SongStatus.RELEASED
	song_cult.quality_score = 70.0
	song_cult.special_trait = Enums.SongTrait.CULT_CLASSIC
	
	var res_cult: Dictionary = concert_sys3.resolve_concert(garage, [song_cult], 0.0, false, 0.0)
	assert_true(res_cult["new_fans"] >= res_norm["new_fans"], "Closer con CULT_CLASSIC aumenta la conversione dei fan")

# 8. Test Istanziazione UI LiveConcert e Nodi AccessKit
func test_live_concert_ui_scene_instantiation() -> void:
	print("\n8. Verifica Istanziazione Scena UI LiveConcert:")
	var concert_scene = load("res://ui/concert/live_concert.tscn")
	assert_true(concert_scene != null, "Scena live_concert.tscn caricata")
	
	var instance: Node = concert_scene.instantiate()
	assert_true(instance != null, "Istanza live_concert creata")
	
	# Verifica presenza nodi e bottoni accessibili
	var chk_soundcheck: CheckBox = instance.get_node_or_null("PanelMain/VBox/PrepContainer/ChkSoundcheck")
	var btn_start_concert: Button = instance.get_node_or_null("PanelMain/VBox/PrepContainer/HBoxPrepButtons/BtnStartConcert")
	var btn_cancel_prep: Button = instance.get_node_or_null("PanelMain/VBox/PrepContainer/HBoxPrepButtons/BtnCancelPrep")
	var btn_choice_1: Button = instance.get_node_or_null("PanelMain/VBox/ShowContainer/PanelEvent/VBoxEvent/HBoxChoices/BtnChoice1")
	var btn_choice_2: Button = instance.get_node_or_null("PanelMain/VBox/ShowContainer/PanelEvent/VBoxEvent/HBoxChoices/BtnChoice2")
	var btn_next_phase: Button = instance.get_node_or_null("PanelMain/VBox/ShowContainer/HBoxShowButtons/BtnNextPhase")
	var btn_finish_concert: Button = instance.get_node_or_null("PanelMain/VBox/SummaryContainer/HBoxSummaryButtons/BtnFinishConcert")
	
	assert_true(chk_soundcheck != null, "ChkSoundcheck presente")
	assert_true(btn_start_concert != null, "BtnStartConcert presente")
	assert_true(btn_cancel_prep != null, "BtnCancelPrep presente")
	assert_true(btn_choice_1 != null, "BtnChoice1 presente")
	assert_true(btn_choice_2 != null, "BtnChoice2 presente")
	assert_true(btn_next_phase != null, "BtnNextPhase presente")
	assert_true(btn_finish_concert != null, "BtnFinishConcert presente")
	
	instance.queue_free()
