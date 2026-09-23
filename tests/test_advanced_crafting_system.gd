# res://tests/test_advanced_crafting_system.gd
extends Node

## Suite di Test Automatizzati per la Sezione 2: Creatività Musicale, Scrittura Brani & Produzione Discografica
## Copre: SongData (nuovi tratti e temi), LyricThemeData (10 temi e affinità genere),
## Formulas (theme affinity), MusicSystem (sconto Martedì 20%, hardware home studio cap, nuovi tratti),
## AlbumSystem (impatto tratti speciali su recensioni e vendite) e accessibilità UI Zero Mouse.

const LyricThemeData = preload("res://data/models/lyric_theme_data.gd")

var tests_passed: int = 0
var tests_failed: int = 0

func _ready() -> void:
	print("\n========================================================")
	print("   SUITE TEST AVANZATA: CREATIVITÀ & PRODUZIONE (SEZIONE 2)   ")
	print("========================================================\n")
	
	test_song_data_new_traits_and_themes()
	test_lyric_theme_data_and_affinities()
	test_quality_score_with_theme_affinity()
	test_tuesday_studio_discount()
	test_home_studio_hardware_caps()
	test_new_song_traits_in_single_and_album()
	test_crafting_resuming_and_draft_refining()
	test_ui_song_creator_and_catalog_accessibility()
	
	print("\n--------------------------------------------------------")
	print("ESITO COMPLESSIVO TEST SEZIONE 2 (CRAFTING AVANZATO):")
	print("  Test Superati: %d" % tests_passed)
	print("  Test Falliti:  %d" % tests_failed)
	print("--------------------------------------------------------\n")
	
	if tests_failed > 0:
		print("[ERRORE CRITICO] Alcuni test della Sezione 2 sono falliti!")
		get_tree().quit(1)
	else:
		print("[SUCCESSO] Tutti i test della Sezione 2 sono convalidati al 100%!")
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

# 1. Test SongData con Nuovi Tratti e Temi
func test_song_data_new_traits_and_themes() -> void:
	print("1. Verifica SongData Model, Nuovi Tratti e Tematiche Liriche:")
	var song := SongData.new("song_sec2", "Inno di Rivolta", Enums.MusicalGenre.ROCK, "social_anger")
	assert_eq(song.id, "song_sec2", "ID canzone corretto")
	assert_eq(song.theme, "social_anger", "Tema 'social_anger' impostato")
	assert_eq(song.get_theme_name(), tr("THEME_SOCIAL_ANGER"), "get_theme_name restituisce nome localizzato")
	
	# Test nuovi tratti
	song.special_trait = Enums.SongTrait.GENERATIONAL_ANTHEM
	assert_eq(song.get_trait_name(), tr("TRAIT_GENERATIONAL_ANTHEM"), "Nome tratto GENERATIONAL_ANTHEM localizzato")
	
	song.special_trait = Enums.SongTrait.TEARJERKER_BALLAD
	assert_eq(song.get_trait_name(), tr("TRAIT_TEARJERKER_BALLAD"), "Nome tratto TEARJERKER_BALLAD localizzato")
	
	song.special_trait = Enums.SongTrait.EPIC_RIFF
	assert_eq(song.get_trait_name(), tr("TRAIT_EPIC_RIFF"), "Nome tratto EPIC_RIFF localizzato")
	
	# Test serializzazione e deserializzazione con nuovo tratto
	var dict := song.to_dict()
	assert_eq(dict["theme"], "social_anger", "to_dict salva tema corretto")
	assert_eq(dict["special_trait"], Enums.SongTrait.EPIC_RIFF, "to_dict salva EPIC_RIFF")
	
	var loaded := SongData.new()
	loaded.from_dict(dict)
	assert_eq(loaded.theme, "social_anger", "from_dict ripristina tema")
	assert_eq(loaded.special_trait, Enums.SongTrait.EPIC_RIFF, "from_dict ripristina EPIC_RIFF")
	assert_eq(loaded.get_theme_name(), tr("THEME_SOCIAL_ANGER"), "from_dict mantiene localizzazione tema")

# 2. Test LyricThemeData e Affinità con Generi Musicali
func test_lyric_theme_data_and_affinities() -> void:
	print("\n2. Verifica LyricThemeData e Matrice di Affinità Genere-Tema:")
	var all_themes: Array = LyricThemeData.get_all_themes()
	assert_eq(all_themes.size(), 10, "Sono censiti 10 temi lirici completi")
	
	var anger_theme = LyricThemeData.get_theme_by_id("social_anger")
	assert_eq(anger_theme.id, "social_anger", "Trovato tema social_anger")
	assert_true(Enums.MusicalGenre.METAL in anger_theme.preferred_genres, "Metal è genere affine per social_anger")
	assert_true(Enums.MusicalGenre.POP in anger_theme.negative_genres, "Pop è genere contrastante per social_anger")
	
	# Verifica calcolo affinità
	var metal_aff: float = LyricThemeData.get_affinity_for_genre("social_anger", Enums.MusicalGenre.METAL)
	assert_eq(metal_aff, Constants.SONG_THEME_SYNERGY_HIGH, "Affinità Metal + social_anger è ALTA (+3.5)")
	
	var pop_aff: float = LyricThemeData.get_affinity_for_genre("social_anger", Enums.MusicalGenre.POP)
	assert_eq(pop_aff, Constants.SONG_THEME_SYNERGY_LOW, "Affinità Pop + social_anger è BASSA (-1.5)")
	
	var electro_aff: float = LyricThemeData.get_affinity_for_genre("social_anger", Enums.MusicalGenre.ELECTRONIC)
	assert_eq(electro_aff, Constants.SONG_THEME_SYNERGY_NEUTRAL, "Affinità Electronic + social_anger è NEUTRA (0.0)")
	
	# Test via Formulas wrapper
	var form_aff: float = Formulas.calculate_theme_genre_affinity("love", Enums.MusicalGenre.POP)
	assert_eq(form_aff, Constants.SONG_THEME_SYNERGY_HIGH, "Formulas.calculate_theme_genre_affinity restituisce +3.5 per Pop + love")

# 3. Test Calcolo Quality Score con Sinergia Tematica
func test_quality_score_with_theme_affinity() -> void:
	print("\n3. Verifica Calcolo Quality Score con Sinergia Tematica:")
	var q_neutral := Formulas.calculate_song_quality(40.0, 40.0, 40.0, 40.0, 0.0, 100.0, 0.0, 0.0)
	var q_synergy := Formulas.calculate_song_quality(40.0, 40.0, 40.0, 40.0, 0.0, 100.0, 0.0, 3.5)
	var q_penalty := Formulas.calculate_song_quality(40.0, 40.0, 40.0, 40.0, 0.0, 100.0, 0.0, -1.5)
	
	assert_true(q_synergy > q_neutral, "Sinergia tematica incrementa il Quality Score (%.1f > %.1f)" % [q_synergy, q_neutral])
	assert_eq(snappedf(q_synergy - q_neutral, 0.1), 3.5, "Incremento esattamente pari a +3.5 punti")
	assert_true(q_penalty < q_neutral, "Malus tematica riduce il Quality Score (%.1f < %.1f)" % [q_penalty, q_neutral])
	
	# Test clamp a estremi [1.0, 100.0]
	var q_clamped_max := Formulas.calculate_song_quality(100.0, 100.0, 100.0, 100.0, 50.0, 100.0, 4.0, 3.5)
	assert_eq(q_clamped_max, 100.0, "Quality Score clampato al massimo a 100.0")
	var q_clamped_min := Formulas.calculate_song_quality(1.0, 1.0, 1.0, 1.0, 0.0, 0.0, -4.0, -1.5)
	assert_eq(q_clamped_min, 1.0, "Quality Score clampato al minimo a 1.0")

# 4. Test Sconto Martedì Registrazione Studio Professionale
func test_tuesday_studio_discount() -> void:
	print("\n4. Verifica Sconto Martedì Studio Professionale (20% sconto):")
	var p := PlayerData.new()
	p.energy = 100
	var ss := SkillSystem.new(p)
	var cal := CalendarData.new()
	
	# Giorno 2 = Martedì: (2 - 1) % 7 = 1 = Enums.Weekday.TUESDAY
	cal.day_number = 2
	assert_eq(cal.get_weekday(), Enums.Weekday.TUESDAY, "Giorno 2 corrisponde a Martedì")
	
	var ms := MusicSystem.new(p, ss, cal)
	var song := ms.create_draft("Tuesday Song", Enums.MusicalGenre.ROCK, "social_anger")
	
	# Giocatore con 45 € a disposizione (basta per 40 €, ma non per 50 €)
	p.money = 45.0
	var rec_tuesday := ms.record_tracks(song, true)
	assert_true(rec_tuesday["success"], "Registrazione Pro Studio al Martedì riuscita con 45 €")
	assert_eq(p.money, 5.0, "Scalati 40.0 € invece di 50.0 € (saldo residuo 5.0 €)")
	assert_eq(song.studio_bonus, 15.0, "Studio bonus garantito a +15.0")
	
	# Giorno 3 = Mercoledì: (3 - 1) % 7 = 2 = Enums.Weekday.WEDNESDAY
	cal.day_number = 3
	assert_eq(cal.get_weekday(), Enums.Weekday.WEDNESDAY, "Giorno 3 corrisponde a Mercoledì")
	
	var song2 := ms.create_draft("Wednesday Song", Enums.MusicalGenre.POP, "love")
	p.money = 45.0 # Meno di 50 euro a prezzo pieno!
	var rec_wednesday := ms.record_tracks(song2, true)
	assert_eq(rec_wednesday["success"], false, "Registrazione Pro Studio di Mercoledì fallita per fondi insufficienti a 45 €")
	assert_eq(rec_wednesday["reason"], "money_insufficient", "Motivo fallimento: money_insufficient")
	
	# Ricarica fondi e registra a prezzo pieno di Mercoledì
	p.money = 60.0
	var rec_wednesday_ok := ms.record_tracks(song2, true)
	assert_true(rec_wednesday_ok["success"], "Registrazione Pro Studio di Mercoledì riuscita con 60 €")
	assert_eq(p.money, 10.0, "Scalati 50.0 € a tariffa piena (saldo residuo 10.0 €)")

# 5. Test Cap Esecutivo Hardware Home Studio
func test_home_studio_hardware_caps() -> void:
	print("\n5. Verifica Tetti Massimi Hardware Home Studio (Cap 60, 75, 90, 100):")
	var p := PlayerData.new()
	p.energy = 100
	p.money = 1000.0
	# Abilità strumento elevata (85)
	p.skills["instrument"]["level"] = 85
	var ss := SkillSystem.new(p)
	var ms := MusicSystem.new(p, ss)
	
	# Tier 0 (Basic Mic): Cap 60
	p.studio_hardware_tier = UpgradeData.StudioHardwareTier.BASIC_MIC
	var s0 := ms.create_draft("Demo 0", Enums.MusicalGenre.ROCK, "love")
	var r0 := ms.record_tracks(s0, false)
	assert_true(r0["success"], "Registrazione Home Studio Tier 0 completata")
	assert_eq(s0.exec_skill_used, 60.0, "Resa esecutiva limitata a Cap 60.0 nonostante abilità 85")
	assert_eq(s0.studio_bonus, 0.0, "Bonus studio Tier 0 pari a 0.0")
	
	# Tier 1 (USB Condenser): Cap 75, Bonus +5
	p.studio_hardware_tier = UpgradeData.StudioHardwareTier.USB_CONDENSER
	var s1 := ms.create_draft("Demo 1", Enums.MusicalGenre.ROCK, "love")
	var r1 := ms.record_tracks(s1, false)
	assert_true(r1["success"], "Registrazione Home Studio Tier 1 completata")
	assert_eq(s1.exec_skill_used, 75.0, "Resa esecutiva limitata a Cap 75.0")
	assert_eq(s1.studio_bonus, 5.0, "Bonus studio Tier 1 pari a +5.0")
	
	# Tier 2 (Tube Preamp): Cap 90, Bonus +10 (Abilità 85 < Cap 90, quindi non limitata)
	p.studio_hardware_tier = UpgradeData.StudioHardwareTier.TUBE_PREAMP
	var s2 := ms.create_draft("Demo 2", Enums.MusicalGenre.ROCK, "love")
	var r2 := ms.record_tracks(s2, false)
	assert_true(r2["success"], "Registrazione Home Studio Tier 2 completata")
	assert_eq(s2.exec_skill_used, 85.0, "Resa esecutiva piena a 85.0 (inferiore a Cap 90)")
	assert_eq(s2.studio_bonus, 10.0, "Bonus studio Tier 2 pari a +10.0")

# 6. Test Nuovi Tratti Canzone in Singolo e Album
func test_new_song_traits_in_single_and_album() -> void:
	print("\n6. Verifica Effetti Nuovi Tratti in Rilascio Singolo e Album:")
	var p := PlayerData.new()
	p.fans = 100
	p.reputation = 20.0
	p.morale = 60
	var ss := SkillSystem.new(p)
	var cal := CalendarData.new()
	var ms := MusicSystem.new(p, ss, cal)
	
	# Singolo con GENERATIONAL_ANTHEM
	var s_anthem := SongData.new("anthem_1", "Inno Generazione", Enums.MusicalGenre.ROCK, "rebellion")
	s_anthem.quality_score = 80.0
	s_anthem.status = Enums.SongStatus.PRODUCED
	s_anthem.special_trait = Enums.SongTrait.GENERATIONAL_ANTHEM
	p.add_song(s_anthem)
	
	var rel_res := ms.release_single(s_anthem.id)
	assert_true(rel_res["success"], "Rilascio singolo Anthem riuscito")
	assert_true(p.reputation > 24.0, "Reputazione potenziata da GENERATIONAL_ANTHEM (attuale: %.1f)" % p.reputation)
	
	# Singolo con TEARJERKER_BALLAD
	var s_ballad := SongData.new("ballad_1", "Lacrime Lente", Enums.MusicalGenre.INDIE, "melancholy")
	s_ballad.quality_score = 75.0
	s_ballad.status = Enums.SongStatus.PRODUCED
	s_ballad.special_trait = Enums.SongTrait.TEARJERKER_BALLAD
	p.add_song(s_ballad)
	
	var old_morale := p.morale
	ms.release_single(s_ballad.id)
	assert_eq(p.morale, old_morale + 10, "Morale giocatore incrementato di +10 da TEARJERKER_BALLAD")
	
	# Test metriche Album con tratti speciali
	var asys := AlbumSystem.new(p, cal)
	var s_riff := SongData.new("riff_1", "Solo Straordinario", Enums.MusicalGenre.METAL, "social_anger")
	s_riff.quality_score = 85.0
	s_riff.status = Enums.SongStatus.PRODUCED
	s_riff.special_trait = Enums.SongTrait.EPIC_RIFF
	p.add_song(s_riff)
	
	var track_ids: Array[String] = [s_anthem.id, s_ballad.id, s_riff.id]
	var metrics := asys.calculate_album_metrics(track_ids, s_anthem.id, Enums.AlbumConcept.CONCEPTUAL, Enums.ArtworkStyle.DARK_METAL, Enums.AlbumType.EP)
	assert_true(metrics["overall_quality"] > 80.0, "Qualità album potenziata da Lead Single Anthem e tratti speciali (%.1f)" % metrics["overall_quality"])
	assert_true(metrics["review_stars"] >= 4.0, "Valutazione critica positiva (stelle: %.1f)" % metrics["review_stars"])

# 7. Test Rielaborazione Bozze e Resuming
func test_crafting_resuming_and_draft_refining() -> void:
	print("\n7. Verifica Perfezionamento Bozze e Resuming:")
	var p := PlayerData.new()
	p.energy = 100
	var ss := SkillSystem.new(p)
	var ms := MusicSystem.new(p, ss)
	
	var draft := ms.create_draft("Bozza da Perfezionare", Enums.MusicalGenre.ROCK, "social_anger")
	assert_eq(draft.stage, Enums.SongStage.CONCEPT, "Bozza parte da CONCEPT")
	
	# Avanzamento a composizione
	ms.work_on_composition(draft, false)
	assert_eq(draft.stage, Enums.SongStage.COMPOSITION, "Bozza avanzata a COMPOSITION")
	
	# Aggiornamento titolo e tema durante la lavorazione
	draft.title = "Traccia Perfezionata"
	draft.theme = "cursed_love"
	assert_eq(draft.title, "Traccia Perfezionata", "Titolo bozza aggiornato con successo")
	assert_eq(draft.theme, "cursed_love", "Tema bozza aggiornato con successo")
	assert_eq(draft.get_theme_name(), tr("THEME_CURSED_LOVE"), "Nome tema localizzato corretto")
	
	# Avanzamento alle fasi successive
	ms.work_on_lyrics(draft)
	assert_eq(draft.stage, Enums.SongStage.SONGWRITING, "Bozza avanzata a SONGWRITING")
	
	ms.record_tracks(draft, false)
	assert_eq(draft.stage, Enums.SongStage.RECORDING, "Bozza avanzata a RECORDING")
	
	ms.mix_and_master(draft)
	assert_eq(draft.stage, Enums.SongStage.COMPLETED, "Bozza ultimata a COMPLETED")
	assert_eq(draft.status, Enums.SongStatus.PRODUCED, "Stato aggiornato a PRODUCED")
	assert_true(draft.quality_score > 0.0, "Punteggio di qualità generato (%.1f)" % draft.quality_score)

# 8. Test Istanziazione UI e Accessibilità Zero Mouse
func test_ui_song_creator_and_catalog_accessibility() -> void:
	print("\n8. Verifica Istanziazione UI e Accessibilità Zero Mouse:")
	var creator_scene: PackedScene = load("res://ui/music/song_creator.tscn")
	assert_true(creator_scene != null, "Risorsa song_creator.tscn caricata correttamente")
	var crt_inst: Node = creator_scene.instantiate()
	assert_true(crt_inst != null, "Istanziazione SongCreator riuscita")
	add_child(crt_inst)
	
	var opt_theme: OptionButton = crt_inst.find_child("OptTheme", true, false)
	assert_true(opt_theme != null, "Controllo OptTheme presente in SongCreator")
	assert_eq(opt_theme.item_count, 10, "OptTheme contiene tutti i 10 temi lirici")
	
	var opt_studio: OptionButton = crt_inst.find_child("OptStudio", true, false)
	assert_true(opt_studio != null, "Controllo OptStudio presente in SongCreator")
	assert_eq(opt_studio.item_count, 2, "OptStudio contiene 2 opzioni (Home e Pro Studio)")
	
	remove_child(crt_inst)
	crt_inst.free()
	
	var catalog_scene: PackedScene = load("res://ui/music/song_catalog.tscn")
	assert_true(catalog_scene != null, "Risorsa song_catalog.tscn caricata correttamente")
	var cat_inst: Node = catalog_scene.instantiate()
	assert_true(cat_inst != null, "Istanziazione SongCatalog riuscita")
	cat_inst.free()
