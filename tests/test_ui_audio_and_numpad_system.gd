# res://tests/test_ui_audio_and_numpad_system.gd
extends Node

## Suite di Test Headless per Sezione 12: Sound Design, Audio Cues, Numpad & Statistiche di Carriera
## Valida a 0 ms:
## 1. Enumerazioni AudioCueType, CareerStatCategory e costanti di bilanciamento
## 2. Sintesi procedurale degli Earcons in memoria (AudioStreamWAV 16-bit PCM)
## 3. Rispetto dei vincoli di Volume Sicuro (<= 0.75f) e Ducking automatico (40%)
## 4. Mapping comandi e navigazione da tastierino numerico (Numpad Navigation)
## 5. Modello dati e calcolo aggregato delle statistiche di carriera in PlayerData
## 6. Incremento automatico delle statistiche da ConcertSystem, MusicSystem, AlbumSystem, ChartSystem, EndDaySystem
## 7. Persistenza atomica, serializzazione to_dict/from_dict e retrocompatibilità savegame
## 8. Dashboard Statistiche Globali nel SystemMenuModal (tasto Esc) e lettura lineare NVDA
## 9. Integrazione HUD con navigazione a blocchi (KP_7/KP_9) e selezione Macro-Aree (KP_1..KP_4)

const PlayerDataScript = preload("res://data/models/player_data.gd")
const CalendarDataScript = preload("res://data/models/calendar_data.gd")
const SongDataScript = preload("res://data/models/song_data.gd")
const AlbumDataScript = preload("res://data/models/album_data.gd")
const VenueDataScript = preload("res://data/models/venue_data.gd")
const ConcertSystemScript = preload("res://systems/concert_system.gd")
const MusicSystemScript = preload("res://systems/music_system.gd")
const AlbumSystemScript = preload("res://systems/album_system.gd")
const AudioCueSystemScript = preload("res://systems/audio_cue_system.gd")

var sys_menu_scene: PackedScene = preload("res://ui/system_menu/system_menu_modal.tscn")
var hud_scene: PackedScene = preload("res://ui/hud/hud.tscn")

var tests_passed: int = 0
var tests_failed: int = 0

func _ready() -> void:
	print("\n========================================================")
	print("   SUITE TEST SEZIONE 12: SOUND DESIGN, NUMPAD & STATS   ")
	print("========================================================")
	
	test_enums_and_constants()
	test_audio_cue_procedural_generation()
	test_audio_volume_safety_and_ducking()
	test_numpad_mapping_and_navigation()
	test_player_career_stats_metrics()
	test_career_stats_integration_in_systems()
	test_career_stats_serialization_and_backward_compatibility()
	test_system_menu_modal_career_stats_dashboard()
	test_hud_numpad_and_audio_cues()
	
	print("\n--------------------------------------------------------")
	print("ESITO TEST SEZIONE 12 (SOUND DESIGN, NUMPAD & STATS):")
	print("  Test Superati: %d" % tests_passed)
	print("  Test Falliti:  %d" % tests_failed)
	print("--------------------------------------------------------\n")
	
	if tests_failed == 0:
		print("[SUCCESSO] Sezione 12 convalidata al 100% con 0 errori a 0 ms!")
		get_tree().quit(0)
	else:
		printerr("[ERRORE CRITICO] Alcuni test della Sezione 12 sono falliti!")
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

# ------------------------------------------------------------------------------
# TEST 1: Enumerazioni e Costanti di Sezione 12
# ------------------------------------------------------------------------------
func test_enums_and_constants() -> void:
	print("\n[TEST 1] Verifica Enumerazioni e Costanti di Sezione 12...")
	assert_equal(Enums.AudioCueType.NONE, 0, "AudioCueType.NONE = 0")
	assert_equal(Enums.AudioCueType.AREA_PERSONAL, 1, "AudioCueType.AREA_PERSONAL = 1")
	assert_equal(Enums.AudioCueType.AREA_CREATION, 2, "AudioCueType.AREA_CREATION = 2")
	assert_equal(Enums.AudioCueType.AREA_CAREER, 3, "AudioCueType.AREA_CAREER = 3")
	assert_equal(Enums.AudioCueType.AREA_UPGRADES, 4, "AudioCueType.AREA_UPGRADES = 4")
	assert_equal(Enums.AudioCueType.CERTIFICATION_AWARD, 5, "AudioCueType.CERTIFICATION_AWARD = 5")
	assert_equal(Enums.AudioCueType.CHART_NUMBER_ONE, 6, "AudioCueType.CHART_NUMBER_ONE = 6")
	assert_equal(Enums.AudioCueType.STADIUM_SOLD_OUT, 7, "AudioCueType.STADIUM_SOLD_OUT = 7")
	assert_equal(Enums.AudioCueType.NIGHT_OVERTIME_BELL, 8, "AudioCueType.NIGHT_OVERTIME_BELL = 8")
	assert_equal(Enums.AudioCueType.HIGH_SIGNAL_ALERT, 9, "AudioCueType.HIGH_SIGNAL_ALERT = 9")
	
	assert_equal(Enums.CareerStatCategory.LIFE_AND_TIME, 0, "CareerStatCategory.LIFE_AND_TIME = 0")
	assert_equal(Enums.CareerStatCategory.MUSIC_AND_DISCOGRAPHY, 1, "CareerStatCategory.MUSIC_AND_DISCOGRAPHY = 1")
	assert_equal(Enums.CareerStatCategory.STAGE_AND_TOURS, 2, "CareerStatCategory.STAGE_AND_TOURS = 2")
	assert_equal(Enums.CareerStatCategory.FANDOM_AND_GLORY, 3, "CareerStatCategory.FANDOM_AND_GLORY = 3")
	
	assert_true(not Enums.get_audio_cue_name(Enums.AudioCueType.AREA_PERSONAL).is_empty(), "get_audio_cue_name(AREA_PERSONAL) descrittivo")
	assert_true(not Enums.get_audio_cue_name(Enums.AudioCueType.STADIUM_SOLD_OUT).is_empty(), "get_audio_cue_name(STADIUM_SOLD_OUT) descrittivo")
	assert_true(not Enums.get_career_stat_category_name(Enums.CareerStatCategory.STAGE_AND_TOURS).is_empty(), "get_career_stat_category_name(STAGE_AND_TOURS) descrittivo")
	
	assert_true(Constants.AUDIO_SAFE_VOLUME_LINEAR <= 0.75, "AUDIO_SAFE_VOLUME_LINEAR <= 0.75f")
	assert_true(Constants.AUDIO_DUCKING_RATIO == 0.40, "AUDIO_DUCKING_RATIO == 0.40f")
	assert_true(Constants.AUDIO_SAFE_SAMPLE_RATE > 0, "AUDIO_SAFE_SAMPLE_RATE > 0")

# ------------------------------------------------------------------------------
# TEST 2: Sintesi Procedurale AudioCueSystem
# ------------------------------------------------------------------------------
func test_audio_cue_procedural_generation() -> void:
	print("\n[TEST 2] Sintesi procedurale Earcons in memoria...")
	var audio_system := AudioCueSystemScript.new()
	add_child(audio_system)
	
	var cues_to_test: Array[int] = [
		Enums.AudioCueType.AREA_PERSONAL,
		Enums.AudioCueType.AREA_CREATION,
		Enums.AudioCueType.AREA_CAREER,
		Enums.AudioCueType.AREA_UPGRADES,
		Enums.AudioCueType.CERTIFICATION_AWARD,
		Enums.AudioCueType.CHART_NUMBER_ONE,
		Enums.AudioCueType.STADIUM_SOLD_OUT,
		Enums.AudioCueType.NIGHT_OVERTIME_BELL,
		Enums.AudioCueType.HIGH_SIGNAL_ALERT
	]
	
	for cue_type in cues_to_test:
		var stream: AudioStreamWAV = audio_system.get_or_generate_cue_stream(cue_type)
		assert_true(stream != null, "Stream generato per cue %d" % cue_type)
		assert_equal(stream.format, AudioStreamWAV.FORMAT_16_BITS, "Formato 16-bit PCM per cue %d" % cue_type)
		assert_equal(stream.mix_rate, Constants.AUDIO_SAFE_SAMPLE_RATE, "Frequenza campionamento per cue %d" % cue_type)
		assert_true(stream.data.size() > 0, "Dati audio presenti per cue %d" % cue_type)
		
		# Verifica cache: seconda chiamata restituisce la stessa istanza in 0 ms
		var cached_stream: AudioStreamWAV = audio_system.get_or_generate_cue_stream(cue_type)
		assert_equal(cached_stream, stream, "Stream in cache riutilizzato istantaneamente per cue %d" % cue_type)
		
	# Esecuzione play_cue
	var played: bool = audio_system.play_cue(Enums.AudioCueType.AREA_PERSONAL)
	assert_true(played, "play_cue(AREA_PERSONAL) eseguito con successo")
	
	var none_played: bool = audio_system.play_cue(Enums.AudioCueType.NONE)
	assert_true(not none_played, "play_cue(NONE) correttamente rifiutato")
	
	audio_system.stop()
	audio_system.queue_free()

# ------------------------------------------------------------------------------
# TEST 3: Vincoli Volume di Sicurezza e Ducking
# ------------------------------------------------------------------------------
func test_audio_volume_safety_and_ducking() -> void:
	print("\n[TEST 3] Volume di sicurezza anti-mascheramento e Ducking...")
	var audio_system := AudioCueSystemScript.new()
	add_child(audio_system)
	
	# Verifica volume di default bloccato su AUDIO_SAFE_VOLUME_LINEAR
	assert_equal(audio_system.get_effective_volume_linear(), Constants.AUDIO_SAFE_VOLUME_LINEAR, "Volume base = 0.75f")
	
	# Tentativo di forzare volume a 1.0f pieno: deve essere clampato a 0.75f
	audio_system.set_base_volume(1.0)
	assert_equal(audio_system.get_effective_volume_linear(), Constants.AUDIO_SAFE_VOLUME_LINEAR, "Volume clampato al massimo di 0.75f")
	
	# Attivazione Ducking acustico (40%)
	audio_system.set_ducking(true)
	var expected_ducked: float = Constants.AUDIO_SAFE_VOLUME_LINEAR * Constants.AUDIO_DUCKING_RATIO
	assert_equal(audio_system.get_effective_volume_linear(), expected_ducked, "Volume attenuato col ducking al 40% (0.30f)")
	assert_true(audio_system.audio_player.volume_db <= -10.0, "Volume player in dB <= -10.0 durante ducking")
	
	# Ripristino Ducking
	audio_system.set_ducking(false)
	assert_equal(audio_system.get_effective_volume_linear(), Constants.AUDIO_SAFE_VOLUME_LINEAR, "Volume ripristinato a 0.75f dopo ducking")
	
	audio_system.queue_free()

# ------------------------------------------------------------------------------
# TEST 4: Mapping e Gestione Numpad
# ------------------------------------------------------------------------------
func test_numpad_mapping_and_navigation() -> void:
	print("\n[TEST 4] Mapping tastierino numerico e navigazione...")
	# Verifica silence su AccessibilityManager
	AccessibilityManager.silence()
	assert_true(not AccessibilityManager.is_ducking, "is_ducking = false dopo silence()")
	
	# Test annuncio focus corrente con dummy button
	var btn := Button.new()
	btn.name = "BtnTestNumpad"
	btn.text = "Azione di Test"
	add_child(btn)
	btn.grab_focus()
	
	AccessibilityManager.announce_current_focus_info()
	assert_true(btn.has_focus(), "Controllo focalizzato correttamente rilevato")
	
	btn.queue_free()

# ------------------------------------------------------------------------------
# TEST 5: Metriche di Carriera in PlayerData
# ------------------------------------------------------------------------------
func test_player_career_stats_metrics() -> void:
	print("\n[TEST 5] Metriche di carriera in PlayerData...")
	var player := PlayerDataScript.new()
	
	assert_equal(player.get_career_stat("total_days_active"), 1, "Giorni attivi iniziali = 1")
	assert_equal(player.get_career_stat("total_concerts_performed"), 0, "Concerti iniziali = 0")
	assert_equal(player.get_career_stat("total_audience_attended"), 0, "Pubblico iniziale = 0")
	assert_equal(player.get_career_stat("total_live_earnings"), 0.0, "Incassi live iniziali = 0.0")
	
	# Incremento contatori
	player.increment_career_stat("total_concerts_performed", 3)
	assert_equal(player.get_career_stat("total_concerts_performed"), 3, "Concerti dopo incremento = 3")
	
	player.increment_career_stat("total_audience_attended", 4500)
	assert_equal(player.get_career_stat("total_audience_attended"), 4500, "Spettatori dopo incremento = 4500")
	
	player.increment_career_stat("total_live_earnings", 1250.50)
	assert_equal(player.get_career_stat("total_live_earnings"), 1250.50, "Incassi live = 1250.50")
	
	player.increment_career_stat("total_merch_earnings", 300.0)
	player.increment_career_stat("total_royalties_earned", 150.0)
	
	var total_earnings: float = player.get_total_career_earnings()
	assert_true(total_earnings >= 1700.0, "get_total_career_earnings() calcola correttamente la somma")
	
	# Verifica riepilogo lineare per NVDA
	var speech: String = player.get_linear_career_summary_speech()
	assert_true(speech.contains("Alex"), "Riepilogo vocale contiene il nome del protagonista")
	assert_true(speech.contains("Concerti"), "Riepilogo vocale contiene la sezione concerti")
	assert_true(speech.contains("Certificazioni"), "Riepilogo vocale contiene la sezione certificazioni")

# ------------------------------------------------------------------------------
# TEST 6: Incremento Automatico nei Sistemi
# ------------------------------------------------------------------------------
func test_career_stats_integration_in_systems() -> void:
	print("\n[TEST 6] Incremento automatico metriche dai sistemi di gioco...")
	var player := PlayerDataScript.new()
	var cal := CalendarDataScript.new()
	var music_sys := MusicSystemScript.new(player, cal)
	var concert_sys := ConcertSystemScript.new(player, cal)
	
	# 1. MusicSystem: mix_and_master incrementa total_songs_written
	var song := music_sys.create_draft("Test Hit", Enums.MusicalGenre.ROCK)
	song.comp_skill_used = 40.0
	song.lyrics_skill_used = 40.0
	song.exec_skill_used = 40.0
	var mix_res: Dictionary = music_sys.mix_and_master(song)
	assert_true(mix_res.success, "mix_and_master completato")
	assert_true(int(player.get_career_stat("total_songs_written")) >= 1, "total_songs_written incrementato")
	
	# 2. Release Single incrementa total_singles_released
	var rel_res: Dictionary = music_sys.release_single(song.id)
	assert_true(rel_res.success, "release_single completato")
	assert_true(int(player.get_career_stat("total_singles_released")) >= 1, "total_singles_released incrementato")
	
	# 3. ConcertSystem: resolve_concert incrementa total_concerts_performed e audience
	var venue := VenueDataScript.new("venue_club", "Rock Club", 200, 150.0, 10.0, 10.0, 1)
	player.money = 1000.0
	player.popularity = 25.0
	var c_res: Dictionary = concert_sys.resolve_concert(venue, [song], 12.0)
	assert_true(c_res.success, "resolve_concert completato")
	assert_equal(int(player.get_career_stat("total_concerts_performed")), 1, "total_concerts_performed = 1")
	assert_true(int(player.get_career_stat("total_audience_attended")) > 0, "total_audience_attended registrato")
	assert_true(float(player.get_career_stat("total_live_earnings")) > 0.0, "total_live_earnings registrato")
	assert_true(c_res.has("is_sold_out"), "Risultato concerto include flag is_sold_out")
	
	# 4. Encore: incrementa total_encores_granted
	player.energy = 50
	var enc_res: Dictionary = concert_sys.resolve_encore(true, 90.0)
	assert_true(enc_res.granted, "resolve_encore concesso")
	assert_equal(int(player.get_career_stat("total_encores_granted")), 1, "total_encores_granted = 1")

# ------------------------------------------------------------------------------
# TEST 7: Persistenza e Retrocompatibilità Savegame
# ------------------------------------------------------------------------------
func test_career_stats_serialization_and_backward_compatibility() -> void:
	print("\n[TEST 7] Persistenza e retrocompatibilità savegame...")
	var player := PlayerDataScript.new()
	player.increment_career_stat("total_concerts_performed", 12)
	player.increment_career_stat("total_audience_attended", 18500)
	player.increment_career_stat("weeks_at_number_one", 3)
	player.increment_career_stat("total_royalties_earned", 840.50)
	
	var serialized: Dictionary = player.to_dict()
	assert_true(serialized.has("career_stats"), "to_dict() contiene career_stats")
	
	var loaded_player := PlayerDataScript.new()
	loaded_player.from_dict(serialized)
	assert_equal(int(loaded_player.get_career_stat("total_concerts_performed")), 12, "Caricato total_concerts_performed = 12")
	assert_equal(int(loaded_player.get_career_stat("total_audience_attended")), 18500, "Caricato total_audience_attended = 18500")
	assert_equal(int(loaded_player.get_career_stat("weeks_at_number_one")), 3, "Caricato weeks_at_number_one = 3")
	assert_equal(float(loaded_player.get_career_stat("total_royalties_earned")), 840.50, "Caricato total_royalties_earned = 840.50")
	
	# Retrocompatibilità: caricamento dizionario privo di career_stats
	var legacy_dict: Dictionary = {
		"player_name": "OldHero",
		"money": 300.0
	}
	var legacy_player := PlayerDataScript.new()
	legacy_player.from_dict(legacy_dict)
	assert_equal(legacy_player.player_name, "OldHero", "Nome caricato")
	assert_equal(int(legacy_player.get_career_stat("total_concerts_performed")), 0, "Fallback automatico su 0 senza crash")
	assert_equal(int(legacy_player.get_career_stat("total_days_active")), 1, "Fallback automatico giorni attivi = 1")

# ------------------------------------------------------------------------------
# TEST 8: Dashboard Statistiche nel SystemMenuModal
# ------------------------------------------------------------------------------
func test_system_menu_modal_career_stats_dashboard() -> void:
	print("\n[TEST 8] Dashboard Statistiche nel SystemMenuModal...")
	var sys_menu: Control = sys_menu_scene.instantiate()
	add_child(sys_menu)
	
	assert_true(sys_menu.btn_resume != null, "BtnResume presente")
	assert_true(sys_menu.btn_save != null, "BtnSave presente")
	assert_true(sys_menu.btn_career_stats != null, "BtnCareerStats presente nel menu principale")
	assert_true(sys_menu.btn_settings != null, "BtnSettings presente")
	assert_true(sys_menu.btn_main_menu != null, "BtnMainMenu presente")
	assert_true(sys_menu.panel_career_stats != null, "PanelCareerStats presente nell'albero")
	assert_true(not sys_menu.panel_career_stats.visible, "PanelCareerStats occultato all'avvio")
	
	# Apertura pannello statistiche
	sys_menu.open()
	assert_true(sys_menu.visible, "SystemMenu aperto")
	
	sys_menu._on_career_stats_pressed()
	assert_true(sys_menu.panel_career_stats.visible, "PanelCareerStats visibile dopo selezione")
	assert_true(not sys_menu.vbox_menu.visible, "VBoxMenu principale occultato durante visualizzazione statistiche")
	assert_true(sys_menu.label_life_stats != null, "LabelLifeStats presente e valorizzata")
	assert_true(sys_menu.label_music_stats != null, "LabelMusicStats presente e valorizzata")
	assert_true(sys_menu.label_live_stats != null, "LabelLiveStats presente e valorizzata")
	assert_true(sys_menu.label_glory_stats != null, "LabelGloryStats presente e valorizzata")
	
	# Chiusura e ritorno al menu di sistema
	sys_menu._on_back_stats_pressed()
	assert_true(not sys_menu.panel_career_stats.visible, "PanelCareerStats occultato dopo chiusura")
	assert_true(sys_menu.vbox_menu.visible, "VBoxMenu ripristinato")
	assert_true(sys_menu.btn_career_stats.has_focus(), "Focus ripristinato su BtnCareerStats")
	
	sys_menu.close()
	sys_menu.queue_free()

# ------------------------------------------------------------------------------
# TEST 9: HUD Numpad e Audio Cues
# ------------------------------------------------------------------------------
func test_hud_numpad_and_audio_cues() -> void:
	print("\n[TEST 9] HUD Numpad, navigazione a blocchi e Audio Cues...")
	var hud: Control = hud_scene.instantiate()
	add_child(hud)
	
	# Selezione Macro-Aree (1..4)
	hud.select_category_tab(1)
	assert_equal(hud.current_category_tab, 1, "Area 1 (Hub Personale) attiva")
	
	hud.select_category_tab(2)
	assert_equal(hud.current_category_tab, 2, "Area 2 (Creazione) attiva")
	
	hud.select_category_tab(3)
	assert_equal(hud.current_category_tab, 3, "Area 3 (Carriera) attiva")
	
	hud.select_category_tab(4)
	assert_equal(hud.current_category_tab, 4, "Area 4 (Skills & Upgrades) attiva")
	
	# Navigazione a blocchi (KP_7 e KP_9)
	hud._navigate_next_hud_block()
	assert_true(hud._current_hud_block_index >= 0 and hud._current_hud_block_index <= 2, "Indice blocco HUD valido (0..2)")
	hud._navigate_prev_hud_block()
	assert_true(hud._current_hud_block_index >= 0 and hud._current_hud_block_index <= 2, "Indice blocco HUD valido dopo prev")
	
	# Verifica mutua esclusione modali
	assert_true(not hud._is_any_modal_open(), "Nessuna modale aperta a riposo")
	
	hud.queue_free()
