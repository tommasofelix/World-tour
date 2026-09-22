# res://tests/test_album_system.gd
extends Node

## Suite di Test Automatizzati per AlbumSystem, Lifestyle e Alloggi (World-tour V2.0)
## Copre: AlbumData, validazione EP/LP, metriche recensioni/qualità, produzione/rilascio,
## royalties a catalogo, lifestyle e divisione affitti.

var tests_passed: int = 0
var tests_failed: int = 0

func _ready() -> void:
	print("\n========================================================")
	print("   SUITE TEST ALBUM, LIFESTYLE & ROYALTIES (V2.0)       ")
	print("========================================================\n")
	
	test_album_data_model()
	test_album_validation()
	test_album_metrics_calculation()
	test_album_creation_and_release()
	test_daily_royalties_system()
	test_housing_lifestyle_and_end_day()
	test_album_creator_ui_instantiation()
	
	print("\n--------------------------------------------------------")
	print("ESITO COMPLESSIVO TEST SISTEMA ALBUM & LIFESTYLE:")
	print("  Test Superati: %d" % tests_passed)
	print("  Test Falliti:  %d" % tests_failed)
	print("--------------------------------------------------------\n")
	
	if tests_failed > 0:
		print("[ERRORE CRITICO] Alcuni test del sistema album/lifestyle sono falliti!")
		get_tree().quit(1)
	else:
		print("[SUCCESSO] Il Sistema Album & Lifestyle è convalidato al 100%!")
		get_tree().quit(0)

func assert_true(condition: bool, test_name: String) -> void:
	if condition:
		print("  [OK] %s" % test_name)
		tests_passed += 1
	else:
		print("  [FALLITO] %s" % test_name)
		tests_failed += 1

func assert_equal(val1: Variant, val2: Variant, test_name: String) -> void:
	if val1 == val2:
		print("  [OK] %s (%s == %s)" % [test_name, str(val1), str(val2)])
		tests_passed += 1
	else:
		print("  [FALLITO] %s (Atteso: %s, Ottenuto: %s)" % [test_name, str(val2), str(val1)])
		tests_failed += 1

# 1. Modello Dati AlbumData
func test_album_data_model() -> void:
	print("1. Verifica Modello AlbumData e Serializzazione:")
	var album := AlbumData.new("alb_001", "Debut Masterpiece", Enums.AlbumType.EP)
	assert_equal(album.id, "alb_001", "ID album impostato correttamente")
	assert_equal(album.title, "Debut Masterpiece", "Titolo album impostato correttamente")
	assert_equal(album.album_type, Enums.AlbumType.EP, "Tipo album impostato su EP")
	assert_equal(album.get_min_tracks(), 3, "Minimo tracce per EP = 3")
	assert_equal(album.get_max_tracks(), 5, "Massimo tracce per EP = 5")
	
	album.album_type = Enums.AlbumType.LP
	assert_equal(album.get_min_tracks(), 6, "Minimo tracce per LP = 6")
	assert_equal(album.get_max_tracks(), 10, "Massimo tracce per LP = 10")
	
	album.song_ids = ["s1", "s2", "s3", "s4", "s5", "s6"]
	album.overall_quality = 78.5
	album.review_stars = 4.5
	album.total_sales = 350.0
	album.is_released = true
	
	var data: Dictionary = album.to_dict()
	var restored := AlbumData.new()
	restored.from_dict(data)
	assert_equal(restored.id, "alb_001", "from_dict ripristina id")
	assert_equal(restored.title, "Debut Masterpiece", "from_dict ripristina titolo")
	assert_equal(restored.song_ids.size(), 6, "from_dict ripristina elenco tracce")
	assert_equal(restored.review_stars, 4.5, "from_dict ripristina stelle recensione")
	assert_true(restored.is_released, "from_dict ripristina stato rilascio")

# 2. Validazione Composizione Tracce
func test_album_validation() -> void:
	print("\n2. Verifica Validazione Composizione Tracce (EP & LP):")
	var player := PlayerData.new()
	player.populate_starter_test_songs()
	var album_sys := AlbumSystem.new(player, CalendarData.new())
	
	# Trova brani eseguibili/pronti
	var ready_songs: Array[String] = []
	for s in player.songs:
		if s.status == Enums.SongStatus.PRODUCED or s.status == Enums.SongStatus.RELEASED:
			ready_songs.append(s.id)
			
	# Test troppo poche tracce per EP (< 3)
	var val_few := album_sys.validate_album_composition(["s1", "s2"], Enums.AlbumType.EP)
	assert_true(not val_few.valid, "Rifiutate meno di 3 tracce per EP")
	assert_equal(val_few.reason, "too_few_tracks", "Causa rifiuto: too_few_tracks")
	
	# Test troppe tracce per EP (> 5)
	var val_many := album_sys.validate_album_composition(["s1", "s2", "s3", "s4", "s5", "s6"], Enums.AlbumType.EP)
	assert_true(not val_many.valid, "Rifiutate più di 5 tracce per EP")
	assert_equal(val_many.reason, "too_many_tracks", "Causa rifiuto: too_many_tracks")
	
	# Test tracce duplicate
	var val_dup := album_sys.validate_album_composition([ready_songs[0], ready_songs[0], ready_songs[1]], Enums.AlbumType.EP)
	assert_true(not val_dup.valid, "Rifiutate tracce duplicate nell'album")
	assert_equal(val_dup.reason, "duplicate_tracks", "Causa rifiuto: duplicate_tracks")
	
	# Test composizione valida per EP (3 tracce pronte)
	var valid_ep_tracks: Array[String] = [ready_songs[0], ready_songs[1], ready_songs[2]]
	var val_ok := album_sys.validate_album_composition(valid_ep_tracks, Enums.AlbumType.EP)
	assert_true(val_ok.valid, "Composizione 3 tracce pronte valida per EP")
	
	# Test composizione valida per LP (6 tracce pronte)
	var valid_lp_tracks: Array[String] = [
		ready_songs[0], ready_songs[1], ready_songs[2],
		ready_songs[3], ready_songs[4], ready_songs[5]
	]
	var val_lp_ok := album_sys.validate_album_composition(valid_lp_tracks, Enums.AlbumType.LP)
	assert_true(val_lp_ok.valid, "Composizione 6 tracce pronte valida per LP")

# 3. Calcolo Metriche, Qualità e Recensioni
func test_album_metrics_calculation() -> void:
	print("\n3. Verifica Calcolo Metriche, Recensioni e Vendite Stimate:")
	var player := PlayerData.new()
	player.populate_starter_test_songs()
	var cal := CalendarData.new()
	var album_sys := AlbumSystem.new(player, cal)
	
	var ready_songs: Array[String] = []
	for s in player.songs:
		if s.status == Enums.SongStatus.PRODUCED or s.status == Enums.SongStatus.RELEASED:
			ready_songs.append(s.id)
			
	var ep_tracks: Array[String] = [ready_songs[0], ready_songs[1], ready_songs[2]]
	var metrics := album_sys.calculate_album_metrics(
		ep_tracks,
		ep_tracks[0],
		Enums.AlbumConcept.COMMERCIAL_HIT,
		Enums.ArtworkStyle.RETRO_PSYCHEDELIC,
		Enums.AlbumType.EP
	)
	
	assert_true(metrics.overall_quality >= 1.0 and metrics.overall_quality <= 100.0, "Qualità complessiva compresa tra 1 e 100")
	assert_true(metrics.review_stars >= 1.0 and metrics.review_stars <= 5.0, "Recensioni critiche comprese tra 1 e 5 stelle")
	assert_equal(metrics.cost, Constants.ALBUM_EP_PRODUCTION_COST, "Costo produzione EP = 80.0 €")
	assert_true(metrics.initial_sales >= 15.0, "Vendite iniziali positive")
	assert_true(metrics.gross_revenue > 0.0, "Ricavo lordo stimato positivo")
	assert_true(metrics.fan_gain > 0, "Guadagno fan stimato positivo")

# 4. Creazione e Rilascio Ufficiale Album
func test_album_creation_and_release() -> void:
	print("\n4. Verifica Creazione e Rilascio Album (Fondi, Ripartizione, Fan):")
	var player := PlayerData.new()
	player.populate_starter_test_songs()
	player.money = 50.0 # Insufficiente per EP (costo 80€)
	var cal := CalendarData.new()
	var album_sys := AlbumSystem.new(player, cal)
	
	var ready_songs: Array[String] = []
	for s in player.songs:
		if s.status == Enums.SongStatus.PRODUCED:
			ready_songs.append(s.id)
			
	var ep_tracks: Array[String] = [ready_songs[0], ready_songs[1], ready_songs[2]]
	
	# Test fallimento fondi insufficienti
	var fail_res := album_sys.create_and_release_album(
		"Poor Album", Enums.AlbumType.EP, ep_tracks, ep_tracks[0],
		Enums.AlbumConcept.RAW_UNDERGROUND, Enums.ArtworkStyle.MINIMALIST
	)
	assert_true(not fail_res.success, "Rilascio album fallisce con fondi insufficienti")
	assert_equal(fail_res.reason, "money_insufficient", "Motivo: money_insufficient")
	
	# Test rilascio con fondi sufficienti e band attiva
	player.money = 300.0
	var band_member := BandMemberData.new("bm_01", "Luca Bass", Enums.BandRole.BASS, Enums.BandPersonality.RELIABLE, 0, 30)
	band_member.respect = 50.0
	band_member.tension = 20.0
	player.add_band_member(band_member)
	player.revenue_split_mode = Enums.RevenueSplit.EQUAL_SPLIT # 25% a testa
	
	var initial_fans: int = player.fans
	var initial_rep: float = player.reputation
	
	var success_res := album_sys.create_and_release_album(
		"Rock Legends EP", Enums.AlbumType.EP, ep_tracks, ep_tracks[0],
		Enums.AlbumConcept.COMMERCIAL_HIT, Enums.ArtworkStyle.RETRO_PSYCHEDELIC
	)
	
	assert_true(success_res.success, "Pubblicazione album riuscita")
	assert_equal(player.albums.size(), 1, "Registrato 1 album in player_data")
	var released_album: AlbumData = player.albums[0]
	assert_equal(released_album.title, "Rock Legends EP", "Titolo album registrato correttamente")
	assert_true(released_album.is_released, "Flag is_released impostato su true")
	
	# Verifica brani inclusi impostati a RELEASED
	for s_id in ep_tracks:
		for s in player.songs:
			if s.id == s_id:
				assert_equal(s.status, Enums.SongStatus.RELEASED, "Brano '%s' promosso a RELEASED" % s.title)
				
	assert_true(player.fans > initial_fans, "Fan aumentati dopo la release dell'album")
	assert_true(player.reputation >= initial_rep, "Reputazione aumentata dopo la release dell'album")
	assert_true(success_res.revenue > 0.0, "Quota incassi netti per il leader accreditata")

# 5. Royalties Giornaliere di Catalogo
func test_daily_royalties_system() -> void:
	print("\n5. Verifica Royalties Giornaliere di Catalogo:")
	var player := PlayerData.new()
	player.money = 100.0
	var cal := CalendarData.new()
	cal.day_number = 5
	var album_sys := AlbumSystem.new(player, cal)
	
	# Crea un album a catalogo rilasciato al Giorno 1
	var album := AlbumData.new("alb_cat", "Greatest Hits Vol. 1", Enums.AlbumType.EP)
	album.overall_quality = 70.0
	album.review_stars = 4.0
	album.release_day = 1
	album.is_released = true
	player.albums.append(album)
	
	var initial_money: float = player.money
	var roy_res := album_sys.process_daily_royalties()
	var tot_roy: float = float(roy_res.get("total_royalties", 0.0))
	var alb_cnt: int = int(roy_res.get("album_count", 0))
	assert_true(tot_roy > 0.0, "Royalties passive calcolate e positive")
	assert_equal(alb_cnt, 1, "Conteggio album elaborati = 1")
	assert_equal(player.money, initial_money + tot_roy, "Saldo aggiornato con accredito royalties")
	assert_true(album.total_sales > 0.0, "Vendite totali album incrementate dalle royalties")

# 6. Lifestyle, Alloggi e Risoluzione Fine Giornata
func test_housing_lifestyle_and_end_day() -> void:
	print("\n6. Verifica Alloggi, Lifestyle e Risoluzione Fine Giornata:")
	var player := PlayerData.new()
	player.money = 500.0
	var cal := CalendarData.new()
	cal.day_number = 3
	var econ := EconomySystem.new(player, cal)
	var end_day := EndDaySystem.new(player, cal)
	
	# Starter bedroom: affitto 15€, cibo 10€ -> spese fisse 25€
	assert_equal(player.current_housing_tier, Enums.HousingTier.STARTER_BEDROOM, "Alloggio di partenza: STARTER_BEDROOM")
	var exp := econ.get_daily_fixed_expenses()
	assert_equal(exp.rent, 15.0, "Canone stanzetta = 15.0 €")
	assert_equal(exp.total, 25.0, "Spese fisse totali = 25.0 €")
	
	# Tentativo di traslocare in SHARED_FLAT senza compagni di band -> Rifiutato
	var res_shared_no_band := econ.change_housing(Enums.HousingTier.SHARED_FLAT)
	assert_true(not res_shared_no_band.success, "Rifiutato appartamento condiviso senza compagni di band")
	assert_equal(res_shared_no_band.reason, "no_band_members", "Motivo: no_band_members")
	
	# Aggiunta di un compagno di band
	var mate := BandMemberData.new("mate_01", "Simone Keys", Enums.BandRole.KEYBOARDS, Enums.BandPersonality.RELIABLE, 0, 25)
	player.add_band_member(mate)
	
	# Ora il trasloco in SHARED_FLAT riesce
	var res_shared_ok := econ.change_housing(Enums.HousingTier.SHARED_FLAT)
	assert_true(res_shared_ok.success, "Trasloco in SHARED_FLAT con compagni band riuscito")
	assert_equal(player.current_housing_tier, Enums.HousingTier.SHARED_FLAT, "Alloggio aggiornato a SHARED_FLAT")
	
	# Canone diviso per 2 persone (Alex + Simone): 25 / 2 = 12.50 €
	var exp_shared := econ.get_daily_fixed_expenses()
	assert_equal(exp_shared.rent, 12.50, "Canone pro-capite condiviso = 12.50 € (25.0 / 2)")
	assert_equal(exp_shared.total, 22.50, "Spese fisse pro-capite = 22.50 €")
	
	# Fine giornata con EndDaySystem
	var prev_balance: float = player.money
	end_day._on_day_ended(3)
	
	# Spese vive detratte: 22.50 €
	assert_equal(player.money, prev_balance - 22.50, "Detratte spese vive condivise a fine giornata (500 - 22.50 = 477.50)")

# 7. Istanziazione Scena UI AlbumCreator
func test_album_creator_ui_instantiation() -> void:
	print("\n7. Verifica Istanziazione Scena UI AlbumCreator:")
	var scene_res := load("res://ui/album/album_creator.tscn")
	assert_true(scene_res != null, "Risorsa album_creator.tscn caricata con successo")
	
	var instance = scene_res.instantiate()
	assert_true(instance != null, "Istanziazione AlbumCreator riuscita")
	
	var edit_title = instance.get_node_or_null("PanelMain/VBox/GridForm/EditTitle")
	var opt_type = instance.get_node_or_null("PanelMain/VBox/GridForm/OptAlbumType")
	var opt_concept = instance.get_node_or_null("PanelMain/VBox/GridForm/OptConcept")
	var opt_artwork = instance.get_node_or_null("PanelMain/VBox/GridForm/OptArtwork")
	var opt_lead = instance.get_node_or_null("PanelMain/VBox/GridForm/OptLeadSingle")
	var btn_pub = instance.get_node_or_null("PanelMain/VBox/HBoxBottom/BtnPublish")
	var btn_cls = instance.get_node_or_null("PanelMain/VBox/HBoxBottom/BtnClose")
	
	assert_true(edit_title != null, "EditTitle presente in AlbumCreator")
	assert_true(opt_type != null, "OptAlbumType presente in AlbumCreator")
	assert_true(opt_concept != null, "OptConcept presente in AlbumCreator")
	assert_true(opt_artwork != null, "OptArtwork presente in AlbumCreator")
	assert_true(opt_lead != null, "OptLeadSingle presente in AlbumCreator")
	assert_true(btn_pub != null, "BtnPublish presente in AlbumCreator")
	assert_true(btn_cls != null, "BtnClose presente in AlbumCreator")
	
	instance.queue_free()
