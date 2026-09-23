# res://tests/test_concert_system.gd
extends Node

## Suite di Test Automatizzati per il Sistema Concerti dal Vivo (Sezione 5 / ASTRALIS v3.0.7)
## Copre: VenueData (6 locali), Calendario e Disponibilità Venue (stati, weekend surcharge, prenotazioni),
## Drammaturgia Scaletta (Opener, Ballad, Closer, Tratti Canzone), Cover di Repertorio,
## 7 Stage Events con bivi e check abilità, Banchetto Merchandising (4 articoli),
## Momento Bis / Encore ed istanziazione accessibile della UI LiveConcert.

var tests_passed: int = 0
var tests_failed: int = 0

func _ready() -> void:
	print("\n========================================================")
	print("   SUITE TEST SISTEMA CONCERTI DAL VIVO (SEZIONE 5)    ")
	print("========================================================\n")
	
	test_venue_data_model_and_catalog()
	test_playable_songs_filtering()
	test_concert_prerequisites_and_validation()
	test_venue_booking_and_calendar()
	test_soundcheck_mechanics()
	test_setlist_dramaturgy_and_covers()
	test_stage_events_and_skill_checks()
	test_merchandise_sales_and_economics()
	test_encore_mechanics()
	test_concert_resolution_and_economics()
	test_live_concert_ui_scene_instantiation()
	
	print("\n--------------------------------------------------------")
	print("ESITO COMPLESSIVO TEST SISTEMA CONCERTI SEZIONE 5:")
	print("  Test Superati: %d" % tests_passed)
	print("  Test Falliti:  %d" % tests_failed)
	print("--------------------------------------------------------\n")
	
	if tests_failed > 0:
		print("[ERRORE CRITICO] Alcuni test del sistema concerti sono falliti!")
		get_tree().quit(1)
	else:
		print("[SUCCESSO] Il sistema Concerti dal Vivo, Locali, Scaletta & Pubblico è convalidato al 100%!")
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

# 1. Test VenueData Model e Catalogo Default (6 Locali)
func test_venue_data_model_and_catalog() -> void:
	print("1. Verifica VenueData Model e Catalogo Default:")
	var venues: Array[VenueData] = VenueData.get_default_venues()
	assert_eq(venues.size(), 6, "Catalogo contiene esattamente 6 locali espansi")
	
	var garage: VenueData = venues[0]
	assert_eq(garage.id, "venue_garage", "Primo locale è il garage")
	assert_eq(garage.capacity, 15, "Capacità garage = 15")
	assert_eq(garage.rent_cost, 0.0, "Affitto garage = 0")
	
	var pub: VenueData = venues[1]
	assert_eq(pub.id, "venue_pub", "Secondo locale è il pub")
	assert_eq(pub.capacity, 60, "Capacità pub = 60")
	assert_eq(pub.rent_cost, 50.0, "Affitto pub = 50")
	
	var social: VenueData = venues[2]
	assert_eq(social.id, "venue_social_center", "Terzo locale è il centro sociale")
	assert_eq(social.capacity, 120, "Capacità centro sociale = 120")
	assert_eq(social.rent_cost, 30.0, "Affitto centro sociale = 30")
	assert_eq(social.venue_type, VenueData.TYPE_SOCIAL_CENTER, "Tipo centro sociale corretto")
	
	var club: VenueData = venues[3]
	assert_eq(club.id, "venue_small_club", "Quarto locale è il piccolo club")
	assert_eq(club.capacity, 180, "Capacità club = 180")
	assert_eq(club.rent_cost, 250.0, "Affitto club = 250")
	
	var trendy: VenueData = venues[4]
	assert_eq(trendy.id, "venue_trendy_club", "Quinto locale è club di tendenza")
	assert_eq(trendy.capacity, 450, "Capacità club tendenza = 450")
	assert_eq(trendy.rent_cost, 700.0, "Affitto club tendenza = 700")
	
	var opera: VenueData = venues[5]
	assert_eq(opera.id, "venue_opera_theatre", "Sesto locale è il teatro d'opera")
	assert_eq(opera.capacity, 800, "Capacità teatro opera = 800")
	assert_eq(opera.rent_cost, 1600.0, "Affitto teatro opera = 1600")
	assert_eq(opera.min_popularity, 60.0, "Popolarità minima teatro = 60%")
	assert_eq(opera.min_reputation, 35.0, "Reputazione minima teatro = 35")
	assert_eq(opera.venue_type, VenueData.TYPE_OPERA_THEATRE, "Tipo teatro opera corretto")
	
	# Verifica serializzazione to_dict e from_dict
	var v_dict: Dictionary = opera.to_dict()
	var loaded_v: VenueData = VenueData.new()
	loaded_v.from_dict(v_dict)
	assert_eq(loaded_v.id, "venue_opera_theatre", "from_dict deserializza id teatro")
	assert_eq(loaded_v.capacity, 800, "from_dict deserializza capacità corretta")
	assert_eq(loaded_v.venue_type, VenueData.TYPE_OPERA_THEATRE, "from_dict deserializza venue_type")
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
	var cal: CalendarData = CalendarData.new()
	cal.day_number = 1 # Lunedì
	var concert_sys: ConcertSystem = ConcertSystem.new(player, cal)
	var venues: Array[VenueData] = VenueData.get_default_venues()
	var pub: VenueData = venues[1]
	var opera: VenueData = venues[5]
	
	var valid_song: SongData = SongData.new("s1", "Song 1", Enums.MusicalGenre.ROCK)
	valid_song.status = Enums.SongStatus.RELEASED
	var setlist: Array[SongData] = [valid_song]
	
	# Assicuriamo che il pub sia libero oggi per testare gli altri requisiti
	concert_sys.set_venue_status_override(pub.id, 1, Enums.VenueBookingStatus.FREE)
	
	# Scaletta vuota
	var check_empty: Dictionary = concert_sys.can_play_concert(pub, [])
	assert_eq(check_empty["allowed"], false, "Scaletta vuota rifiutata")
	
	# Energia insufficiente
	player.energy = 10
	player.money = 200.0
	player.popularity = 20.0
	var check_energy: Dictionary = concert_sys.can_play_concert(pub, setlist)
	assert_eq(check_energy["allowed"], false, "Energia insufficiente rifiutata")
	
	# Soldi insufficienti per affitto
	player.energy = 100
	player.money = 20.0
	player.popularity = 20.0
	var check_money: Dictionary = concert_sys.can_play_concert(pub, setlist)
	assert_eq(check_money["allowed"], false, "Fondi per affitto insufficienti rifiutati")
	
	# Popolarità insufficiente
	player.money = 2000.0
	player.popularity = 2.0
	var check_pop: Dictionary = concert_sys.can_play_concert(pub, setlist)
	assert_eq(check_pop["allowed"], false, "Popolarità insufficiente rifiutata")
	
	# Reputazione insufficiente per il teatro d'opera
	player.popularity = 70.0
	player.reputation = 10.0 # Richiede 35.0
	concert_sys.set_venue_status_override(opera.id, 1, Enums.VenueBookingStatus.FREE)
	var check_rep: Dictionary = concert_sys.can_play_concert(opera, setlist)
	assert_eq(check_rep["allowed"], false, "Reputazione insufficiente per teatro rifiutata")
	
	# Locale occupato da un'altra band
	player.popularity = 80.0
	player.reputation = 50.0
	concert_sys.set_venue_status_override(pub.id, 1, Enums.VenueBookingStatus.BOOKED_OTHER)
	var check_occupied: Dictionary = concert_sys.can_play_concert(pub, setlist)
	assert_eq(check_occupied["allowed"], false, "Locale occupato oggi rifiutato")
	
	# Locale libero e requisiti soddisfatti
	concert_sys.set_venue_status_override(pub.id, 1, Enums.VenueBookingStatus.FREE)
	var check_ok: Dictionary = concert_sys.can_play_concert(pub, setlist)
	assert_eq(check_ok["allowed"], true, "Tutti i requisiti soddisfatti approvati")

# 4. Test Calendario Venue, Stati e Weekend Surcharge
func test_venue_booking_and_calendar() -> void:
	print("\n4. Verifica Calendario Venue e Disponibilità (La Meccanica di Luca):")
	var player: PlayerData = PlayerData.new()
	var cal: CalendarData = CalendarData.new()
	var concert_sys: ConcertSystem = ConcertSystem.new(player, cal)
	var venues: Array[VenueData] = VenueData.get_default_venues()
	var club: VenueData = venues[3]
	
	# Verifica calcolo affitto con sovrapprezzo weekend
	# Giorno 1 = Lunedì (Feriale: affitto 250 €)
	var rent_mon: float = concert_sys.get_venue_rent_cost(club, 1)
	assert_eq(rent_mon, 250.0, "Affitto di Lunedì è nominale (250 €)")
	
	# Giorno 5 = Venerdì (Weekend: affitto 250 * 1.20 = 300 €)
	var rent_fri: float = concert_sys.get_venue_rent_cost(club, 5)
	assert_eq(rent_fri, 300.0, "Affitto di Venerdì ha sovrapprezzo weekend (+20% -> 300 €)")
	
	# Giorno 6 = Sabato (Weekend: affitto 250 * 1.20 = 300 €)
	var rent_sat: float = concert_sys.get_venue_rent_cost(club, 6)
	assert_eq(rent_sat, 300.0, "Affitto di Sabato ha sovrapprezzo weekend (+20% -> 300 €)")
	
	# Verifica prenotazione anticipata
	concert_sys.set_venue_status_override(club.id, 10, Enums.VenueBookingStatus.FREE)
	var booked: bool = concert_sys.book_venue_date(club.id, 10)
	assert_true(booked, "book_venue_date restituisce true per data libera")
	var status_booked: int = concert_sys.get_venue_status(club.id, 10)
	assert_eq(status_booked, Enums.VenueBookingStatus.BOOKED_PLAYER, "Data prenotata risulta BOOKED_PLAYER")
	
	# Tentativo di riprenotare data già occupata
	var rebook: bool = concert_sys.book_venue_date(club.id, 10)
	assert_eq(rebook, false, "Impossibile prenotare locale già occupato")

# 5. Test Soundcheck
func test_soundcheck_mechanics() -> void:
	print("\n5. Verifica Meccaniche Soundcheck:")
	var player: PlayerData = PlayerData.new()
	player.energy = 50
	var concert_sys: ConcertSystem = ConcertSystem.new(player)
	
	var res: Dictionary = concert_sys.perform_soundcheck()
	assert_true(res["success"], "perform_soundcheck eseguito con successo")
	assert_eq(player.energy, 35, "Soundcheck consuma 15 punti energia")
	assert_eq(res["acoustic_bonus"], 5.0, "Bonus acustico pari a +5.0%")

# 6. Test Drammaturgia della Scaletta, Tratti e Cover di Repertorio
func test_setlist_dramaturgy_and_covers() -> void:
	print("\n6. Verifica Drammaturgia Scaletta e Cover di Repertorio:")
	var player: PlayerData = PlayerData.new()
	player.popularity = 50.0
	player.energy = 100
	player.money = 1000.0
	player.stress = 20
	var concert_sys: ConcertSystem = ConcertSystem.new(player)
	var venues: Array[VenueData] = VenueData.get_default_venues()
	var pub: VenueData = venues[1]
	concert_sys.set_venue_status_override(pub.id, 1, Enums.VenueBookingStatus.FREE)
	
	# Canzone Rock energica (Opener)
	var song_opener: SongData = SongData.new("so", "High Energy Rock", Enums.MusicalGenre.ROCK)
	song_opener.status = Enums.SongStatus.RELEASED
	song_opener.quality_score = 75.0
	
	# Canzone Ballad (Mid-Set)
	var song_ballad: SongData = SongData.new("s_bal", "Tears of Rain", Enums.MusicalGenre.POP)
	song_ballad.status = Enums.SongStatus.RELEASED
	song_ballad.quality_score = 70.0
	song_ballad.special_trait = Enums.SongTrait.TEARJERKER_BALLAD
	
	# Canzone Closer Stage Beast (Closer)
	var song_closer: SongData = SongData.new("sc", "Thunder Closer", Enums.MusicalGenre.ROCK)
	song_closer.status = Enums.SongStatus.RELEASED
	song_closer.quality_score = 75.0
	song_closer.special_trait = Enums.SongTrait.STAGE_BEAST
	
	var setlist: Array[SongData] = [song_opener, song_ballad, song_closer]
	var res: Dictionary = concert_sys.resolve_concert(pub, setlist, 5.0, false, 0.0)
	
	assert_true(res["success"], "Concerto con scaletta drammaturgica completato con successo")
	assert_eq(res["opening_hype_bonus"], Constants.OPENING_HYPE_BONUS, "Bonus Opening Hype assegnato a brano Rock energico (+15)")
	assert_eq(res["opening_score_mult"], Constants.OPENING_SCORE_MULT, "Moltiplicatore score Opener x1.05 assegnato")
	assert_eq(res["ballad_fan_mult"], Constants.BALLAD_FAN_MULT, "Moltiplicatore fan Ballad x1.15 assegnato")
	assert_true(player.stress <= 25, "Stress della band ridotto dal momento intimo ballad")
	
	# Test Creazione Cover di Repertorio
	var cover: SongData = SongData.create_cover_song(Enums.MusicalGenre.ROCK, 20.0)
	assert_true(cover.is_cover, "Flag is_cover valorizzato a true")
	assert_true(cover.quality_score >= 55.0, "Qualità base cover solida (>= 55.0)")
	assert_true(cover.title.contains("Cover"), "Titolo contiene indicazione Cover")
	
	# Risoluzione concerto con cover
	var res_cover: Dictionary = concert_sys.resolve_concert(pub, [cover], 5.0, false, 0.0)
	assert_true(res_cover["success"], "Concerto con cover eseguito con successo")
	assert_eq(cover.plays, 0, "La cover non incrementa i plays originali nel catalogo della band")

# 7. Test Nuovi Stage Events (7 Tipi) e Risoluzione Bivi
func test_stage_events_and_skill_checks() -> void:
	print("\n7. Verifica 7 Stage Events e Bivi Scenici:")
	var player: PlayerData = PlayerData.new()
	player.skills["charisma"] = {"level": 25, "xp": 0.0}
	player.skills["performance"] = {"level": 20, "xp": 0.0}
	var skill_sys: SkillSystem = SkillSystem.new(player)
	var concert_sys: ConcertSystem = ConcertSystem.new(player, null, skill_sys)
	
	# Verifica generazione di eventi
	var event_types_found: Dictionary = {}
	for i in range(100):
		var ev: Dictionary = concert_sys.generate_stage_event(false)
		event_types_found[ev["type"]] = true
		
	assert_true(event_types_found.size() >= 3, "Generazione diversificata degli eventi di palco")
	
	# Test specifico per BLACKOUT
	var ev_blackout: Dictionary = {
		"type": Enums.StageEventType.BLACKOUT,
		"title": "Blackout sul Palco",
		"choice_1_skill": "charisma",
		"choice_2_skill": "performance"
	}
	var res_bo: Dictionary = concert_sys.resolve_stage_event_choice(ev_blackout, 1)
	assert_eq(res_bo["skill_tested"], "charisma", "Scelta 1 Blackout testa Carisma")
	assert_true(res_bo["score_delta"] != 0.0, "Delta score valorizzato")
	
	# Test specifico per CROWD_CHANT
	var ev_chant: Dictionary = {
		"type": Enums.StageEventType.CROWD_CHANT,
		"title": "Cori della Folla",
		"choice_1_skill": "charisma",
		"choice_2_skill": "performance"
	}
	var res_ch: Dictionary = concert_sys.resolve_stage_event_choice(ev_chant, 2)
	assert_eq(res_ch["skill_tested"], "performance", "Scelta 2 Cori testa Performance")

# 8. Test Banchetto Merchandising
func test_merchandise_sales_and_economics() -> void:
	print("\n8. Verifica Banchetto Merchandising al Foyer:")
	var player: PlayerData = PlayerData.new()
	var concert_sys: ConcertSystem = ConcertSystem.new(player)
	var venues: Array[VenueData] = VenueData.get_default_venues()
	var club: VenueData = venues[3]
	
	var merch: Dictionary = concert_sys.calculate_merch_sales(club, 100, 80.0, 15.0)
	assert_true(merch["items_sold"] > 0, "Articoli venduti al banchetto con 100 spettatori")
	assert_true(merch["gross_revenue"] > 0.0, "Incasso lordo merch positivo")
	assert_true(merch["production_costs"] > 0.0, "Costi di produzione calcolati")
	assert_true(merch["net_revenue"] > 0.0, "Guadagno netto merch positivo")
	assert_true(merch["pins_sold"] >= 0, "Spille vendute tracciate")
	assert_true(merch["tshirts_sold"] >= 0, "Magliette vendute tracciate")

# 9. Test Momento Bis / Encore
func test_encore_mechanics() -> void:
	print("\n9. Verifica Momento Bis / Encore (Score >= 85):")
	var player: PlayerData = PlayerData.new()
	player.energy = 50
	player.money = 100.0
	var concert_sys: ConcertSystem = ConcertSystem.new(player)
	
	# Concessione del bis con energia sufficiente
	var res_enc: Dictionary = concert_sys.resolve_encore(true, 90.0)
	assert_true(res_enc["granted"], "Bis concesso con successo")
	assert_eq(player.energy, 40, "Bis consuma 10 punti energia (50 - 10 = 40)")
	assert_eq(player.money, 150.0, "Mance del bis accreditate (+50 €)")
	assert_eq(res_enc["fan_bonus_mult"], Constants.ENCORE_FAN_BONUS_MULT, "Moltiplicatore fan x1.10 assegnato")
	
	# Tentativo di bis con energia insufficiente
	player.energy = 5
	var res_fail: Dictionary = concert_sys.resolve_encore(true, 90.0)
	assert_eq(res_fail["granted"], false, "Bis rifiutato per energia insufficiente")
	assert_true(res_fail["energy_insufficient"], "Flag energy_insufficient valorizzato")
	
	# Rifiuto volontario del bis
	var res_decl: Dictionary = concert_sys.resolve_encore(false, 90.0)
	assert_eq(res_decl["granted"], false, "Bis rifiutato volontariamente senza penalità")

# 10. Test Risoluzione Concerto ed Economia Completa
func test_concert_resolution_and_economics() -> void:
	print("\n10. Verifica Risoluzione Concerto ed Economia Completa:")
	var player: PlayerData = PlayerData.new()
	player.money = 100.0
	player.energy = 50
	player.fans = 20
	player.popularity = 25.0
	
	var cal: CalendarData = CalendarData.new()
	cal.day_number = 1
	var concert_sys: ConcertSystem = ConcertSystem.new(player, cal)
	var venues: Array[VenueData] = VenueData.get_default_venues()
	var pub: VenueData = venues[1]
	concert_sys.set_venue_status_override(pub.id, 1, Enums.VenueBookingStatus.FREE)
	
	var song1: SongData = SongData.new("s1", "Banger 1", Enums.MusicalGenre.ROCK)
	song1.status = Enums.SongStatus.RELEASED
	song1.quality_score = 80.0
	var setlist: Array[SongData] = [song1]
	
	var initial_money: float = player.money
	var result: Dictionary = concert_sys.resolve_concert(pub, setlist, 5.0, false, 0.0)
	assert_true(result["success"], "Concerto risolto con successo")
	assert_true(result["audience"] > 0, "Pubblico presente")
	assert_true(result.has("merch_data"), "Dati merchandise inclusi nel risultato")
	assert_true(player.money > initial_money, "Saldo giocatore incrementato da biglietti e merch")
	assert_true(result.has("eligible_for_encore"), "Idoneità encore calcolata nel risultato")

# 11. Test Istanziazione UI LiveConcert e Nodi AccessKit
func test_live_concert_ui_scene_instantiation() -> void:
	print("\n11. Verifica Istanziazione Scena UI LiveConcert ed Accessibilità:")
	var concert_scene = load("res://ui/concert/live_concert.tscn")
	assert_true(concert_scene != null, "Scena live_concert.tscn caricata")
	
	var instance: Node = concert_scene.instantiate()
	assert_true(instance != null, "Istanza live_concert creata")
	
	# Verifica nodi originali
	var chk_soundcheck: CheckBox = instance.get_node_or_null("PanelMain/VBox/PrepContainer/ChkSoundcheck")
	var btn_start_concert: Button = instance.get_node_or_null("PanelMain/VBox/PrepContainer/HBoxPrepButtons/BtnStartConcert")
	var btn_add_cover: Button = instance.get_node_or_null("PanelMain/VBox/PrepContainer/HBoxPrepButtons/BtnAddCover")
	var btn_cancel_prep: Button = instance.get_node_or_null("PanelMain/VBox/PrepContainer/HBoxPrepButtons/BtnCancelPrep")
	var btn_choice_1: Button = instance.get_node_or_null("PanelMain/VBox/ShowContainer/PanelEvent/VBoxEvent/HBoxChoices/BtnChoice1")
	var btn_choice_2: Button = instance.get_node_or_null("PanelMain/VBox/ShowContainer/PanelEvent/VBoxEvent/HBoxChoices/BtnChoice2")
	var btn_next_phase: Button = instance.get_node_or_null("PanelMain/VBox/ShowContainer/HBoxShowButtons/BtnNextPhase")
	
	# Verifica nodi Sezione 5 (Encore & Merch)
	var encore_container: VBoxContainer = instance.get_node_or_null("PanelMain/VBox/EncoreContainer")
	var btn_grant_encore: Button = instance.get_node_or_null("PanelMain/VBox/EncoreContainer/HBoxEncoreChoices/BtnGrantEncore")
	var btn_decline_encore: Button = instance.get_node_or_null("PanelMain/VBox/EncoreContainer/HBoxEncoreChoices/BtnDeclineEncore")
	var label_merch: Label = instance.get_node_or_null("PanelMain/VBox/SummaryContainer/LabelMerch")
	var btn_finish_concert: Button = instance.get_node_or_null("PanelMain/VBox/SummaryContainer/HBoxSummaryButtons/BtnFinishConcert")
	
	assert_true(chk_soundcheck != null, "ChkSoundcheck presente")
	assert_true(btn_start_concert != null, "BtnStartConcert presente")
	assert_true(btn_add_cover != null, "BtnAddCover presente")
	assert_true(btn_cancel_prep != null, "BtnCancelPrep presente")
	assert_true(btn_choice_1 != null, "BtnChoice1 presente")
	assert_true(btn_choice_2 != null, "BtnChoice2 presente")
	assert_true(btn_next_phase != null, "BtnNextPhase presente")
	assert_true(encore_container != null, "EncoreContainer presente")
	assert_true(btn_grant_encore != null, "BtnGrantEncore presente")
	assert_true(btn_decline_encore != null, "BtnDeclineEncore presente")
	assert_true(label_merch != null, "LabelMerch presente")
	assert_true(btn_finish_concert != null, "BtnFinishConcert presente")
	
	instance.queue_free()
