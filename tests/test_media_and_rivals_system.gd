# res://tests/test_media_and_rivals_system.gd
extends Node

## Suite di Test Headless per Sezione 10: Artisti Rivali, Hit Parade & Media Broadcaster
## Valida:
## 1. Modelli dati MediaOutletData, RivalData esteso, ChartEntryData esteso con scope
## 2. Inizializzazione ed emittenti per città in MediaSystem
## 3. Conduzione interviste promozionali, consumo energia e incremento Hype/reputazione
## 4. Intervista di riparazione crisi post-scandalo
## 5. Rassegna stampa e speech vocale accessibile NVDA
## 6. Dinamiche relazionali rivali (complimento, co-headlining tour, dissing mediatico)
## 7. Classifiche territoriali per metropoli e meccanica tormentone stagionale
## 8. Persistenza atomica savegame e deserializzazione

const MediaOutletDataScript = preload("res://data/models/media_outlet_data.gd")
const MediaSystemScript = preload("res://systems/media_system.gd")
const RivalDataScript = preload("res://data/models/rival_data.gd")
const RivalSystemScript = preload("res://systems/rival_system.gd")
const ChartEntryDataScript = preload("res://data/models/chart_entry_data.gd")
const ChartSystemScript = preload("res://systems/chart_system.gd")
const PlayerDataScript = preload("res://data/models/player_data.gd")
const CalendarDataScript = preload("res://data/models/calendar_data.gd")
const SongDataScript = preload("res://data/models/song_data.gd")

var tests_passed: int = 0
var tests_failed: int = 0

func _ready() -> void:
	print("\n========================================================")
	print("   SUITE TEST SEZIONE 10: RIVALI, CLASSIFICHE & MEDIA   ")
	print("========================================================")
	
	test_media_outlet_model()
	test_media_system_initialization()
	test_conduct_interview_flow()
	test_conduct_crisis_repair()
	test_press_reviews_and_speech()
	test_rivals_relationships_and_interactions()
	test_co_headlining_proposal()
	test_dissing_mechanic()
	test_territorial_charts_and_seasonal_hit()
	test_media_system_save_and_load()
	
	print("\n--------------------------------------------------------")
	print("ESITO TEST SEZIONE 10 (RIVALI & MEDIA):")
	print("  Test Superati: %d" % tests_passed)
	print("  Test Falliti:  %d" % tests_failed)
	print("--------------------------------------------------------\n")
	
	if tests_failed == 0:
		print("[SUCCESSO] Sezione 10 convalidata al 100%!")
		get_tree().quit(0)
	else:
		printerr("[ERRORE CRITICO] Alcuni test della Sezione 10 sono falliti!")
		get_tree().quit(1)

func assert_true(cond: bool, msg: String) -> void:
	if cond:
		tests_passed += 1
		print("  [OK] %s" % msg)
	else:
		tests_failed += 1
		printerr("  [FALLITO] %s" % msg)

func assert_equal(act: Variant, exp: Variant, msg: String) -> void:
	if act == exp:
		tests_passed += 1
		print("  [OK] %s (%s == %s)" % [msg, str(act), str(exp)])
	else:
		tests_failed += 1
		printerr("  [FALLITO] %s (Atteso: %s, Ottenuto: %s)" % [msg, str(exp), str(act)])

# -------------------------------------------------------------
# TEST 1: Modello MediaOutletData
# -------------------------------------------------------------
func test_media_outlet_model() -> void:
	print("\n[TEST 1] Modello Dati MediaOutletData...")
	var o := MediaOutletDataScript.new(
		"radio_test", "Radio Test 100", Enums.BroadcastMediaType.LOCAL_RADIO, Enums.CityId.MILANO,
		10000, Enums.CareerTier.LOCAL_ARTIST, 10.0, Enums.MusicalGenre.ROCK, 15, 12.0, 1.5
	)
	assert_equal(o.id, "radio_test", "ID emittente corretto")
	assert_equal(o.get_type_name(), "Radio Locale", "Nome tipologia media corretto")
	
	var d: Dictionary = o.to_dict()
	var o_copy := MediaOutletDataScript.new()
	o_copy.from_dict(d)
	assert_equal(o_copy.name, "Radio Test 100", "Ripristino serializzazione nome riuscito")
	assert_equal(o_copy.reach_listeners, 10000, "Ripristino ascoltatori riuscito")

# -------------------------------------------------------------
# TEST 2: Inizializzazione MediaSystem
# -------------------------------------------------------------
func test_media_system_initialization() -> void:
	print("\n[TEST 2] Inizializzazione MediaSystem ed emittenti metropolitane...")
	var player := PlayerDataScript.new()
	var cal := CalendarDataScript.new()
	var ms := MediaSystemScript.new(player, cal)
	assert_true(ms.outlets.size() >= 6, "MediaSystem contiene almeno 6 emittenti continentali")
	
	var mi_outlets: Array = ms.get_outlets_for_city(Enums.CityId.MILANO)
	assert_true(mi_outlets.size() >= 2, "Milano dispone di almeno 2 canali accreditati (Radio e TV)")
	
	var bo_outlets: Array = ms.get_outlets_for_city(Enums.CityId.BOLOGNA)
	assert_true(bo_outlets.size() >= 2, "Bologna dispone di radio e podcast underground")

# -------------------------------------------------------------
# TEST 3: Conduzione Interviste Promozionali
# -------------------------------------------------------------
func test_conduct_interview_flow() -> void:
	print("\n[TEST 3] Conduzione Intervista Promozionale del Mattino...")
	var player := PlayerDataScript.new()
	player.energy = 50
	player.career_tier = Enums.CareerTier.LOCAL_ARTIST
	player.reputation = 20.0
	player.current_city_id = Enums.CityId.MILANO
	
	var cal := CalendarDataScript.new()
	var ms := MediaSystemScript.new(player, cal)
	
	var check: Dictionary = ms.can_do_interview("radio_pop_milano", 1)
	assert_true(check.get("allowed", false), "Intervista consentita con requisiti soddisfatti")
	
	var res: Dictionary = ms.conduct_interview("radio_pop_milano", 1)
	assert_true(res.get("success", false), "Intervista eseguita con successo")
	assert_equal(player.energy, 35, "Consumo energia 15 applicato (50 - 15 = 35)")
	assert_equal(ms.interview_history.size(), 1, "Storico interviste aggiornato")
	
	# Verifica limite giornaliero
	var check_again: Dictionary = ms.can_do_interview("radio_pop_milano", 1)
	assert_true(not check_again.get("allowed", false), "Seconda intervista nello stesso giorno rifiutata")
	assert_equal(check_again.get("reason", ""), "already_interviewed_today", "Motivazione corretta")

# -------------------------------------------------------------
# TEST 4: Intervista di Riparazione Crisi
# -------------------------------------------------------------
func test_conduct_crisis_repair() -> void:
	print("\n[TEST 4] Intervista di Riparazione Post-Crisi...")
	var player := PlayerDataScript.new()
	player.energy = 40
	player.reputation = 30.0
	var cal := CalendarDataScript.new()
	var ms := MediaSystemScript.new(player, cal)
	
	var rep_res: Dictionary = ms.conduct_crisis_repair_interview("radio_pop_milano", 2)
	assert_true(rep_res.get("success", false), "Intervista di riparazione riuscita")
	assert_equal(player.energy, 20, "Detrazione 20 energia per conferenza/intervista lunga")
	assert_equal(player.reputation, 34.0, "Reputazione ripristinata (+4.0 punti)")

# -------------------------------------------------------------
# TEST 5: Rassegna Stampa & Speech NVDA
# -------------------------------------------------------------
func test_press_reviews_and_speech() -> void:
	print("\n[TEST 5] Rassegna Stampa e Sintesi Vocale Accessibile...")
	var ms := MediaSystemScript.new()
	ms.add_press_review("Overdrive EP", "Marco Critico", "Rock Hard Magazine", 4.5, "Un debutto folgorante e viscerale!", 5)
	assert_equal(ms.press_reviews.size(), 1, "Recensione aggiunta correttamente")
	
	var speech: String = ms.get_press_speech()
	assert_true(speech.contains("Rock Hard Magazine"), "Speech vocale contiene il nome della testata")
	assert_true(speech.contains("4.5/5.0 stelle"), "Speech vocale contiene il punteggio in stelle")
	assert_true(speech.contains("Un debutto folgorante"), "Speech vocale contiene il commento del critico")

# -------------------------------------------------------------
# TEST 6: Dinamiche Relazionali con i Rivali
# -------------------------------------------------------------
func test_rivals_relationships_and_interactions() -> void:
	print("\n[TEST 6] Dinamiche Relazionali e Interazioni tra Band Rivali...")
	var rs := RivalSystemScript.new()
	var r: RivalData = rs.get_rival("rival_chrome_shadows")
	assert_true(r != null, "Rivale Chrome Shadows trovato")
	assert_equal(r.relationship, Enums.RivalRelationship.NEUTRAL, "Relazione iniziale Neutra")
	assert_equal(r.affinity_score, 50.0, "Affinità iniziale 50.0")
	
	# Elogio / Complimento
	var praise_res: Dictionary = rs.praise_rival("rival_chrome_shadows")
	assert_true(praise_res.get("success", false), "Elogio inviato con successo")
	assert_equal(r.affinity_score, 65.0, "Affinità incrementata a 65.0 (+15)")
	
	# Secondo elogio -> supera soglia 70
	rs.praise_rival("rival_chrome_shadows")
	assert_true(r.affinity_score >= 70.0, "Affinità supera 70.0")
	assert_equal(r.relationship, Enums.RivalRelationship.RESPECTFUL, "Relazione promossa a Rispetto & Collaborazione")
	assert_true(r.co_headlining_eligible, "Rivale ora idoneo a Tour Congiunto")

# -------------------------------------------------------------
# TEST 7: Proposta di Co-Headlining Tour
# -------------------------------------------------------------
func test_co_headlining_proposal() -> void:
	print("\n[TEST 7] Proposta di Co-Headlining Tour...")
	var rs := RivalSystemScript.new()
	var r: RivalData = rs.get_rival("rival_chrome_shadows")
	r.affinity_score = 40.0
	r.co_headlining_eligible = false
	
	# Rifiuto per affinità insufficiente
	var rej_res: Dictionary = rs.propose_co_headlining("rival_chrome_shadows")
	assert_true(rej_res.get("success", false), "Proposta processata")
	assert_true(not rej_res.get("accepted", true), "Proposta rifiutata per bassa affinità")
	
	# Promozione affinità
	r.update_affinity(35.0)
	assert_true(r.co_headlining_eligible, "Diventato idoneo")
	var acc_res: Dictionary = rs.propose_co_headlining("rival_chrome_shadows")
	assert_true(acc_res.get("accepted", false), "Proposta di Co-Headlining accettata!")
	assert_equal(acc_res.get("fan_bonus_mult", 1.0), Constants.MEDIA_CO_HEADLINING_FAN_BONUS, "Moltiplicatore fan bonus verificato")
	assert_equal(acc_res.get("expense_discount", 0.0), Constants.MEDIA_CO_HEADLINING_EXPENSE_DISCOUNT, "Sconto spese logistiche -30% verificato")

# -------------------------------------------------------------
# TEST 8: Dissing e Provocazione Mediatico
# -------------------------------------------------------------
func test_dissing_mechanic() -> void:
	print("\n[TEST 8] Dissing Mediatico e Degenerazione Faida...")
	var rs := RivalSystemScript.new()
	var diss_res: Dictionary = rs.trigger_dissing("rival_ribelli_pratello", 10)
	assert_true(diss_res.get("success", false), "Dissing innescato con successo")
	
	var r: RivalData = rs.get_rival("rival_ribelli_pratello")
	assert_equal(r.relationship, Enums.RivalRelationship.OPEN_FEUD, "Relazione degradata a Faida Aperta")
	assert_equal(r.rivalry_level, 2, "Livello rivalità sincronizzato a 2")
	assert_equal(r.last_dissing_day, 10, "Giorno del dissing registrato")
	assert_equal(diss_res.get("buzz_multiplier", 1.0), Constants.MEDIA_DISSING_BUZZ_MULT, "Moltiplicatore buzz 1.60x applicato")

# -------------------------------------------------------------
# TEST 9: Classifiche Territoriali & Tormentone Stagionale
# -------------------------------------------------------------
func test_territorial_charts_and_seasonal_hit() -> void:
	print("\n[TEST 9] Classifiche Territoriali e Tormentone Stagionale...")
	var player := PlayerDataScript.new()
	player.band_name = "The Champions"
	player.popularity = 40.0
	player.fans = 2500
	player.city_fans[Enums.CityId.BOLOGNA] = 1800
	
	var song := SongDataScript.new("s_earworm", "Tormentone d'Estate", Enums.MusicalGenre.POP)
	song.status = Enums.SongStatus.RELEASED
	song.quality_score = 80.0
	song.special_trait = Enums.SongTrait.EARWORM
	player.songs.append(song)
	
	var cal := CalendarDataScript.new()
	cal.day_number = 95 # Mese 4 (Estate)
	
	var rs := RivalSystemScript.new()
	var cs := ChartSystemScript.new(player, cal, rs)
	
	var upd: Dictionary = cs.update_weekly_charts(95)
	assert_true(upd.get("success", false), "Aggiornamento classifiche settimanali riuscito")
	assert_true(cs.territorial_singles.has(Enums.CityId.BOLOGNA), "Classifica territoriale di Bologna generata")
	
	var bo_chart: Array = cs.get_territorial_chart(Enums.CityId.BOLOGNA, false)
	assert_true(not bo_chart.is_empty(), "Hit Parade Bologna contiene brani")
	assert_equal(bo_chart[0].chart_scope, Enums.ChartScope.NATIONAL, "ChartEntryData possiede scope NATIONAL")
	assert_equal(bo_chart[0].target_city_id, Enums.CityId.BOLOGNA, "Target city id corretto")
	
	var speech_terr: String = cs.get_territorial_charts_speech(Enums.CityId.BOLOGNA, 0)
	assert_true(speech_terr.contains("Bologna"), "Speech vocale territoriale menziona Bologna")

# -------------------------------------------------------------
# TEST 10: Persistenza Atomica MediaSystem
# -------------------------------------------------------------
func test_media_system_save_and_load() -> void:
	print("\n[TEST 10] Persistenza Savegame MediaSystem...")
	var ms := MediaSystemScript.new()
	ms.last_interview_day = 14
	ms.interview_history.append({"day": 14, "outlet_name": "Rock TV", "hype_added": 25.0})
	ms.add_press_review("Capolavoro LP", "Gigi Penna", "Metal Hammer", 5.0, "Epocale!", 14)
	
	var saved: Dictionary = ms.to_dict()
	assert_equal(saved.get("last_interview_day", 0), 14, "last_interview_day serializzato")
	
	var ms_loaded := MediaSystemScript.new()
	ms_loaded.from_dict(saved)
	assert_equal(ms_loaded.last_interview_day, 14, "last_interview_day deserializzato")
	assert_equal(ms_loaded.interview_history.size(), 1, "interview_history ripristinato")
	assert_equal(ms_loaded.press_reviews.size(), 1, "press_reviews ripristinato")
	assert_equal(ms_loaded.press_reviews[0].outlet, "Metal Hammer", "Testata recensione ripristinata")
