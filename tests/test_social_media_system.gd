# res://tests/test_social_media_system.gd
extends Node

## Suite di Test Headless per Social Media, Fan Engagement & Viralità (World-tour V4.0 / Fase 8.4)
## Valida il modulo SocialMediaSystem, il modello SocialPostData, i 4 formati di pubblicazione,
## l'algoritmo di views/likes/shares, il riverbero fan, le dinamiche di shitstorm/controversia online,
## il decadimento del buzz e la serializzazione savegame con accessibilità NVDA.

const SocialPostDataScript = preload("res://data/models/social_post_data.gd")
const SocialMediaSystemScript = preload("res://systems/social_media_system.gd")
const PlayerDataScript = preload("res://data/models/player_data.gd")
const CalendarDataScript = preload("res://data/models/calendar_data.gd")
const BandMemberDataScript = preload("res://data/models/band_member_data.gd")
const SongDataScript = preload("res://data/models/song_data.gd")

var tests_passed: int = 0
var tests_failed: int = 0

func _ready() -> void:
	print("\n========================================================")
	print("   SUITE TEST SOCIAL MEDIA, VIRALITÀ & BUZZ (F8.4)      ")
	print("========================================================")
	
	test_system_initialization()
	test_post_types_and_energy_cost()
	test_practice_clip_publication()
	test_track_teaser_publication()
	test_behind_the_scenes_and_band_traits()
	test_provocation_and_online_controversy_trigger()
	test_resolve_controversy_ignore_and_apology()
	test_resolve_controversy_double_down()
	test_daily_decay_and_live_buzz_multiplier()
	test_linear_nvda_speech_and_savegame_serialization()
	
	print("\n--------------------------------------------------------")
	print("ESITO COMPLESSIVO TEST SOCIAL MEDIA (F8.4):")
	print("  Test Superati: %d" % tests_passed)
	print("  Test Falliti:  %d" % tests_failed)
	print("--------------------------------------------------------\n")
	
	if tests_failed == 0:
		print("[SUCCESSO] Social Media & Viralità (F8.4) sono convalidati al 100%!")
		get_tree().quit(0)
	else:
		printerr("[ERRORE CRITICO] Alcuni test del sistema social media sono falliti!")
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

func assert_almost_equal(actual: float, expected: float, tolerance: float, message: String) -> void:
	if abs(actual - expected) <= tolerance:
		tests_passed += 1
		print("  [OK] %s (Ottenuto: %.2f, Atteso: %.2f)" % [message, actual, expected])
	else:
		tests_failed += 1
		printerr("  [FALLITO] %s (Ottenuto: %.2f, Atteso: %.2f, Tolleranza: %.2f)" % [message, actual, expected, tolerance])

# -------------------------------------------------------------
# TEST 1: Inizializzazione del Sistema SocialMediaSystem
# -------------------------------------------------------------
func test_system_initialization() -> void:
	print("\n[TEST 1] Inizializzazione del Sistema SocialMediaSystem...")
	var player := PlayerDataScript.new()
	var cal := CalendarDataScript.new()
	var sys := SocialMediaSystemScript.new(player, cal)
	
	assert_equal(sys.total_followers, 150, "Follower iniziali impostati a 150 per la band emergente")
	assert_almost_equal(sys.weekly_buzz, 1.0, 0.01, "Weekly buzz iniziale impostato a 1.00x")
	assert_true(sys.post_history.is_empty(), "Cronologia post vuota alla creazione")
	assert_equal(sys.posts_published_today, 0, "Post pubblicati oggi azzerati")
	assert_true(not sys.has_active_controversy(), "Nessuna polemica online attiva all'avvio")

# -------------------------------------------------------------
# TEST 2: Costi Energetici e Limite Giornaliero
# -------------------------------------------------------------
func test_post_types_and_energy_cost() -> void:
	print("\n[TEST 2] Costi Energetici e Limite Giornaliero...")
	var player := PlayerDataScript.new()
	var cal := CalendarDataScript.new()
	var sys := SocialMediaSystemScript.new(player, cal)
	
	assert_equal(sys.get_energy_cost_for_type(Enums.SocialPostType.PRACTICE_CLIP), 10, "Costo Clip Prove = 10 energia")
	assert_equal(sys.get_energy_cost_for_type(Enums.SocialPostType.TRACK_TEASER), 15, "Costo Teaser Brano = 15 energia")
	assert_equal(sys.get_energy_cost_for_type(Enums.SocialPostType.BEHIND_THE_SCENES), 10, "Costo Backstage = 10 energia")
	assert_equal(sys.get_energy_cost_for_type(Enums.SocialPostType.PROVOCATION), 15, "Costo Provocazione = 15 energia")
	
	player.energy = 5
	var check := sys.can_publish_post(Enums.SocialPostType.PRACTICE_CLIP)
	assert_true(not check.allowed, "Pubblicazione bloccata se l'energia è inferiore al costo (5 < 10)")
	assert_equal(check.reason, "energy_insufficient", "Motivo rifiuto: energy_insufficient")
	
	player.energy = 100
	sys.posts_published_today = 3
	var check_limit := sys.can_publish_post(Enums.SocialPostType.PRACTICE_CLIP)
	assert_true(not check_limit.allowed, "Pubblicazione bloccata se raggiunti 3 post giornalieri")
	assert_equal(check_limit.reason, "daily_limit_reached", "Motivo rifiuto: daily_limit_reached")

# -------------------------------------------------------------
# TEST 3: Pubblicazione Clip Prove e Riverbero Fan
# -------------------------------------------------------------
func test_practice_clip_publication() -> void:
	print("\n[TEST 3] Pubblicazione Clip Prove e Riverbero Fan...")
	var player := PlayerDataScript.new()
	player.energy = 100
	player.fans = 200
	var cal := CalendarDataScript.new()
	cal.day_number = 4
	var sys := SocialMediaSystemScript.new(player, cal)
	
	var res := sys.publish_post(Enums.SocialPostType.PRACTICE_CLIP)
	assert_true(res.success, "Pubblicazione Clip Prove eseguita con successo")
	assert_equal(player.energy, 90, "Energia scalata correttamente di 10 (100 -> 90)")
	assert_true(res.views > 0, "Visualizzazioni generate positive (%d)" % res.views)
	assert_true(res.likes > 0, "Mi piace generati positivi (%d)" % res.likes)
	assert_true(res.new_followers > 0, "Nuovi follower conquistati (%d)" % res.new_followers)
	assert_true(sys.total_followers > 150, "Follower totali aumentati a %d" % sys.total_followers)
	assert_true(player.fans > 200, "Fan reali del giocatore accreditati (%d)" % player.fans)
	assert_true(sys.weekly_buzz > 1.0, "Weekly buzz incrementato a %.2f" % sys.weekly_buzz)
	assert_equal(sys.posts_published_today, 1, "Post pubblicati oggi aggiornati a 1")
	assert_equal(sys.post_history.size(), 1, "Post registrato nella cronologia")

# -------------------------------------------------------------
# TEST 4: Pubblicazione Teaser Brano e Qualità Musicale
# -------------------------------------------------------------
func test_track_teaser_publication() -> void:
	print("\n[TEST 4] Pubblicazione Teaser Brano e Qualità Musicale...")
	var player := PlayerDataScript.new()
	player.energy = 100
	player.songs.clear()
	var cal := CalendarDataScript.new()
	var sys := SocialMediaSystemScript.new(player, cal)
	
	# Senza brani
	var check_nosong := sys.can_publish_post(Enums.SocialPostType.TRACK_TEASER)
	assert_true(not check_nosong.allowed, "Teaser rifiutato se la band non possiede brani a catalogo")
	
	# Con brano a catalogo
	var test_song := SongDataScript.new("s_test", "Midnight Electric", Enums.MusicalGenre.ROCK)
	test_song.quality_score = 75.0
	player.songs.append(test_song)
	
	var res := sys.publish_post(Enums.SocialPostType.TRACK_TEASER, "s_test")
	assert_true(res.success, "Teaser brano pubblicato con successo")
	assert_equal(res.post.song_id, "s_test", "ID brano collegato correttamente al post")
	assert_equal(res.post.song_title, "Midnight Electric", "Titolo brano registrato nel post")
	assert_true(test_song.quality_score >= 75.0, "Qualità brano mantenuta o valorizzata dal teaser")

# -------------------------------------------------------------
# TEST 5: Backstage e Tratti Personalità Band
# -------------------------------------------------------------
func test_behind_the_scenes_and_band_traits() -> void:
	print("\n[TEST 5] Backstage e Tratti Personalità Band...")
	var player := PlayerDataScript.new()
	player.energy = 100
	
	# Compagno con WILD_PARTY
	var member := BandMemberDataScript.new("m_wild", "Spike", Enums.BandRole.BASS)
	member.personality = Enums.BandPersonality.WILD_PARTY
	member.tension = 20.0
	player.band_members.append(member)
	
	var cal := CalendarDataScript.new()
	var sys := SocialMediaSystemScript.new(player, cal)
	
	var res := sys.publish_post(Enums.SocialPostType.BEHIND_THE_SCENES)
	assert_true(res.success, "Post Backstage pubblicato con successo")
	assert_equal(res.post.post_type, Enums.SocialPostType.BEHIND_THE_SCENES, "Tipologia post verificata")
	assert_true(not res.post.caption.is_empty(), "Didascalia procedurale del backstage generata")
	assert_true(not res.post.comments_sample.is_empty(), "Commenti procedurali del pubblico presenti")

# -------------------------------------------------------------
# TEST 6: Post Provocatorio e Innesco Polemica Online
# -------------------------------------------------------------
func test_provocation_and_online_controversy_trigger() -> void:
	print("\n[TEST 6] Post Provocatorio e Innesco Polemica Online...")
	var player := PlayerDataScript.new()
	player.energy = 100
	var cal := CalendarDataScript.new()
	var sys := SocialMediaSystemScript.new(player, cal)
	
	# Forziamo una controversia tramite post o innesco diretto
	var dummy_post := SocialPostDataScript.new("post_test", Enums.SocialPostType.PROVOCATION, 5, "Attacco ai media")
	sys._trigger_controversy(dummy_post, "Dichiarazione sfrontata contro le radio commerciali")
	
	assert_true(sys.has_active_controversy(), "Polemica online riconosciuta attiva nel sistema")
	assert_equal(sys.active_controversy.post_id, "post_test", "ID post originale collegato alla polemica")
	assert_true(sys.active_controversy.intensity >= 1, "Livello di intensità della polemica valido")
	
	# Quando c'è una controversia attiva, nuove pubblicazioni sono bloccate finché non risolta
	var check := sys.can_publish_post(Enums.SocialPostType.PRACTICE_CLIP)
	assert_true(not check.allowed, "Pubblicazione bloccata se è in corso una polemica non risolta")
	assert_equal(check.reason, "controversy_active", "Motivo rifiuto: controversy_active")

# -------------------------------------------------------------
# TEST 7: Risoluzione Polemica (Ignora e Scuse Formali)
# -------------------------------------------------------------
func test_resolve_controversy_ignore_and_apology() -> void:
	print("\n[TEST 7] Risoluzione Polemica (Ignora e Scuse Formali)...")
	var player := PlayerDataScript.new()
	player.popularity = 40.0
	player.stress = 10
	var cal := CalendarDataScript.new()
	var sys := SocialMediaSystemScript.new(player, cal)
	sys.total_followers = 1000
	
	# 1. Test Scelta 0: Ignora
	var p1 := SocialPostDataScript.new("p1", Enums.SocialPostType.PROVOCATION, 1)
	sys._trigger_controversy(p1, "Test polemica 1")
	var res_ignore := sys.resolve_controversy(0)
	assert_true(res_ignore.success, "Polemica risolta con opzione Ignora")
	assert_true(sys.total_followers < 1000, "Follower calati (-2%%) per mancata risposta: %d" % sys.total_followers)
	assert_equal(player.stress, 16, "Stress aumentato (+6) per tensione non affrontata")
	assert_true(not sys.has_active_controversy(), "Polemica rimossa dal sistema")
	
	# 2. Test Scelta 1: Scuse formali
	sys.total_followers = 1000
	var p2 := SocialPostDataScript.new("p2", Enums.SocialPostType.PROVOCATION, 2)
	sys._trigger_controversy(p2, "Test polemica 2")
	var res_apology := sys.resolve_controversy(1)
	assert_true(res_apology.success, "Polemica risolta con Scuse Formali")
	assert_almost_equal(player.popularity, 43.5, 0.01, "Reputazione salita a 43.5 (+3.5) per maturità")
	assert_true(sys.total_followers < 1000, "Follower calati (-4%) per delusione ribelli")
	assert_true(not sys.has_active_controversy(), "Polemica azzerata")

# -------------------------------------------------------------
# TEST 8: Risoluzione Polemica (Raddoppia la Posta / Double Down)
# -------------------------------------------------------------
func test_resolve_controversy_double_down() -> void:
	print("\n[TEST 8] Risoluzione Polemica (Raddoppia la Posta / Double Down)...")
	var player := PlayerDataScript.new()
	var cal := CalendarDataScript.new()
	var sys := SocialMediaSystemScript.new(player, cal)
	sys.total_followers = 1000
	
	var p3 := SocialPostDataScript.new("p3", Enums.SocialPostType.PROVOCATION, 3)
	sys._trigger_controversy(p3, "Polemica estrema")
	
	var res_dd := sys.resolve_controversy(2)
	assert_true(res_dd.success, "Polemica risolta con scelta Raddoppia la Posta")
	assert_true(res_dd.has("is_triumph"), "Risultato include flag is_triumph")
	assert_true(not sys.has_active_controversy(), "Controversia conclusa dopo Double Down")

# -------------------------------------------------------------
# TEST 9: Decadimento Fisiologico del Buzz e Reset Giornaliero
# -------------------------------------------------------------
func test_daily_decay_and_live_buzz_multiplier() -> void:
	print("\n[TEST 9] Decadimento Fisiologico del Buzz e Reset Giornaliero...")
	var player := PlayerDataScript.new()
	var cal := CalendarDataScript.new()
	var sys := SocialMediaSystemScript.new(player, cal)
	
	sys.weekly_buzz = 2.0
	sys.posts_published_today = 3
	
	assert_almost_equal(sys.get_live_buzz_multiplier(), 2.0, 0.01, "get_live_buzz_multiplier() ritorna 2.00x")
	
	# Esecuzione decadimento notturno
	sys.process_daily_decay()
	assert_equal(sys.posts_published_today, 0, "Contatore post giornalieri resettato a 0")
	assert_almost_equal(sys.weekly_buzz, 1.8, 0.05, "Weekly buzz sceso del 10% (2.0 -> 1.8)")
	
	# Il buzz non scende mai sotto 1.00x
	sys.weekly_buzz = 1.05
	sys.process_daily_decay()
	assert_true(sys.weekly_buzz >= 1.0, "Weekly buzz non scende mai sotto il floor 1.00x (attuale: %.2f)" % sys.weekly_buzz)

# -------------------------------------------------------------
# TEST 10: Resa Vocale NVDA e Serializzazione Savegame
# -------------------------------------------------------------
func test_linear_nvda_speech_and_savegame_serialization() -> void:
	print("\n[TEST 10] Resa Vocale NVDA e Serializzazione Savegame...")
	var player := PlayerDataScript.new()
	var cal := CalendarDataScript.new()
	cal.day_number = 7
	var sys := SocialMediaSystemScript.new(player, cal)
	
	sys.total_followers = 2450
	sys.weekly_buzz = 1.65
	sys.posts_published_today = 2
	
	var post := SocialPostDataScript.new("p_nvda", Enums.SocialPostType.PRACTICE_CLIP, 7, "Prove rock")
	post.views = 520
	post.likes = 78
	post.new_followers = 19
	post.comments_sample.append("Fantastici!")
	sys.post_history.append(post)
	
	# Verifica Speech NVDA
	var speech: String = sys.get_social_feed_speech()
	assert_true(speech.contains("Follower Totali: 2450"), "Speech contiene follower totali corretti")
	assert_true(speech.contains("1.65x"), "Speech contiene buzz corretto")
	assert_true(speech.contains("Post 1: Clip delle Prove"), "Speech contiene descrizione lineare del post")
	assert_true(not speech.contains("|") and not speech.contains("---"), "Speech privo di box ASCII complessi o tabelle 2D")
	
	# Verifica Serializzazione to_dict / from_dict
	var save_dict := sys.to_dict()
	assert_equal(save_dict.total_followers, 2450, "Serializzazione total_followers corretta")
	assert_almost_equal(float(save_dict.weekly_buzz), 1.65, 0.01, "Serializzazione weekly_buzz corretta")
	assert_equal(save_dict.posts_published_today, 2, "Serializzazione posts_published_today corretta")
	assert_equal(save_dict.post_history.size(), 1, "Serializzazione cronologia post corretta")
	
	# Deserializzazione su nuova istanza
	var loaded_sys := SocialMediaSystemScript.new()
	loaded_sys.from_dict(save_dict)
	assert_equal(loaded_sys.total_followers, 2450, "Deserializzazione total_followers ripristinata")
	assert_almost_equal(loaded_sys.weekly_buzz, 1.65, 0.01, "Deserializzazione weekly_buzz ripristinata")
	assert_equal(loaded_sys.posts_published_today, 2, "Deserializzazione posts_published_today ripristinata")
	assert_equal(loaded_sys.post_history.size(), 1, "Deserializzazione post_history ripristinata")
	assert_equal(loaded_sys.post_history[0].views, 520, "Metriche post ricaricate correttamente")
