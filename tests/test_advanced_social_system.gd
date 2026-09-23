# res://tests/test_advanced_social_system.gd
extends Node

## Suite di Test Headless per Social Media Avanzati, Fan Engagement & Fan Club (Sezione 8)
## Valida le nuove funzionalità introdotte dalla Sezione 8:
## 1. Tendenze settimanali algoritmiche fluttuanti (Weekly Trends)
## 2. Campagne promozionali sponsorizzate a budget (Boost Post 100 €, 250 €, 500 €)
## 3. Dirette live streaming interattive con i fan (Live Stream)
## 4. Bivio condizionale della controversia delegata al Manager (Manager Crisis Delegation)
## 5. Fondazione del Fan Club Ufficiale della Band con elezione del Presidente
## 6. Raduno annuale dei fan e impatto prevendite garantite sui concerti
## 7. Eventi posta/regali fan ossessivi al check notturno
## 8. Persistenza atomica FanClubData e ripristino da SaveManager

const SocialPostDataScript = preload("res://data/models/social_post_data.gd")
const SocialMediaSystemScript = preload("res://systems/social_media_system.gd")
const PlayerDataScript = preload("res://data/models/player_data.gd")
const CalendarDataScript = preload("res://data/models/calendar_data.gd")
const ManagerDataScript = preload("res://data/models/manager_data.gd")
const BandMemberDataScript = preload("res://data/models/band_member_data.gd")
const ConcertSystemScript = preload("res://systems/concert_system.gd")
const VenueDataScript = preload("res://data/models/venue_data.gd")

var tests_passed: int = 0
var tests_failed: int = 0

func _ready() -> void:
	print("\n========================================================")
	print("   SUITE TEST SOCIAL MEDIA AVANZATI & FAN CLUB (SEZ. 8) ")
	print("========================================================")
	
	test_weekly_algorithm_trends()
	test_post_sponsorship_campaigns()
	test_live_streaming_session()
	test_manager_crisis_delegation()
	test_fan_club_foundation_and_membership()
	test_fan_club_annual_meeting()
	test_concert_attendance_boost_with_fan_club()
	test_fan_mail_event_and_night_decay()
	test_fan_club_persistence_and_fandom_summary()
	
	print("\n--------------------------------------------------------")
	print("ESITO COMPLESSIVO TEST SOCIAL MEDIA AVANZATI (SEZ. 8):")
	print("  Test Superati: %d" % tests_passed)
	print("  Test Falliti:  %d" % tests_failed)
	print("--------------------------------------------------------\n")
	
	if tests_failed == 0:
		print("[SUCCESSO] Social Media Avanzati & Fan Club (Sezione 8) convalidati al 100%!")
		get_tree().quit(0)
	else:
		printerr("[ERRORE CRITICO] Alcuni test sui Social Media Avanzati sono falliti!")
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
# TEST 1: Tendenze Settimanali Algoritmiche
# -------------------------------------------------------------
func test_weekly_algorithm_trends() -> void:
	print("\n[TEST 1] Tendenze Settimanali Algoritmiche...")
	var player := PlayerDataScript.new()
	var cal := CalendarDataScript.new()
	var sys := SocialMediaSystemScript.new(player, cal)
	
	cal.day_number = 1 # Settimana 1 (Giorno 1-7) -> Trend 0 (Clip prove)
	var trend_w1: int = sys.get_weekly_trend_post_type()
	assert_equal(trend_w1, Enums.SocialPostType.PRACTICE_CLIP, "Settimana 1: Clip prove in trend")
	
	cal.day_number = 8 # Settimana 2 (Giorno 8-14) -> Trend 1 (Teaser)
	var trend_w2: int = sys.get_weekly_trend_post_type()
	assert_equal(trend_w2, Enums.SocialPostType.TRACK_TEASER, "Settimana 2: Teaser in trend")
	
	cal.day_number = 15 # Settimana 3 -> Trend 2 (Backstage)
	var trend_w3: int = sys.get_weekly_trend_post_type()
	assert_equal(trend_w3, Enums.SocialPostType.BEHIND_THE_SCENES, "Settimana 3: Backstage in trend")
	
	cal.day_number = 22 # Settimana 4 -> Trend 3 (Provocazione)
	var trend_w4: int = sys.get_weekly_trend_post_type()
	assert_equal(trend_w4, Enums.SocialPostType.PROVOCATION, "Settimana 4: Provocazione in trend")
	
	var desc: String = sys.get_weekly_trend_description()
	assert_true(desc.contains("l'algoritmo premia"), "Descrizione trend generata per screen reader NVDA")

# -------------------------------------------------------------
# TEST 2: Campagne Promozionali Sponsorizzate a Budget
# -------------------------------------------------------------
func test_post_sponsorship_campaigns() -> void:
	print("\n[TEST 2] Campagne Promozionali Sponsorizzate a Budget...")
	var player := PlayerDataScript.new()
	player.money = 300.0
	var cal := CalendarDataScript.new()
	var sys := SocialMediaSystemScript.new(player, cal)
	
	# Pubblica un post organico iniziale
	var pub_res := sys.publish_post(Enums.SocialPostType.PRACTICE_CLIP)
	assert_true(pub_res.get("success", false), "Post organico pubblicato per sponsorizzazione")
	
	var p: SocialPostData = pub_res.get("post")
	var initial_views: int = p.views
	var initial_money: float = player.money
	
	# Sponsorizza con 100 €
	var sp_res := sys.sponsor_post(p.id, 100)
	assert_true(sp_res.get("success", false), "Sponsorizzazione 100 € avvenuta con successo")
	assert_equal(player.money, initial_money - 100.0, "Denaro scalato di 100 €")
	assert_true(p.views > initial_views, "Visualizzazioni incrementate dalla campagna")
	assert_true(p.is_sponsored, "Flag is_sponsored impostato a true")
	assert_equal(p.sponsor_budget, 100, "Budget registrato a 100 €")
	
	# Tentativo di ri-sponsorizzare lo stesso post -> Bloccato
	var sp_dup := sys.sponsor_post(p.id, 100)
	assert_true(not sp_dup.get("success", false), "Rifiutata sponsorizzazione duplicata dello stesso post")
	assert_equal(sp_dup.get("reason", ""), "already_sponsored", "Motivo rifiuto: already_sponsored")

# -------------------------------------------------------------
# TEST 3: Dirette Live Streaming Interattive
# -------------------------------------------------------------
func test_live_streaming_session() -> void:
	print("\n[TEST 3] Dirette Live Streaming Interattive...")
	var player := PlayerDataScript.new()
	player.energy = 50
	var cal := CalendarDataScript.new()
	var sys := SocialMediaSystemScript.new(player, cal)
	
	var stream_res := sys.start_live_stream()
	assert_true(stream_res.get("success", false), "Diretta live streaming avviata con successo")
	assert_equal(player.energy, 25, "Consumo energia per live stream pari a 25")
	assert_true(stream_res.get("viewers", 0) > 0, "Spettatori collegati alla live positivi")
	
	var questions: Array = stream_res.get("questions", [])
	assert_true(not questions.is_empty(), "Domande dei fan generate per la chat live")
	
	# Risoluzione opzione 1 (Anteprima musicale)
	var ans_res := sys.resolve_live_stream_choice(1)
	assert_true(ans_res.get("success", false), "Risposta in chat live risolta")
	assert_true(ans_res.get("follower_gain", 0) > 0, "Follower conquistati con la diretta live")
	assert_true(sys.weekly_buzz > 1.0, "Weekly buzz incrementato dalla diretta")

# -------------------------------------------------------------
# TEST 4: Bivio Condizionale della Controversia Delegata al Manager
# -------------------------------------------------------------
func test_manager_crisis_delegation() -> void:
	print("\n[TEST 4] Bivio Condizionale Delegato al Manager...")
	var player := PlayerDataScript.new()
	var cal := CalendarDataScript.new()
	var sys := SocialMediaSystemScript.new(player, cal)
	
	# Caso A: Nessun manager ingaggiato -> scelta 3 deve fallire
	var dummy_post := SocialPostDataScript.new("test_post")
	sys._trigger_controversy(dummy_post, "Dichiarazione scottante")
	
	var res_no_mgr := sys.resolve_controversy(3)
	assert_true(not res_no_mgr.get("success", false), "Delega al manager rifiutata se non c'è un manager")
	assert_equal(res_no_mgr.get("reason", ""), "no_manager", "Motivo rifiuto: no_manager")
	
	# Caso B: Manager Professionista ingaggiato
	var mgr := ManagerDataScript.new("mgr_1", "Elena (Pro Indie)", Enums.ManagerType.PRO_INDIE)
	mgr.is_hired = true
	player.active_manager = mgr
	player.popularity = 25.0
	
	var res_pro := sys.resolve_controversy(3)
	assert_true(res_pro.get("success", false), "Crisi gestita con successo dal manager Professionista")
	assert_true(res_pro.get("rep_delta", 0.0) > 0.0, "Reputazione aumentata dalla risposta diplomatica del manager")
	assert_true(not sys.has_active_controversy(), "Controversia online estinta")

# -------------------------------------------------------------
# TEST 5: Fondazione Fan Club Ufficiale ed Elezione Presidente
# -------------------------------------------------------------
func test_fan_club_foundation_and_membership() -> void:
	print("\n[TEST 5] Fondazione Fan Club Ufficiale...")
	var player := PlayerDataScript.new()
	player.fans = 500
	var cal := CalendarDataScript.new()
	var sys := SocialMediaSystemScript.new(player, cal)
	
	# Rifiuto per requisiti fan non raggiunti (< 1000)
	var fail_found := sys.found_fan_club()
	assert_true(not fail_found.get("success", false), "Fondazione fan club bloccata se fan < 1000")
	assert_equal(fail_found.get("reason", ""), "fans_insufficient", "Motivo rifiuto: fans_insufficient")
	
	# Successo con 1500 fan
	player.fans = 1500
	var succ_found := sys.found_fan_club("Tommy 'The Boss'")
	assert_true(succ_found.get("success", false), "Fan Club Ufficiale fondato con successo")
	assert_true(player.fan_club.is_founded, "Flag is_founded verificato")
	assert_equal(player.fan_club.president_name, "Tommy 'The Boss'", "Nome presidente registrato")
	assert_true(player.fan_club.members_count >= 50, "Membri iniziali tesserati al fan club positivi")
	assert_true(player.fan_club.treasury > 0.0, "Cassa del fan club incrementata dalle quote associative")

# -------------------------------------------------------------
# TEST 6: Raduno Annuale dei Fan
# -------------------------------------------------------------
func test_fan_club_annual_meeting() -> void:
	print("\n[TEST 6] Raduno Annuale dei Fan...")
	var player := PlayerDataScript.new()
	player.energy = 50
	player.fans = 2000
	var cal := CalendarDataScript.new()
	cal.day_number = 10
	var sys := SocialMediaSystemScript.new(player, cal)
	
	sys.found_fan_club("Chiara Bass")
	var initial_money: float = player.money
	
	var meet_res := sys.organize_fan_club_meeting()
	assert_true(meet_res.get("success", false), "Raduno annuale dei fan celebrato con successo")
	assert_true(player.money > initial_money, "Introiti merchandising del raduno accreditati al giocatore")
	assert_true(player.fan_club.annual_meeting_held, "Flag annual_meeting_held impostato a true")
	
	# Tentativo di secondo raduno nello stesso anno -> Bloccato
	var second_meet := sys.organize_fan_club_meeting()
	assert_true(not second_meet.get("success", false), "Bloccato secondo raduno nello stesso anno solare")
	assert_equal(second_meet.get("reason", ""), "already_held_this_year", "Motivo rifiuto: already_held_this_year")

# -------------------------------------------------------------
# TEST 7: Impatto Presenze Garantite sui Concerti Live
# -------------------------------------------------------------
func test_concert_attendance_boost_with_fan_club() -> void:
	print("\n[TEST 7] Impatto Presenze Garantite Concerti con Fan Club...")
	var player := PlayerDataScript.new()
	player.fans = 3000
	player.popularity = 40.0
	player.energy = 80
	player.money = 500.0
	var cal := CalendarDataScript.new()
	cal.day_number = 1
	var concert_sys := ConcertSystemScript.new(player, cal)
	
	var venues: Array = VenueDataScript.get_default_venues()
	var club: VenueData = venues[1] # Pub
	concert_sys.set_venue_status_override(club.id, 1, Enums.VenueBookingStatus.FREE)
	
	var song1 := SongData.new("s_att", "Fan Track", Enums.MusicalGenre.ROCK)
	song1.status = Enums.SongStatus.RELEASED
	song1.quality_score = 75.0
	var setlist: Array[SongData] = [song1]
	
	# Risoluzione concerto senza fan club
	var res_no_club: Dictionary = concert_sys.resolve_concert(club, setlist, 5.0, false, 0.0)
	var att_no_club: int = int(res_no_club.get("audience", 0))
	
	# Fondazione fan club con 1000 membri (Loyalty Tier 3 -> +15% presenze minime garantite)
	var social_sys := SocialMediaSystemScript.new(player, cal)
	social_sys.found_fan_club("Lorenzo")
	player.fan_club.members_count = 1000
	player.fan_club._update_loyalty_tier()
	player.energy = 80
	player.money = 500.0
	
	var boost_pct: float = player.fan_club.get_concert_attendance_boost()
	assert_true(boost_pct >= 0.15, "Tier 3 del Fan Club garantisce almeno il +15% di zoccolo duro")
	
	var res_with_club: Dictionary = concert_sys.resolve_concert(club, setlist, 5.0, false, 0.0)
	var att_with_club: int = int(res_with_club.get("audience", 0))
	assert_true(att_with_club >= att_no_club, "Affluenza concerto potenziata dalla fedeltà del Fan Club")

# -------------------------------------------------------------
# TEST 8: Posta dei Fan Ossessivi e Decadimento Notturno
# -------------------------------------------------------------
func test_fan_mail_event_and_night_decay() -> void:
	print("\n[TEST 8] Posta dei Fan Ossessivi e Decadimento Notturno...")
	var player := PlayerDataScript.new()
	var cal := CalendarDataScript.new()
	var sys := SocialMediaSystemScript.new(player, cal)
	sys.weekly_buzz = 2.0
	sys.posts_published_today = 2
	
	# Generazione forzata fan mail
	sys._generate_fan_mail_event()
	assert_true(not sys.last_fan_mail.is_empty(), "Evento posta fan ossessivo generato correttamente")
	assert_true(sys.last_fan_mail.has("sender"), "Mittente pacco presente")
	assert_true(sys.last_fan_mail.has("item"), "Oggetto o regalo stravagante presente")
	
	sys.process_daily_decay()
	assert_equal(sys.posts_published_today, 0, "Contatore post giornalieri resettato dopo il ciclo notturno")
	assert_equal(sys.weekly_buzz, 1.80, "Decadimento del 10% del buzz a fine giornata verificato (2.0 -> 1.8)")

# -------------------------------------------------------------
# TEST 9: Persistenza Atomica FanClubData e Resoconto Fandom
# -------------------------------------------------------------
func test_fan_club_persistence_and_fandom_summary() -> void:
	print("\n[TEST 9] Persistenza Atomica FanClubData e Resoconto Fandom...")
	var player := PlayerDataScript.new()
	player.city_fans[Enums.CityId.MILANO] = 500
	player.city_fans[Enums.CityId.BOLOGNA] = 300
	player.city_fans[Enums.CityId.LONDRA] = 200
	player.city_fans[Enums.CityId.NEW_YORK] = 400
	
	var fandom: Dictionary = player.get_territorial_fans_summary()
	assert_equal(fandom.get("italian_fans", 0), 800, "Fandom italiano sommato correttamente (500 Milano + 300 Bologna)")
	assert_equal(fandom.get("european_fans", 0), 1000, "Fandom europeo sommato correttamente (800 Italia + 200 Londra)")
	assert_equal(fandom.get("global_fans", 0), 1400, "Fandom globale sommato correttamente (1000 Europa + 400 New York)")
	
	var cal := CalendarDataScript.new()
	var sys := SocialMediaSystemScript.new(player, cal)
	player.fans = 1500
	sys.found_fan_club("Andrea Vinyl")
	
	var p_dict := player.to_dict()
	assert_true(p_dict.has("fan_club"), "Dizionario PlayerData include chiave fan_club")
	
	var restored_player := PlayerDataScript.new()
	restored_player.from_dict(p_dict)
	assert_true(restored_player.fan_club != null, "Fan club ripristinato dopo from_dict")
	assert_true(restored_player.fan_club.is_founded, "Flag is_founded preservato dopo serializzazione atomica")
	assert_equal(restored_player.fan_club.president_name, "Andrea Vinyl", "Nome presidente preservato")
