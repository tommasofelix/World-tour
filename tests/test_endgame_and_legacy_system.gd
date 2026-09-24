# res://tests/test_endgame_and_legacy_system.gd
extends Node

## Suite di Test Headless per Sezione 11: Endgame, Grandi Stadi & Legacy Mondiale
## Valida:
## 1. Modelli dati ed enumerazioni (CertificationTier, StageProductionTier, MusicAwardCategory, LegacyEndingType)
## 2. Grandi Arene & Mega Stadi Mondiali in VenueData (Palasport 15k e Stadio 65k)
## 3. Mega-Produzioni Sceniche e Service Tour in ConcertSystem
## 4. Sottosistema Certificazioni Ufficiali (Oro, Platino, Diamante) e idempotenza
## 5. Cerimonia annuale World Music Awards in AwardSystem
## 6. Verifica requisiti e solenne induzione nella Rock and Roll Hall of Fame
## 7. Concerto d'Addio The Last Waltz ed Epilogo Narrativo Multiplo (4 finali)
## 8. Persistenza atomica savegame e deserializzazione

const PlayerDataScript = preload("res://data/models/player_data.gd")
const CalendarDataScript = preload("res://data/models/calendar_data.gd")
const SongDataScript = preload("res://data/models/song_data.gd")
const AlbumDataScript = preload("res://data/models/album_data.gd")
const VenueDataScript = preload("res://data/models/venue_data.gd")
const ConcertSystemScript = preload("res://systems/concert_system.gd")
const AwardSystemScript = preload("res://systems/award_system.gd")
const LegacySystemScript = preload("res://systems/legacy_system.gd")

var tests_passed: int = 0
var tests_failed: int = 0

func _ready() -> void:
	print("\n========================================================")
	print("   SUITE TEST SEZIONE 11: GRANDI STADI & LEGACY MONDIALE ")
	print("========================================================")
	
	test_enums_and_constants()
	test_arena_and_stadium_venues()
	test_stage_production_setup_and_costs()
	test_concert_resolution_with_stadium_and_stage_production()
	test_certifications_awarding_and_idempotency()
	test_annual_music_awards_evaluation()
	test_hall_of_fame_eligibility_and_induction()
	test_the_last_waltz_and_legacy_endings()
	test_serialization_and_save_load()
	
	print("\n--------------------------------------------------------")
	print("ESITO TEST SEZIONE 11 (GRANDI STADI & LEGACY):")
	print("  Test Superati: %d" % tests_passed)
	print("  Test Falliti:  %d" % tests_failed)
	print("--------------------------------------------------------\n")
	
	if tests_failed == 0:
		print("[SUCCESSO] Sezione 11 convalidata al 100%!")
		get_tree().quit(0)
	else:
		printerr("[ERRORE CRITICO] Alcuni test della Sezione 11 sono falliti!")
		get_tree().quit(1)

func assert_true(cond: bool, msg: String) -> void:
	if cond:
		tests_passed += 1
		print("  [OK] %s" % msg)
	else:
		tests_failed += 1
		printerr("  [FAIL] %s" % msg)

func assert_false(cond: bool, msg: String) -> void:
	assert_true(not cond, msg)

func assert_equal(val, expected, msg: String) -> void:
	if val == expected:
		tests_passed += 1
		print("  [OK] %s" % msg)
	else:
		tests_failed += 1
		printerr("  [FAIL] %s (Atteso: %s, Ottenuto: %s)" % [msg, str(expected), str(val)])

# ------------------------------------------------------------------------------
# 1. Tipi ed Enumerazioni
# ------------------------------------------------------------------------------
func test_enums_and_constants() -> void:
	print("\n--- Test 1: Tipi ed Enumerazioni Endgame ---")
	assert_equal(Enums.CertificationTier.GOLD, 1, "Enums.CertificationTier.GOLD == 1")
	assert_equal(Enums.CertificationTier.PLATINUM, 2, "Enums.CertificationTier.PLATINUM == 2")
	assert_equal(Enums.CertificationTier.MULTI_PLATINUM, 3, "Enums.CertificationTier.MULTI_PLATINUM == 3")
	assert_equal(Enums.CertificationTier.DIAMOND, 4, "Enums.CertificationTier.DIAMOND == 4")
	assert_equal(Enums.get_certification_name(Enums.CertificationTier.GOLD), "Disco d'Oro", "Nome Disco d'Oro corretto")
	assert_equal(Enums.get_certification_name(Enums.CertificationTier.DIAMOND), "Disco di Diamante", "Nome Disco di Diamante corretto")
	
	assert_equal(Enums.StageProductionTier.RUNWAY_CATWALK, 1, "StageProductionTier.RUNWAY_CATWALK == 1")
	assert_equal(Enums.StageProductionTier.CENTER_360_STAGE, 2, "StageProductionTier.CENTER_360_STAGE == 2")
	assert_equal(Enums.StageProductionTier.MEGA_PYRO_LASER, 3, "StageProductionTier.MEGA_PYRO_LASER == 3")
	assert_true(Enums.get_stage_production_name(Enums.StageProductionTier.MEGA_PYRO_LASER).contains("Pirotecnica"), "Nome Mega Pyro corretto")
	
	assert_equal(Enums.MusicAwardCategory.SONG_OF_THE_YEAR, 0, "MusicAwardCategory.SONG_OF_THE_YEAR == 0")
	assert_equal(Enums.MusicAwardCategory.ALBUM_OF_THE_YEAR, 1, "MusicAwardCategory.ALBUM_OF_THE_YEAR == 1")
	assert_equal(Enums.MusicAwardCategory.BEST_LIVE_BAND, 2, "MusicAwardCategory.BEST_LIVE_BAND == 2")
	assert_equal(Enums.MusicAwardCategory.BEST_PRODUCER, 3, "MusicAwardCategory.BEST_PRODUCER == 3")
	
	assert_equal(Enums.LegacyEndingType.IMMORTAL_ICON, 0, "LegacyEndingType.IMMORTAL_ICON == 0")
	assert_equal(Enums.LegacyEndingType.ROCK_MARTYR, 1, "LegacyEndingType.ROCK_MARTYR == 1")
	assert_equal(Enums.LegacyEndingType.MONEY_MACHINE, 2, "LegacyEndingType.MONEY_MACHINE == 2")
	assert_equal(Enums.LegacyEndingType.BLAZING_COMET, 3, "LegacyEndingType.BLAZING_COMET == 3")
	assert_equal(Enums.get_legacy_ending_name(Enums.LegacyEndingType.IMMORTAL_ICON), "L'Icona Immortale", "Nome Icona Immortale corretto")
	
	assert_equal(Constants.CERT_GOLD_SALES, 25000.0, "Soglia vendite Disco d'Oro == 25.000")
	assert_equal(Constants.CERT_GOLD_STREAMS, 10000000, "Soglia streaming Disco d'Oro == 10M")
	assert_equal(Constants.CERT_PLATINUM_SALES, 50000.0, "Soglia vendite Platino == 50.000")
	assert_equal(Constants.CERT_PLATINUM_STREAMS, 25000000, "Soglia streaming Platino == 25M")
	assert_equal(Constants.CERT_DIAMOND_SALES, 500000.0, "Soglia vendite Diamante == 500.000")
	assert_equal(Constants.CERT_DIAMOND_STREAMS, 100000000, "Soglia streaming Diamante == 100M")

# ------------------------------------------------------------------------------
# 2. Grandi Arene e Mega Stadi
# ------------------------------------------------------------------------------
func test_arena_and_stadium_venues() -> void:
	print("\n--- Test 2: Grandi Arene & Mega Stadi in VenueData ---")
	var venues: Array[VenueData] = VenueDataScript.get_default_venues()
	var arena: VenueData = null
	var stadium: VenueData = null
	
	for v in venues:
		if v.id == "venue_arena_national":
			arena = v
		elif v.id == "venue_mega_stadium":
			stadium = v
			
	assert_true(arena != null, "Venue 'venue_arena_national' presente nel catalogo")
	assert_true(stadium != null, "Venue 'venue_mega_stadium' presente nel catalogo")
	
	if arena:
		assert_equal(arena.venue_type, VenueDataScript.TYPE_ARENA, "Tipo arena corretto (TYPE_ARENA)")
		assert_equal(arena.capacity, 15000, "Capienza arena == 15.000 spettatori")
		assert_equal(arena.rent_cost, 35000.0, "Affitto arena == 35.000 €")
		assert_equal(arena.min_popularity, 70.0, "Popolarità minima arena == 70.0%")
		assert_equal(arena.min_reputation, 55.0, "Reputazione minima arena == 55.0")
		assert_equal(arena.fair_ticket_price, 45.0, "Fair ticket price arena == 45.0 €")
		
	if stadium:
		assert_equal(stadium.venue_type, VenueDataScript.TYPE_STADIUM, "Tipo stadio corretto (TYPE_STADIUM)")
		assert_equal(stadium.capacity, 65000, "Capienza stadio == 65.000 spettatori")
		assert_equal(stadium.rent_cost, 120000.0, "Affitto mega stadio == 120.000 €")
		assert_equal(stadium.min_popularity, 85.0, "Popolarità minima stadio == 85.0%")
		assert_equal(stadium.min_reputation, 75.0, "Reputazione minima stadio == 75.0")
		assert_equal(stadium.fair_ticket_price, 70.0, "Fair ticket price stadio == 70.0 €")

# ------------------------------------------------------------------------------
# 3. Setup Allestimenti Scenici & Service Tour
# ------------------------------------------------------------------------------
func test_stage_production_setup_and_costs() -> void:
	print("\n--- Test 3: Allestimenti Scenici & Service Tour ---")
	var player: PlayerData = PlayerDataScript.new()
	var cal: CalendarData = CalendarDataScript.new()
	var concert_sys: ConcertSystem = ConcertSystemScript.new(player, cal)
	
	player.money = 1000.0
	var fail_res: Dictionary = concert_sys.select_stage_production(Enums.StageProductionTier.MEGA_PYRO_LASER)
	assert_false(fail_res.get("success", true), "Rifiuto selezione allestimento pirotecnico se fondi insufficienti")
	assert_equal(fail_res.get("reason", ""), "money_insufficient", "Causa rifiuto: money_insufficient")
	
	player.money = 100000.0
	var succ_runway: Dictionary = concert_sys.select_stage_production(Enums.StageProductionTier.RUNWAY_CATWALK)
	assert_true(succ_runway.get("success", false), "Selezione passerella a T approvata con fondi adeguati")
	assert_equal(concert_sys.active_stage_production, Enums.StageProductionTier.RUNWAY_CATWALK, "active_stage_production impostato a RUNWAY_CATWALK")
	
	var succ_pyro: Dictionary = concert_sys.select_stage_production(Enums.StageProductionTier.MEGA_PYRO_LASER)
	assert_true(succ_pyro.get("success", false), "Selezione mega pirotecnica laser approvata")
	assert_equal(concert_sys.active_stage_production, Enums.StageProductionTier.MEGA_PYRO_LASER, "active_stage_production impostato a MEGA_PYRO_LASER")

# ------------------------------------------------------------------------------
# 4. Risoluzione Concerto nello Stadio con Mega Allestimento
# ------------------------------------------------------------------------------
func test_concert_resolution_with_stadium_and_stage_production() -> void:
	print("\n--- Test 4: Risoluzione Concerto nello Stadio con Mega-Produzione ---")
	var player: PlayerData = PlayerDataScript.new()
	var cal: CalendarData = CalendarDataScript.new()
	var concert_sys: ConcertSystem = ConcertSystemScript.new(player, cal)
	
	player.money = 300000.0
	player.popularity = 95.0
	player.reputation = 90.0
	player.fans = 120000
	
	var stadium: VenueData = null
	for v in VenueDataScript.get_default_venues():
		if v.id == "venue_mega_stadium":
			stadium = v
			break
	var s1: SongData = SongDataScript.new("s1", "Starlight Stadium Anthem")
	s1.status = Enums.SongStatus.RELEASED
	s1.quality_score = 92.0
	var setlist: Array[SongData] = [s1]
	
	# Allestimento con Palco Centrale 360°
	concert_sys.set_venue_status_override(stadium.id, cal.day_number, Enums.VenueBookingStatus.FREE)
	concert_sys.select_stage_production(Enums.StageProductionTier.CENTER_360_STAGE)
	var initial_money: float = player.money
	
	var res: Dictionary = concert_sys.resolve_concert(stadium, setlist, 70.0, true, 0.0)
	assert_true(res.get("success", false), "Concerto nello stadio eseguito con successo")
	assert_true(res.get("audience", 0) > 40000, "Affluenza oceanica nello stadio (> 40.000 spettatori)")
	assert_true(player.money > initial_money, "Incasso netto positivo nonostante i costi di allestimento e affitto")

# ------------------------------------------------------------------------------
# 5. Certificazioni Ufficiali (Oro, Platino, Diamante) & Idempotenza
# ------------------------------------------------------------------------------
func test_certifications_awarding_and_idempotency() -> void:
	print("\n--- Test 5: Certificazioni Ufficiali & Idempotenza ---")
	var player: PlayerData = PlayerDataScript.new()
	var cal: CalendarData = CalendarDataScript.new()
	var award_sys = AwardSystemScript.new(player, cal)
	
	var hit_single: SongData = SongDataScript.new("single_hit", "Global Summer Hit")
	hit_single.status = Enums.SongStatus.RELEASED
	hit_single.plays = 30000000 # 30M streaming -> Idoneo per ORO e PLATINO
	player.songs.append(hit_single)
	
	var smash_album: AlbumData = AlbumDataScript.new("alb_masterpiece", "The Masterpiece", Enums.AlbumType.LP)
	smash_album.is_released = true
	smash_album.total_sales = 600000.0 # 600k vendite -> Idoneo fino a DIAMANTE
	player.albums.append(smash_album)
	
	var awarded_first: Array[Dictionary] = award_sys.check_and_award_certifications()
	assert_true(awarded_first.size() >= 4, "Assegnate almeno 4 certificazioni (Oro e Platino per singolo, Oro, Platino, Multi e Diamante per album)")
	
	assert_true(player.get_certifications_count(Enums.CertificationTier.GOLD) >= 2, "Conta almeno 2 Dischi d'Oro")
	assert_true(player.get_certifications_count(Enums.CertificationTier.PLATINUM) >= 2, "Conta almeno 2 Dischi di Platino")
	assert_true(player.get_certifications_count(Enums.CertificationTier.DIAMOND) >= 1, "Conta almeno 1 Disco di Diamante")
	
	# Verifica idempotenza: seconda scansione non deve duplicare
	var awarded_second: Array[Dictionary] = award_sys.check_and_award_certifications()
	assert_equal(awarded_second.size(), 0, "Idempotenza verificata: zero duplicazioni al secondo controllo")

# ------------------------------------------------------------------------------
# 6. World Music Awards
# ------------------------------------------------------------------------------
func test_annual_music_awards_evaluation() -> void:
	print("\n--- Test 6: World Music Awards ---")
	var player: PlayerData = PlayerDataScript.new()
	var cal: CalendarData = CalendarDataScript.new()
	var award_sys = AwardSystemScript.new(player, cal)
	
	player.player_name = "Alex"
	player.band_name = "The Soundwaves"
	player.popularity = 85.0
	player.reputation = 88.0
	player.skills["production"]["level"] = 80
	
	var top_song: SongData = SongDataScript.new("s_award", "Symphony of the Night")
	top_song.status = Enums.SongStatus.RELEASED
	top_song.quality_score = 90.0
	top_song.plays = 2000000
	player.songs.append(top_song)
	
	var top_album: AlbumData = AlbumDataScript.new("alb_award", "Golden Hour", Enums.AlbumType.LP)
	top_album.is_released = true
	top_album.overall_quality = 92.0
	top_album.total_sales = 50000.0
	player.albums.append(top_album)
	
	var ceremony: Dictionary = award_sys.evaluate_annual_music_awards(2026)
	assert_equal(ceremony.get("year", 0), 2026, "Anno cerimonia corretto (2026)")
	
	var awards: Array = ceremony.get("awards", [])
	assert_equal(awards.size(), 4, "Cerimonia valuta esattamente 4 categorie di premi")
	
	assert_true(player.has_won_award(Enums.MusicAwardCategory.SONG_OF_THE_YEAR), "Vinto premio Canzone dell'Anno")
	assert_true(player.has_won_award(Enums.MusicAwardCategory.ALBUM_OF_THE_YEAR), "Vinto premio Album dell'Anno")
	assert_true(player.has_won_award(Enums.MusicAwardCategory.BEST_LIVE_BAND), "Vinto premio Miglior Band Live")
	assert_true(player.has_won_award(Enums.MusicAwardCategory.BEST_PRODUCER), "Vinto premio Miglior Produttore")
	assert_equal(player.music_awards.size(), 4, "Player colleziona 4 statuette nei trofei personali")

# ------------------------------------------------------------------------------
# 7. Hall of Fame Eligibility & Induzione
# ------------------------------------------------------------------------------
func test_hall_of_fame_eligibility_and_induction() -> void:
	print("\n--- Test 7: Hall of Fame Eligibility & Induzione ---")
	var player: PlayerData = PlayerDataScript.new()
	var cal: CalendarData = CalendarDataScript.new()
	var legacy_sys = LegacySystemScript.new(player, cal)
	
	# Caso 1: Musicista principiante
	var check_fail: Dictionary = legacy_sys.check_hall_of_fame_eligibility()
	assert_false(check_fail.get("eligible", true), "Principiante non idoneo alla Hall of Fame")
	assert_true(check_fail.get("missing_requirements", []).size() >= 3, "Elenco chiaro dei requisiti mancanti per NVDA")
	
	# Caso 2: Requisiti completati
	player.career_tier = Enums.CareerTier.GLOBAL_SUPERSTAR
	player.reputation = 85.0
	player.fans = 100000
	player.add_certification("item_1", "Leggenda", "album", Enums.CertificationTier.PLATINUM, 100)
	
	var check_ok: Dictionary = legacy_sys.check_hall_of_fame_eligibility()
	assert_true(check_ok.get("eligible", false), "Superstar con platino è idonea alla Hall of Fame")
	
	var induct_res: Dictionary = legacy_sys.induct_into_hall_of_fame()
	assert_true(induct_res.get("success", false), "Induzione celebrata con successo")
	assert_true(player.hall_of_fame_inducted, "Flag hall_of_fame_inducted == true")
	assert_true(player.reputation >= 90.0, "Incremento solenne di reputazione post-induzione")
	
	# Verifica idempotenza
	var repeat_induct: Dictionary = legacy_sys.induct_into_hall_of_fame()
	assert_true(repeat_induct.get("already_inducted", false), "Seconda chiamata rileva induzione già avvenuta")

# ------------------------------------------------------------------------------
# 8. The Last Waltz ed Epiloghi Narrativi di Carriera
# ------------------------------------------------------------------------------
func test_the_last_waltz_and_legacy_endings() -> void:
	print("\n--- Test 8: The Last Waltz & 4 Epiloghi Narrativi ---")
	var player: PlayerData = PlayerDataScript.new()
	var cal: CalendarData = CalendarDataScript.new()
	var legacy_sys = LegacySystemScript.new(player, cal)
	
	var s_legend: SongData = SongDataScript.new("s_leg", "Final Farewell", Enums.MusicalGenre.ROCK)
	s_legend.quality_score = 95.0
	s_legend.status = Enums.SongStatus.RELEASED
	player.songs.append(s_legend)
	
	# Test Epilogo 1: Martire del Rock
	player.reputation = 85.0
	player.money = 5000.0
	player.active_contract = null
	var end_martyr: Dictionary = legacy_sys.evaluate_legacy_ending()
	assert_equal(end_martyr.get("ending_type", -1), Enums.LegacyEndingType.ROCK_MARTYR, "Calcolato epilogo: Il Martire del Rock")
	
	# Test Epilogo 2: Macchina da Soldi
	player.money = 250000.0
	player.popularity = 90.0
	var end_money: Dictionary = legacy_sys.evaluate_legacy_ending()
	assert_equal(end_money.get("ending_type", -1), Enums.LegacyEndingType.MONEY_MACHINE, "Calcolato epilogo: La Macchina da Soldi")
	
	# Test Epilogo 3: Cometa Fiammeggiante (pochi singoli, 1 platino, soldi moderati)
	player.money = 40000.0
	player.popularity = 70.0
	player.certifications.clear()
	player.add_certification("s_leg", "Final Farewell", "single", Enums.CertificationTier.PLATINUM, 50)
	var end_comet: Dictionary = legacy_sys.evaluate_legacy_ending()
	assert_equal(end_comet.get("ending_type", -1), Enums.LegacyEndingType.BLAZING_COMET, "Calcolato epilogo: La Cometa Fiammeggiante")
	
	# Test Epilogo 4: Icona Immortale
	for i in range(10):
		var extra_s: SongData = SongDataScript.new("extra_%d" % i, "Track %d" % i)
		extra_s.status = Enums.SongStatus.RELEASED
		player.songs.append(extra_s)
	player.money = 60000.0
	player.popularity = 75.0
	player.reputation = 95.0
	var end_icon: Dictionary = legacy_sys.evaluate_legacy_ending()
	assert_equal(end_icon.get("ending_type", -1), Enums.LegacyEndingType.IMMORTAL_ICON, "Calcolato epilogo: L'Icona Immortale")
	
	# Test Esecuzione The Last Waltz
	var waltz_res: Dictionary = legacy_sys.perform_last_waltz([s_legend])
	assert_true(waltz_res.get("success", false), "The Last Waltz completato con successo")
	assert_true(player.last_waltz_completed, "Flag last_waltz_completed == true")
	assert_true(waltz_res.get("charity_funds_raised", 0.0) >= 0.0, "Fondi di beneficenza calcolati")
	assert_equal(waltz_res.get("ending_type", -1), Enums.LegacyEndingType.IMMORTAL_ICON, "Epilogo finale convalidato")

# ------------------------------------------------------------------------------
# 9. Persistenza e Deserializzazione
# ------------------------------------------------------------------------------
func test_serialization_and_save_load() -> void:
	print("\n--- Test 9: Serializzazione e Deserializzazione ---")
	var player: PlayerData = PlayerDataScript.new()
	player.player_name = "Alex"
	player.hall_of_fame_inducted = true
	player.last_waltz_completed = true
	player.legacy_ending = Enums.LegacyEndingType.IMMORTAL_ICON
	player.add_certification("song_1", "Hit Track", "single", Enums.CertificationTier.GOLD, 42)
	player.add_music_award({"category": Enums.MusicAwardCategory.SONG_OF_THE_YEAR, "title": "Hit Track"})
	
	var p_dict: Dictionary = player.to_dict()
	assert_true(p_dict.has("hall_of_fame_inducted"), "Dizionario contiene hall_of_fame_inducted")
	assert_true(p_dict.has("last_waltz_completed"), "Dizionario contiene last_waltz_completed")
	assert_true(p_dict.has("legacy_ending"), "Dizionario contiene legacy_ending")
	assert_true(p_dict.has("certifications"), "Dizionario contiene certifications")
	assert_true(p_dict.has("music_awards"), "Dizionario contiene music_awards")
	
	var loaded_player: PlayerData = PlayerDataScript.new()
	loaded_player.from_dict(p_dict)
	
	assert_true(loaded_player.hall_of_fame_inducted, "hall_of_fame_inducted ripristinato correttamente")
	assert_true(loaded_player.last_waltz_completed, "last_waltz_completed ripristinato correttamente")
	assert_equal(loaded_player.legacy_ending, Enums.LegacyEndingType.IMMORTAL_ICON, "legacy_ending ripristinato")
	assert_equal(loaded_player.certifications.size(), 1, "certifications ripristinate (1 elemento)")
	assert_equal(loaded_player.music_awards.size(), 1, "music_awards ripristinati (1 elemento)")
	
	var cal: CalendarData = CalendarDataScript.new()
	var concert_sys: ConcertSystem = ConcertSystemScript.new(player, cal)
	concert_sys.active_stage_production = Enums.StageProductionTier.MEGA_PYRO_LASER
	var c_dict: Dictionary = concert_sys.to_dict()
	assert_equal(int(c_dict.get("active_stage_production", 0)), Enums.StageProductionTier.MEGA_PYRO_LASER, "active_stage_production serializzato")
	
	var new_concert_sys: ConcertSystem = ConcertSystemScript.new(player, cal)
	new_concert_sys.from_dict(c_dict)
	assert_equal(new_concert_sys.active_stage_production, Enums.StageProductionTier.MEGA_PYRO_LASER, "active_stage_production deserializzato")
