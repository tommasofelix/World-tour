# res://tests/test_chart_rival_system.gd
extends Node

## Suite di Test Headless per Artisti Rivali & Classifiche Musicali (World-tour V4.0 / Fase 8.5)
## Valida il modulo ChartSystem, RivalSystem, i modelli ChartEntryData e RivalData,
## l'algoritmo di calcolo stream/vendite, i debutti, i movimenti di classifica, la conquista del #1,
## la resa vocale lineare per NVDA e la persistenza savegame.

const ChartEntryDataScript = preload("res://data/models/chart_entry_data.gd")
const RivalDataScript = preload("res://data/models/rival_data.gd")
const ChartSystemScript = preload("res://systems/chart_system.gd")
const RivalSystemScript = preload("res://systems/rival_system.gd")
const PlayerDataScript = preload("res://data/models/player_data.gd")
const CalendarDataScript = preload("res://data/models/calendar_data.gd")
const SongDataScript = preload("res://data/models/song_data.gd")
const AlbumDataScript = preload("res://data/models/album_data.gd")

var tests_passed: int = 0
var tests_failed: int = 0

func _ready() -> void:
	print("\n========================================================")
	print("   SUITE TEST ARTISTI RIVALI & CLASSIFICHE (F8.5)       ")
	print("========================================================")
	
	test_system_initialization()
	test_chart_entry_data_model()
	test_rival_data_model()
	test_rival_filtering_and_weekly_simulation()
	test_player_song_calculation_and_chart_entry()
	test_chart_debut_recognition()
	test_chart_movement_and_persistence()
	test_chart_number_one_achievement()
	test_linear_nvda_speech_accessibility()
	test_savegame_atomicity_and_deserialization()
	
	print("\n--------------------------------------------------------")
	print("ESITO COMPLESSIVO TEST RIVALI & CLASSIFICHE (F8.5):")
	print("  Test Superati: %d" % tests_passed)
	print("  Test Falliti:  %d" % tests_failed)
	print("--------------------------------------------------------\n")
	
	if tests_failed == 0:
		print("[SUCCESSO] Artisti Rivali & Classifiche Musicali (F8.5) convalidati al 100%!")
		get_tree().quit(0)
	else:
		printerr("[ERRORE CRITICO] Alcuni test del sistema classifiche/rivali sono falliti!")
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
# TEST 1: Inizializzazione RivalSystem e ChartSystem
# -------------------------------------------------------------
func test_system_initialization() -> void:
	print("\n[TEST 1] Inizializzazione RivalSystem e ChartSystem...")
	var rivals_sys := RivalSystemScript.new()
	assert_equal(rivals_sys.rivals.size(), 10, "Catalogo rivali contiene 10 band continentali predefinite")
	
	var player := PlayerDataScript.new()
	var cal := CalendarDataScript.new()
	var chart_sys := ChartSystemScript.new(player, cal, rivals_sys)
	
	assert_equal(chart_sys.top_singles.size(), 10, "Top 10 Singoli inizializzata con 10 posizioni")
	assert_equal(chart_sys.top_albums.size(), 10, "Top 10 Album inizializzata con 10 posizioni")
	assert_equal(chart_sys.top_singles[0].rank, 1, "Primo posto singoli ha rank 1")
	assert_equal(chart_sys.top_albums[0].rank, 1, "Primo posto album ha rank 1")
	assert_equal(chart_sys.last_updated_week, 1, "Settimana iniziale impostata a 1")

# -------------------------------------------------------------
# TEST 2: Modello Dati ChartEntryData
# -------------------------------------------------------------
func test_chart_entry_data_model() -> void:
	print("\n[TEST 2] Modello Dati ChartEntryData...")
	# New entry
	var e_new := ChartEntryDataScript.new(4, 0, "s_new", "Traccia Nuova", "The Rebels", true, Enums.MusicalGenre.ROCK, 25000, 1, 4)
	assert_true(e_new.is_new_entry(), "is_new_entry() ritorna true se previous_rank == 0")
	assert_equal(e_new.get_movement_delta(), 0, "Movement delta è 0 per new entry")
	assert_equal(e_new.get_movement_symbol(), "NEW", "Simbolo per new entry è 'NEW'")
	
	# Salita in classifica (da 7 a 3)
	var e_up := ChartEntryDataScript.new(3, 7, "s_up", "Traccia Up", "The Rebels", true, Enums.MusicalGenre.ROCK, 45000, 2, 3)
	assert_equal(e_up.get_movement_delta(), 4, "Movement delta calcola correttamente +4 posizioni")
	assert_equal(e_up.get_movement_symbol(), "▲ +4", "Simbolo salita è '▲ +4'")
	
	# Discesa in classifica (da 2 a 6)
	var e_down := ChartEntryDataScript.new(6, 2, "s_down", "Traccia Down", "The Rebels", true, Enums.MusicalGenre.ROCK, 18000, 3, 2)
	assert_equal(e_down.get_movement_delta(), -4, "Movement delta calcola correttamente -4 posizioni")
	assert_equal(e_down.get_movement_symbol(), "▼ -4", "Simbolo discesa è '▼ -4'")
	
	# Stabile
	var e_same := ChartEntryDataScript.new(5, 5, "s_same", "Traccia Same", "The Rebels", true, Enums.MusicalGenre.ROCK, 22000, 4, 3)
	assert_equal(e_same.get_movement_symbol(), "=", "Simbolo stabile è '='")

# -------------------------------------------------------------
# TEST 3: Modello Dati RivalData
# -------------------------------------------------------------
func test_rival_data_model() -> void:
	print("\n[TEST 3] Modello Dati RivalData...")
	var r := RivalDataScript.new(
		"r_test",
		"Test Band",
		Enums.MusicalGenre.METAL,
		Enums.CityId.LONDRA,
		Enums.CareerTier.INDIE_SENSATION,
		68.0,
		"Test Single",
		70.0,
		"Test Album",
		72.0,
		0
	)
	assert_equal(r.name, "Test Band", "Nome rivale corretto")
	assert_equal(r.genre, Enums.MusicalGenre.METAL, "Genere rivale corretto")
	assert_equal(r.home_city_id, Enums.CityId.LONDRA, "Città rivale Londra")
	assert_equal(r.rivalry_level, 0, "Rivalità iniziale 0 (Neutro)")
	
	r.rivalry_level = 2
	assert_equal(r.rivalry_level, 2, "Rivalità aggiornata a 2 (Faida accesa)")
	
	var r_dict := r.to_dict()
	assert_equal(r_dict.name, "Test Band", "Serializzazione to_dict corretta")
	var r_loaded := RivalDataScript.new()
	r_loaded.from_dict(r_dict)
	assert_equal(r_loaded.name, "Test Band", "Deserializzazione from_dict corretta")
	assert_equal(r_loaded.rivalry_level, 2, "Livello rivalità preservato nel ripristino")

# -------------------------------------------------------------
# TEST 4: Filtraggio Rivali per Città e Simulazione Settimanale
# -------------------------------------------------------------
func test_rival_filtering_and_weekly_simulation() -> void:
	print("\n[TEST 4] Filtraggio Rivali per Città e Simulazione Settimanale...")
	var rivals_sys := RivalSystemScript.new()
	
	var milano_rivals := rivals_sys.get_rivals_by_city(Enums.CityId.MILANO)
	assert_true(milano_rivals.size() >= 2, "Trovati almeno 2 rivali con sede a Milano")
	
	var r_chrome: RivalData = rivals_sys.get_rival("rival_chrome_shadows")
	assert_true(r_chrome != null, "The Chrome Shadows presente nel catalogo rivali")
	var initial_pop: float = r_chrome.popularity
	
	rivals_sys.simulate_weekly_performance()
	assert_true(r_chrome.popularity >= 10.0 and r_chrome.popularity <= 100.0, "Popolarità rivale rimane entro i limiti fisiologici [10 - 100]")

# -------------------------------------------------------------
# TEST 5: Calcolo Punteggio e Inclusione Brani del Giocatore
# -------------------------------------------------------------
func test_player_song_calculation_and_chart_entry() -> void:
	print("\n[TEST 5] Calcolo Punteggio e Inclusione Brani del Giocatore...")
	var player := PlayerDataScript.new()
	player.popularity = 50.0
	player.fans = 2000
	
	var s_top := SongDataScript.new("s_hit", "Riff Supremo", Enums.MusicalGenre.ROCK)
	s_top.status = Enums.SongStatus.PRODUCED
	s_top.quality_score = 90.0
	player.songs.append(s_top)
	
	var cal := CalendarDataScript.new()
	var rivals_sys := RivalSystemScript.new()
	var chart_sys := ChartSystemScript.new(player, cal, rivals_sys)
	
	var res := chart_sys.update_weekly_charts(7)
	assert_true(res.success, "Aggiornamento settimanale completato con successo")
	
	var player_singles := chart_sys.get_player_single_entries()
	assert_true(player_singles.size() > 0, "Il brano del giocatore è entrato nella Top 10 Singoli")
	assert_equal(player_singles[0].title, "Riff Supremo", "Titolo brano in classifica verificato")
	assert_true(player_singles[0].is_player, "Flag is_player valorizzato a true")

# -------------------------------------------------------------
# TEST 6: Riconoscimento Debutto in Classifica
# -------------------------------------------------------------
func test_chart_debut_recognition() -> void:
	print("\n[TEST 6] Riconoscimento Debutto in Classifica...")
	var player := PlayerDataScript.new()
	player.popularity = 60.0
	player.fans = 5000
	var initial_pop: float = player.popularity
	
	var s1 := SongDataScript.new("s_debut", "Primo Singolo Ufficiale", Enums.MusicalGenre.ROCK)
	s1.status = Enums.SongStatus.PRODUCED
	s1.quality_score = 85.0
	player.songs.append(s1)
	
	var cal := CalendarDataScript.new()
	var rivals_sys := RivalSystemScript.new()
	var chart_sys := ChartSystemScript.new(player, cal, rivals_sys)
	
	chart_sys.player_highest_single_rank = 999
	chart_sys.update_weekly_charts(7)
	
	var player_singles := chart_sys.get_player_single_entries()
	assert_true(player_singles.size() > 0, "Brano presente in classifica")
	assert_true(player_singles[0].is_new_entry(), "Il brano al debutto è contrassegnato come NEW")
	assert_true(player.popularity > initial_pop, "Bonus popolarità assegnato per il debutto in Top 10")
	assert_true(chart_sys.player_highest_single_rank <= 10, "player_highest_single_rank aggiornato correttamente")

# -------------------------------------------------------------
# TEST 7: Movimento in Classifica e Persistenza
# -------------------------------------------------------------
func test_chart_movement_and_persistence() -> void:
	print("\n[TEST 7] Movimento in Classifica e Persistenza...")
	var player := PlayerDataScript.new()
	player.popularity = 45.0
	
	var s := SongDataScript.new("s_move", "Traccia in Scalata", Enums.MusicalGenre.ROCK)
	s.status = Enums.SongStatus.PRODUCED
	s.quality_score = 70.0
	player.songs.append(s)
	
	var cal := CalendarDataScript.new()
	var rivals_sys := RivalSystemScript.new()
	var chart_sys := ChartSystemScript.new(player, cal, rivals_sys)
	
	# Settimana 1: ingresso
	chart_sys.update_weekly_charts(7)
	var e_week1: ChartEntryData = null
	for pe in chart_sys.get_player_single_entries():
		if pe.entry_id == "s_move":
			e_week1 = pe
			break
			
	assert_true(e_week1 != null, "Brano entrato in settimana 1")
	var rank_w1: int = e_week1.rank
	
	# Aumentiamo la popolarità del giocatore per la settimana 2 per far salire il brano
	player.popularity = 95.0
	s.quality_score = 98.0
	chart_sys.update_weekly_charts(14)
	
	var e_week2: ChartEntryData = null
	for pe in chart_sys.get_player_single_entries():
		if pe.entry_id == "s_move":
			e_week2 = pe
			break
			
	assert_true(e_week2 != null, "Brano mantenuto in settimana 2")
	assert_equal(e_week2.previous_rank, rank_w1, "previous_rank della settimana 2 corrisponde al rank della settimana 1")
	assert_equal(e_week2.weeks_on_chart, 2, "Settimane di permanenza incrementate a 2")
	assert_true(e_week2.rank <= rank_w1, "Posizione migliorata o mantenuta grazie alla spinta dei fan")

# -------------------------------------------------------------
# TEST 8: Conquista della Prima Posizione (#1 Hit)
# -------------------------------------------------------------
func test_chart_number_one_achievement() -> void:
	print("\n[TEST 8] Conquista della Prima Posizione (#1 Hit)...")
	var player := PlayerDataScript.new()
	player.popularity = 100.0 # Livello superstar
	player.fans = 50000
	
	var s_masterpiece := SongDataScript.new("s_number_one", "Masterpiece del Secolo", Enums.MusicalGenre.ROCK)
	s_masterpiece.status = Enums.SongStatus.PRODUCED
	s_masterpiece.quality_score = 100.0
	s_masterpiece.special_trait = Enums.SongTrait.EARWORM
	player.songs.append(s_masterpiece)
	
	var cal := CalendarDataScript.new()
	var rivals_sys := RivalSystemScript.new()
	var chart_sys := ChartSystemScript.new(player, cal, rivals_sys)
	
	chart_sys.update_weekly_charts(7)
	assert_equal(chart_sys.top_singles[0].entry_id, "s_number_one", "La traccia ha conquistato la posizione #1 assoluta")
	assert_equal(chart_sys.top_singles[0].rank, 1, "Rank verificato a 1")
	assert_true(chart_sys.weeks_at_number_one >= 1, "weeks_at_number_one registrato a 1 o superiore")

# -------------------------------------------------------------
# TEST 9: Resa Vocale Lineare NVDA
# -------------------------------------------------------------
func test_linear_nvda_speech_accessibility() -> void:
	print("\n[TEST 9] Resa Vocale Lineare NVDA...")
	var player := PlayerDataScript.new()
	var cal := CalendarDataScript.new()
	var rivals_sys := RivalSystemScript.new()
	var chart_sys := ChartSystemScript.new(player, cal, rivals_sys)
	
	var speech_singles: String = chart_sys.get_charts_speech(0)
	var speech_albums: String = chart_sys.get_charts_speech(1)
	
	assert_true(speech_singles.contains("Top 10 Singoli"), "Speech singoli contiene intestazione corretta")
	assert_true(speech_albums.contains("Top 10 Album"), "Speech album contiene intestazione corretta")
	assert_true(speech_singles.contains("Posizione 1:"), "Speech descrive posizione 1")
	assert_true(not speech_singles.contains("|") and not speech_singles.contains("---"), "Speech privo di box ASCII complessi o tabelle 2D")

# -------------------------------------------------------------
# TEST 10: Serializzazione Atomica e Ripristino Savegame
# -------------------------------------------------------------
func test_savegame_atomicity_and_deserialization() -> void:
	print("\n[TEST 10] Serializzazione Atomica e Ripristino Savegame...")
	var player := PlayerDataScript.new()
	var cal := CalendarDataScript.new()
	var rivals_sys := RivalSystemScript.new()
	var chart_sys := ChartSystemScript.new(player, cal, rivals_sys)
	
	chart_sys.last_updated_week = 5
	chart_sys.player_highest_single_rank = 2
	chart_sys.player_highest_album_rank = 3
	chart_sys.weeks_at_number_one = 2
	
	var save_dict := chart_sys.to_dict()
	assert_equal(save_dict.last_updated_week, 5, "Serializzazione last_updated_week corretta")
	assert_equal(save_dict.player_highest_single_rank, 2, "Serializzazione player_highest_single_rank corretta")
	assert_equal(save_dict.weeks_at_number_one, 2, "Serializzazione weeks_at_number_one corretta")
	assert_equal(save_dict.top_singles.size(), 10, "Serializzazione top_singles a 10 elementi")
	
	# Deserializzazione su nuova istanza
	var loaded_chart_sys := ChartSystemScript.new(player, cal, rivals_sys)
	loaded_chart_sys.from_dict(save_dict)
	
	assert_equal(loaded_chart_sys.last_updated_week, 5, "Deserializzazione last_updated_week ripristinata")
	assert_equal(loaded_chart_sys.player_highest_single_rank, 2, "Deserializzazione player_highest_single_rank ripristinata")
	assert_equal(loaded_chart_sys.weeks_at_number_one, 2, "Deserializzazione weeks_at_number_one ripristinata")
	assert_equal(loaded_chart_sys.top_singles.size(), 10, "Deserializzazione top_singles ripristinata a 10 elementi")
	assert_equal(loaded_chart_sys.top_singles[0].rank, 1, "Rank del primo elemento ripristinato")
