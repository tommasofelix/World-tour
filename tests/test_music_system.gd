# res://tests/test_music_system.gd
extends Node

## Suite di Test Automatizzati per il Ciclo Creativo (Music Crafting) - Fase 3
## Copre: SongData, SkillSystem (7 abilità), MusicSystem (pipeline 5 fasi), Catalog Helpers e Release Singolo.

var tests_passed: int = 0
var tests_failed: int = 0

func _ready() -> void:
	print("\n========================================================")
	print("   SUITE TEST CICLO CREATIVO & MUSIC CRAFTING (FASE 3)   ")
	print("========================================================\n")
	
	test_song_data_model_and_serialization()
	test_skill_system_and_xp()
	test_player_data_catalog_methods()
	test_music_crafting_pipeline_5_stages()
	test_pro_studio_recording_costs()
	test_single_release_mechanics()
	test_song_traits_and_quality()
	test_ui_scenes_instantiation()
	
	print("\n--------------------------------------------------------")
	print("ESITO COMPLESSIVO TEST CICLO CREATIVO:")
	print("  Test Superati: %d" % tests_passed)
	print("  Test Falliti:  %d" % tests_failed)
	print("--------------------------------------------------------\n")
	
	if tests_failed > 0:
		print("[ERRORE CRITICO] Alcuni test del ciclo creativo sono falliti!")
		get_tree().quit(1)
	else:
		print("[SUCCESSO] Il sistema di Music Crafting e Ciclo Creativo è convalidato al 100%!")
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

# 1. Test SongData e Serializzazione
func test_song_data_model_and_serialization() -> void:
	print("1. Verifica SongData Model e Serializzazione:")
	var song := SongData.new("song_01", "Master of Puppets", Enums.MusicalGenre.METAL, "rebellion")
	assert_eq(song.id, "song_01", "ID canzone corretto")
	assert_eq(song.title, "Master of Puppets", "Titolo canzone corretto")
	assert_eq(song.genre, Enums.MusicalGenre.METAL, "Genere METAL impostato")
	assert_eq(song.theme, "rebellion", "Tema impostato")
	assert_eq(song.status, Enums.SongStatus.DRAFT, "Stato iniziale DRAFT")
	assert_eq(song.stage, Enums.SongStage.CONCEPT, "Fase iniziale CONCEPT")
	
	# Modifica proprietà
	song.quality_score = 88.5
	song.traits.append(Enums.SongTrait.EARWORM)
	song.recorded_in_pro_studio = true
	song.plays_count = 1500
	song.revenue_generated = 350.75
	
	# Serializzazione to_dict
	var dict := song.to_dict()
	assert_eq(dict["id"], "song_01", "to_dict['id'] presente")
	assert_eq(dict["title"], "Master of Puppets", "to_dict['title'] presente")
	assert_eq(dict["quality_score"], 88.5, "to_dict['quality_score'] presente")
	assert_eq(dict["recorded_in_pro_studio"], true, "to_dict['recorded_in_pro_studio'] presente")
	
	# Deserializzazione from_dict
	var loaded_song := SongData.new()
	loaded_song.from_dict(dict)
	assert_eq(loaded_song.id, "song_01", "from_dict ripristina id")
	assert_eq(loaded_song.title, "Master of Puppets", "from_dict ripristina title")
	assert_eq(loaded_song.genre, Enums.MusicalGenre.METAL, "from_dict ripristina genre")
	assert_eq(loaded_song.quality_score, 88.5, "from_dict ripristina quality_score")
	assert_eq(loaded_song.traits.size(), 1, "from_dict ripristina traits")
	assert_eq(loaded_song.traits[0], Enums.SongTrait.EARWORM, "from_dict ripristina tratto esatto")
	assert_eq(loaded_song.recorded_in_pro_studio, true, "from_dict ripristina recorded_in_pro_studio")
	assert_eq(loaded_song.plays_count, 1500, "from_dict ripristina plays_count")
	assert_eq(loaded_song.revenue_generated, 350.75, "from_dict ripristina revenue_generated")

# 2. Test SkillSystem e Crescita XP
func test_skill_system_and_xp() -> void:
	print("\n2. Verifica SkillSystem (7 abilità artistiche e formula XP):")
	var p := PlayerData.new()
	var ss := SkillSystem.new(p)
	
	# Verifica presenza delle 7 abilità artistiche
	var expected_skills := ["composition", "lyrics", "vocals", "guitar", "bass", "drums", "production"]
	for sk in expected_skills:
		assert_true(p.skills.has(sk), "Skill '%s' presente in PlayerData" % sk)
		assert_eq(p.skills[sk]["level"], 10, "Skill '%s' parte da livello base 10" % sk)
		assert_eq(p.skills[sk]["xp"], 0.0, "Skill '%s' parte da 0 XP" % sk)
		
	# Test calcolo XP necessario
	var xp_req_lvl10: float = Formulas.calculate_xp_for_level(10)
	var xp_req_lvl11: float = Formulas.calculate_xp_for_level(11)
	assert_true(xp_req_lvl11 > xp_req_lvl10, "XP richiesto per livello 11 è maggiore di livello 10 (curva esponenziale)")
	
	# Test aggiunta XP senza passaggio di livello
	var half_xp: float = float(xp_req_lvl10) * 0.5
	ss.add_xp("composition", half_xp)
	assert_eq(p.skills["composition"]["level"], 10, "Livello resta 10 se XP < soglia")
	assert_eq(p.skills["composition"]["xp"], half_xp, "XP accumulato correttamente a %.1f" % half_xp)
	
	# Test passaggio di livello ed emissione segnale EventBus
	var signal_received := {"leveled": false, "skill": "", "lvl": 0}
	var cb := func(s_key: String, n_lvl: int):
		signal_received["leveled"] = true
		signal_received["skill"] = s_key
		signal_received["lvl"] = n_lvl
	EventBus.skill_leveled_up.connect(cb)
	
	# Aggiungiamo XP sufficiente per scattare a livello 11
	ss.add_xp("composition", float(xp_req_lvl10) * 0.6) # Totale 1.1x soglia -> scatta livello 11
	assert_eq(p.skills["composition"]["level"], 11, "Livello salito a 11")
	assert_true(signal_received["leveled"], "Segnale EventBus.skill_leveled_up emesso")
	assert_eq(signal_received["skill"], "composition", "Skill corretta nel segnale")
	assert_eq(signal_received["lvl"], 11, "Nuovo livello corretto nel segnale")
	EventBus.skill_leveled_up.disconnect(cb)
	
	# Test Level Cap a 99
	p.skills["guitar"]["level"] = 99
	p.skills["guitar"]["xp"] = 0.0
	ss.add_xp("guitar", 999999.0)
	assert_eq(p.skills["guitar"]["level"], 99, "Livello bloccato al Cap di 99")

# 3. Test Metodi Catalogo in PlayerData
func test_player_data_catalog_methods() -> void:
	print("\n3. Verifica Metodi Helper Catalogo in PlayerData:")
	var p := PlayerData.new()
	assert_eq(p.songs.size(), 0, "Catalogo inizialmente vuoto")
	
	var s1 := SongData.new("s1", "Bozza 1", Enums.MusicalGenre.ROCK, "love")
	s1.status = Enums.SongStatus.DRAFT
	var s2 := SongData.new("s2", "Traccia Prodotta", Enums.MusicalGenre.POP, "night")
	s2.status = Enums.SongStatus.PRODUCED
	var s3 := SongData.new("s3", "Singolo Rilasciato", Enums.MusicalGenre.INDIE, "melancholy")
	s3.status = Enums.SongStatus.RELEASED
	
	p.add_song(s1)
	p.add_song(s2)
	p.add_song(s3)
	
	assert_eq(p.songs.size(), 3, "Tutti i 3 brani aggiunti al catalogo")
	assert_eq(p.get_song_by_id("s2").title, "Traccia Prodotta", "get_song_by_id restituisce la traccia corretta")
	assert_eq(p.get_drafts().size(), 1, "get_drafts restituisce 1 bozza")
	assert_eq(p.get_produced_songs().size(), 1, "get_produced_songs restituisce 1 traccia prodotta")
	assert_eq(p.get_released_singles().size(), 1, "get_released_singles restituisce 1 singolo rilasciato")
	
	# Verifica serializzazione catalogo in to_dict / from_dict di PlayerData
	var p_dict := p.to_dict()
	assert_true(p_dict.has("songs"), "to_dict include la chiave 'songs'")
	assert_eq((p_dict["songs"] as Array).size(), 3, "to_dict['songs'] contiene 3 elementi")
	
	var p_loaded := PlayerData.new()
	p_loaded.from_dict(p_dict)
	assert_eq(p_loaded.songs.size(), 3, "from_dict ripristina tutti i 3 brani")
	assert_eq(p_loaded.songs[0].title, "Bozza 1", "Titolo primo brano ripristinato")
	assert_eq(p_loaded.songs[1].status, Enums.SongStatus.PRODUCED, "Stato secondo brano ripristinato")

# 4. Test Pipeline Music Crafting a 5 Fasi
func test_music_crafting_pipeline_5_stages() -> void:
	print("\n4. Verifica Pipeline Music Crafting a 5 Fasi:")
	var p := PlayerData.new()
	p.energy = 100
	p.money = 500.0
	var ss := SkillSystem.new(p)
	var cal := CalendarData.new()
	var ms := MusicSystem.new(p, ss, cal)
	
	# Fase 1: Creazione Bozza
	var song := ms.create_draft("Stairway", Enums.MusicalGenre.ROCK, "melancholy")
	assert_true(song != null, "Creazione bozza riuscita")
	assert_eq(song.status, Enums.SongStatus.DRAFT, "Stato DRAFT")
	assert_eq(song.stage, Enums.SongStage.CONCEPT, "Fase CONCEPT")
	assert_eq(p.songs.size(), 1, "Canzone registrata in player_data")
	
	# Fase 2: Composizione
	var comp_res := ms.work_on_composition(song, false)
	assert_true(comp_res["success"], "Fase composizione completata")
	assert_eq(song.stage, Enums.SongStage.COMPOSITION, "Avanzamento a fase COMPOSITION")
	assert_eq(p.energy, 85, "Energia ridotta di 15 (100 -> 85)")
	assert_true(p.skills["composition"]["xp"] > 0, "XP guadagnato in composizione")
	
	# Fase 3: Scrittura Testo
	var lyr_res := ms.work_on_lyrics(song)
	assert_true(lyr_res["success"], "Fase scrittura testo completata")
	assert_eq(song.stage, Enums.SongStage.SONGWRITING, "Avanzamento a fase SONGWRITING")
	assert_eq(p.energy, 75, "Energia ridotta di 10 (85 -> 75)")
	assert_true(p.skills["songwriting"]["xp"] > 0, "XP guadagnato in songwriting")
	
	# Fase 4: Registrazione Tracce (Home Studio)
	var rec_res := ms.record_tracks(song, false)
	assert_true(rec_res["success"], "Fase registrazione tracce completata")
	assert_eq(song.stage, Enums.SongStage.RECORDING, "Avanzamento a fase RECORDING")
	assert_eq(p.energy, 50, "Energia ridotta di 25 (75 -> 50)")
	assert_eq(song.recorded_in_pro_studio, false, "Registrato in Home Studio")
	
	# Fase 5: Missaggio e Mastering
	var mix_res := ms.mix_and_master(song)
	assert_true(mix_res["success"], "Fase missaggio e mastering completata")
	assert_eq(song.stage, Enums.SongStage.COMPLETED, "Avanzamento a fase COMPLETED")
	assert_eq(song.status, Enums.SongStatus.PRODUCED, "Stato aggiornato a PRODUCED")
	assert_eq(p.energy, 35, "Energia ridotta di 15 (50 -> 35)")
	assert_true(song.quality_score > 0.0, "Punteggio di qualità calcolato (%.1f)" % song.quality_score)
	assert_true(p.skills["production"]["xp"] > 0, "XP guadagnato in produzione")

# 5. Test Registrazione in Pro Studio (costi e blocchi)
func test_pro_studio_recording_costs() -> void:
	print("\n5. Verifica Studio Professionale (costo 50 € e prerequisito fondi):")
	var p := PlayerData.new()
	p.energy = 100
	p.money = 30.0 # Meno di 50 euro!
	var ss := SkillSystem.new(p)
	var ms := MusicSystem.new(p, ss)
	
	var song := ms.create_draft("Hit Song", Enums.MusicalGenre.POP, "love")
	ms.work_on_composition(song)
	ms.work_on_lyrics(song)
	
	# Tentativo di registrare in Pro Studio senza fondi
	var fail_res := ms.record_tracks(song, true)
	assert_eq(fail_res["success"], false, "Registrazione fallita per fondi insufficienti")
	assert_eq(fail_res["reason"], "money_insufficient", "Motivo del fallimento: money_insufficient")
	
	# Ricarica fondi e riprova
	p.money = 100.0
	var success_res := ms.record_tracks(song, true)
	assert_eq(success_res["success"], true, "Registrazione Pro Studio riuscita con fondi sufficienti")
	assert_eq(p.money, 50.0, "Scalati 50.0 euro dal saldo (100 -> 50)")
	assert_eq(song.recorded_in_pro_studio, true, "Flag recorded_in_pro_studio impostato su true")

# 6. Test Rilascio Singolo (Economia, Fan e Mercato)
func test_single_release_mechanics() -> void:
	print("\n6. Verifica Rilascio Singolo (Bonus Fan, Introiti, Reputazione):")
	var p := PlayerData.new()
	p.energy = 100
	p.money = 200.0
	p.fans = 10
	p.reputation = 5.0
	var ss := SkillSystem.new(p)
	var cal := CalendarData.new()
	cal.day_number = 3
	var ms := MusicSystem.new(p, ss, cal)
	
	var song := ms.create_draft("Summer Hit", Enums.MusicalGenre.POP, "success")
	ms.work_on_composition(song)
	ms.work_on_lyrics(song)
	ms.record_tracks(song, false)
	ms.mix_and_master(song)
	
	assert_eq(song.status, Enums.SongStatus.PRODUCED, "Canzone pronta per la pubblicazione")
	
	var release_signal := {"released": false, "title": ""}
	var cb := func(data: Dictionary):
		release_signal["released"] = true
		release_signal["title"] = data.get("title", "")
	EventBus.song_released.connect(cb)
	
	var rel_res := ms.release_single(song.id)
	assert_true(rel_res["success"], "Rilascio singolo completato con successo")
	assert_eq(song.status, Enums.SongStatus.RELEASED, "Stato aggiornato a RELEASED")
	assert_eq(song.release_day, 3, "Giorno di rilascio memorizzato a 3")
	assert_true(p.fans > 10, "Fan stabili aumentati oltre 10 (attuali: %d)" % p.fans)
	assert_true(p.reputation > 5.0, "Reputazione aumentata oltre 5.0 (attuale: %.1f)" % p.reputation)
	assert_true(p.money > 200.0, "Introiti incassati per il rilascio (attuale: %.2f €)" % p.money)
	assert_true(release_signal["released"], "Segnale EventBus.song_released emesso")
	assert_eq(release_signal["title"], "Summer Hit", "Titolo corretto nel segnale")
	EventBus.song_released.disconnect(cb)
	
	# Tentativo di rilasciare una seconda volta la stessa traccia
	var duplicate_res := ms.release_single(song.id)
	assert_eq(duplicate_res["success"], false, "Impossibile rilasciare una traccia già pubblicata")

# 7. Test Tratti Musicali e Calcolo Qualità
func test_song_traits_and_quality() -> void:
	print("\n7. Verifica Calcolo Qualità e Tratti Emergenti:")
	var p := PlayerData.new()
	p.energy = 100
	var ss := SkillSystem.new(p)
	
	# Con skill al livello 1, la qualità base è ponderata al minimo
	var qual_lvl1 := Formulas.calculate_song_quality(1.0, 1.0, 1.0, 1.0, 0.0, 100.0, 0.0)
	assert_true(qual_lvl1 >= 1.0 and qual_lvl1 <= 15.0, "Qualità con skill liv. 1 compresa tra 1 e 15 (ottenuto: %.1f)" % qual_lvl1)
	
	# Con Pro Studio la qualità ha un bonus
	var qual_pro := Formulas.calculate_song_quality(1.0, 1.0, 1.0, 1.0, 15.0, 100.0, 0.0)
	assert_true(qual_pro > qual_lvl1, "Qualità con Pro Studio (%.1f) supera Home Studio (%.1f)" % [qual_pro, qual_lvl1])
	
	# Con skill elevate (livello 50 su tutte)
	var qual_high := Formulas.calculate_song_quality(50.0, 50.0, 50.0, 50.0, 15.0, 100.0, 0.0)
	assert_true(qual_high >= 50.0 and qual_high <= 65.0, "Qualità con skill a livello 50 compresa tra 50 e 65 (ottenuto: %.1f)" % qual_high)

# 8. Test Istanziazione Scena Catalogo e Creazione Brano
func test_ui_scenes_instantiation() -> void:
	print("\n8. Verifica Istanziazione Scene UI (SongCatalog e SongCreator):")
	var catalog_res: PackedScene = load("res://ui/music/song_catalog.tscn")
	assert_true(catalog_res != null, "Risorsa song_catalog.tscn caricata")
	var cat_inst: Node = catalog_res.instantiate()
	assert_true(cat_inst != null, "Istanziazione song_catalog riuscita")
	assert_true(cat_inst.find_child("BtnNewSong", true, false) != null, "BtnNewSong presente nel catalogo")
	assert_true(cat_inst.find_child("BtnClose", true, false) != null, "BtnClose presente nel catalogo")
	
	# Blindatura RRU-01: verifica generazione dinamica delle righe brano nel catalogo
	add_child(cat_inst)
	if GameManager and GameManager.player_data:
		var dummy_song := SongData.new("dummy_1", "Test Song Dynamic", Enums.MusicalGenre.ROCK, "love")
		dummy_song.status = Enums.SongStatus.PRODUCED
		dummy_song.quality_score = 75.0
		dummy_song.special_trait = Enums.SongTrait.EARWORM
		GameManager.player_data.add_song(dummy_song)
		cat_inst.refresh_catalog()
		var vbox_songs: VBoxContainer = cat_inst.find_child("VBoxSongs", true, false)
		assert_true(vbox_songs != null and vbox_songs.get_child_count() > 0, "Generazione dinamica riga brano in SongCatalog riuscita (RRU-01 verificata)")
		GameManager.player_data.songs.clear()
		
	remove_child(cat_inst)
	cat_inst.free()
	
	var creator_res: PackedScene = load("res://ui/music/song_creator.tscn")
	assert_true(creator_res != null, "Risorsa song_creator.tscn caricata")
	var crt_inst: Node = creator_res.instantiate()
	assert_true(crt_inst != null, "Istanziazione song_creator riuscita")
	assert_true(crt_inst.find_child("EditTitle", true, false) != null, "EditTitle presente nel creator")
	assert_true(crt_inst.find_child("OptGenre", true, false) != null, "OptGenre presente nel creator")
	assert_true(crt_inst.find_child("BtnAction", true, false) != null, "BtnAction presente nel creator")
	crt_inst.free()
