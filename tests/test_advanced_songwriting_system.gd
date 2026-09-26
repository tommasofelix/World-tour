# res://tests/test_advanced_songwriting_system.gd
extends Node

## Suite di Test Automatizzati per il Songwriting Artigianale, Doppia Barra,
## Punti Ispirazione, Finestra di Rifinitura Popomundo e Padronanza Live (AVF V5.9.0)
##
## Convalida headless deterministica a 0 ms:
## 1. Apertura cantiere e avanzamento doppia barra (Musica e Testo) con consumi e XP;
## 2. Attivazione finestra arancione al 100% (36h), decadimento orario e chiusura standard;
## 3. Tentativo Colpo d'Ala con Punti Ispirazione, Capolavoro Verde Brillante (+20 qualità) e Burnout Creativo;
## 4. Padronanza Live (20% -> 100%), Sinergia Strumento Dominante e Decay a 21 giorni;
## 5. Serializzazione atomica e persistenza Save/Load completa.

const CalendarData = preload("res://data/models/calendar_data.gd")
const PlayerData = preload("res://data/models/player_data.gd")
const SongData = preload("res://data/models/song_data.gd")
const VenueData = preload("res://data/models/venue_data.gd")
const MusicSystem = preload("res://systems/music_system.gd")
const SkillSystem = preload("res://systems/skill_system.gd")
const ConcertSystem = preload("res://systems/concert_system.gd")
const BandSystem = preload("res://systems/band_system.gd")
const EndDaySystem = preload("res://systems/end_day_system.gd")

var tests_passed: int = 0
var tests_failed: int = 0

func _ready() -> void:
	print("\n========================================================")
	print("   SUITE SONGWRITING ARTIGIANALE & RIFINITURA POPOMUNDO ")
	print("========================================================\n")

	test_crafting_project_and_double_bar_progress()
	test_orange_polishing_window_and_hourly_decay()
	test_polishing_burst_masterpiece_and_creative_burnout()
	test_live_mastery_and_dominant_instrument_synergy()
	test_serialization_and_save_load()

	print("\n--------------------------------------------------------")
	print("ESITO SUITE SONGWRITING ARTIGIANALE:")
	print("  Test Superati: %d" % tests_passed)
	print("  Test Falliti:  %d" % tests_failed)
	print("--------------------------------------------------------\n")

	if tests_failed > 0:
		print("[ERRORE CRITICO] Alcuni test di songwriting sono falliti!")
		get_tree().quit(1)
	else:
		print("[SUCCESSO] Songwriting artigianale, Ispirazione e Rifinitura convalidati al 100%!")
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

# 1. Apertura cantiere e avanzamento doppia barra (Musica e Testo) con consumi e XP
func test_crafting_project_and_double_bar_progress() -> void:
	print("\n1. Apertura Cantiere e Doppia Barra Musica/Testo:")
	var p := PlayerData.new()
	p.energy = 100
	p.stress = 0
	p.inspiration_points = 3
	var cal := CalendarData.new()
	var ss := SkillSystem.new(p)
	var ms := MusicSystem.new(p, ss, cal)

	# Avvio cantiere investendo 1 punto ispirazione
	var res := ms.start_crafting_project("Neon Skyline", Enums.MusicalGenre.ROCK, "rebellion", "guitar", "anthem", 1)
	assert_true(res["success"], "Cantiere 1 avviato con successo")
	assert_eq(p.inspiration_points, 2, "Punto ispirazione scalato correttamente (3 -> 2)")

	var song: SongData = res["song"]
	assert_eq(song.title, "Neon Skyline", "Titolo progetto assegnato")
	assert_eq(song.dominant_instrument, "guitar", "Strumento dominante 'guitar'")
	assert_eq(song.archetype, "anthem", "Archetipo 'anthem'")
	assert_eq(song.music_progress, 10.0, "Avanzamento musica iniziale 10% da slancio ispirazione (1 punto)")
	assert_eq(song.lyrics_progress, 10.0, "Avanzamento testo iniziale 10% da slancio ispirazione (1 punto)")
	assert_eq(song.mastery_live, 20.0, "Padronanza live iniziale a 20%")

	# Lavoro sulla musica
	var r_mus := ms.work_on_music_progress(song.id, 1.0)
	assert_true(r_mus["success"], "Sessione composizione musica eseguita")
	assert_true(song.music_progress > 10.0, "Barra musica avanzata (%.1f%%)" % song.music_progress)
	assert_eq(p.energy, 85, "Consumo 15 energia per composizione musica (100 -> 85)")
	assert_eq(p.stress, 4, "Stress incrementato di 4 per musica (0 -> 4)")

	# Lavoro sul testo
	var r_lyr := ms.work_on_lyrics_progress(song.id, 1.0)
	assert_true(r_lyr["success"], "Sessione scrittura testi eseguita")
	assert_true(song.lyrics_progress > 10.0, "Barra testo avanzata (%.1f%%)" % song.lyrics_progress)
	assert_eq(p.energy, 75, "Consumo 10 energia per scrittura testo (85 -> 75)")
	assert_eq(p.stress, 7, "Stress incrementato di 3 per testo (4 -> 7)")
	assert_eq(song.daily_lyrics_sessions, 1, "Sessioni giornaliere testo a 1")

	# Seconda sessione di musica (resa dimezzata 50%, stress maggiorato +6)
	var r_mus_2 := ms.work_on_music_progress(song.id, 1.0)
	assert_true(r_mus_2["success"], "Seconda sessione musica riuscita")
	assert_true(r_mus_2.get("is_second_session", false), "Flag is_second_session true")
	assert_eq(p.energy, 60, "Consumo 15 energia per seconda sessione (75 -> 60)")
	assert_eq(p.stress, 13, "Stress maggiorato di +6 per seconda sessione (7 -> 13)")
	assert_eq(song.daily_music_sessions, 2, "Sessioni musica registrate a 2")

	# Terza sessione di musica: deve essere respinta a costo zero (Popomundo Anti-Spam)
	var r_mus_3 := ms.work_on_music_progress(song.id, 1.0)
	assert_true(not r_mus_3["success"], "Terza sessione musica respinta")
	assert_eq(r_mus_3.get("reason", ""), "daily_limit_reached", "Motivo rifiuto: daily_limit_reached")
	assert_eq(p.energy, 60, "Energia intatta a costo zero (60)")
	assert_eq(p.stress, 13, "Stress intatto a costo zero (13)")
	assert_eq(song.daily_music_sessions, 2, "Contatore sessioni fermo a 2")

	# Apertura altri 2 cantieri fino al cap di 3 (Traccia 2 a zero ispirazione)
	var res2 := ms.start_crafting_project("Traccia 2", Enums.MusicalGenre.POP, "love")
	assert_true(res2["success"], "Cantiere 2 aperto")
	assert_eq(res2["song"].music_progress, 0.0, "Cantiere 2 parte da 0% senza ispirazione")

	# Traccia 2 ha contatori sessioni a 0: la musica può essere composta regolarmente (indipendenza bozze)
	var r_mus_t2 := ms.work_on_music_progress(res2["song"].id, 1.0)
	assert_true(r_mus_t2["success"], "Composizione su Traccia 2 riuscita nonostante Traccia 1 sia satura")
	assert_eq(res2["song"].daily_music_sessions, 1, "Traccia 2 a 1 sessione")
	assert_eq(song.daily_music_sessions, 2, "Traccia 1 ancora satura a 2 sessioni")

	# Reset notturno delle sessioni
	p.reset_all_song_daily_sessions()
	assert_eq(song.daily_music_sessions, 0, "Traccia 1 azzerata a 0 sessioni post-reset")
	assert_eq(res2["song"].daily_music_sessions, 0, "Traccia 2 azzerata a 0 sessioni post-reset")

	var res3 := ms.start_crafting_project("Traccia 3", Enums.MusicalGenre.METAL, "night")
	assert_true(res3["success"], "Cantiere 3 aperto")
	assert_eq(p.get_active_draft_songs().size(), 3, "Esattamente 3 cantieri aperti")

	# Tentativo 4° cantiere: deve essere respinto con cap_reached
	var res4 := ms.start_crafting_project("Traccia 4 Sovrannumero", Enums.MusicalGenre.INDIE, "melancholy")
	assert_true(not res4["success"], "4° cantiere respinto dal sistema")
	assert_eq(res4.get("reason", ""), "draft_cap_reached", "Motivo rifiuto: draft_cap_reached")

# 2. Attivazione finestra arancione al 100% (36h), decadimento orario e chiusura standard
func test_orange_polishing_window_and_hourly_decay() -> void:
	print("\n2. Finestra Arancione di Rifinitura e Decadimento Orario:")
	var p := PlayerData.new()
	p.energy = 100
	var cal := CalendarData.new()
	var ms := MusicSystem.new(p, null, cal)

	var res := ms.start_crafting_project("Golden Sunrise", Enums.MusicalGenre.ROCK, "love")
	var song: SongData = res["song"]

	# Portiamo quasi al completamento
	song.music_progress = 95.0
	song.lyrics_progress = 100.0
	assert_true(not song.is_orange_polishing(), "Non ancora in rifinitura arancione")

	# Sessione che porta la musica al 100%
	var r_mus := ms.work_on_music_progress(song.id, 1.0)
	assert_true(r_mus["success"], "Avanzamento musica eseguito")
	assert_eq(song.music_progress, 100.0, "Musica al 100%")
	assert_eq(song.polishing_status, 1, "Stato rifinitura ARANCIONE attivato")
	assert_eq(song.polishing_hours_remaining, 36.0, "Timer finestra arancione impostato a 36 ore")
	assert_true(song.is_orange_polishing(), "is_orange_polishing() restituisce true")

	# Decadimento orario di 10 ore
	ms.process_hourly_polishing_decay(10.0)
	assert_eq(song.polishing_hours_remaining, 26.0, "Rimanenti 26 ore virtuali")
	assert_eq(song.polishing_status, 1, "Ancora in stato arancione")

	# Decadimento che fa scadere le 36 ore
	ms.process_hourly_polishing_decay(30.0)
	assert_eq(song.polishing_status, 3, "Stato automaticamente convertito a STANDARD (3)")
	assert_eq(song.stage, Enums.SongStage.RECORDING, "Stadio avanzato a RECORDING per incisione")

	# Verifica chiusura manuale standard
	var res2 := ms.start_crafting_project("Silver Moon", Enums.MusicalGenre.POP, "love")
	var s2: SongData = res2["song"]
	s2.music_progress = 100.0
	s2.lyrics_progress = 100.0
	s2.polishing_status = 1
	s2.polishing_hours_remaining = 36.0

	var fin_res := ms.finalize_polishing_standard(s2.id)
	assert_true(fin_res["success"], "Chiusura standard riuscita")
	assert_eq(s2.polishing_status, 3, "Stato STANDARD consolidato")
	assert_eq(s2.stage, Enums.SongStage.RECORDING, "Pronto per la registrazione")

# 3. Tentativo Colpo d'Ala con Punti Ispirazione, Capolavoro Verde Brillante (+20 qualità) e Burnout Creativo
func test_polishing_burst_masterpiece_and_creative_burnout() -> void:
	print("\n3. Colpo d'Ala (Verde Brillante / Masterpiece) e Burnout Creativo:")
	var p := PlayerData.new()
	p.energy = 100
	p.stress = 0
	p.inspiration_points = 4
	p.musicality = 90
	var cal := CalendarData.new()
	var ms := MusicSystem.new(p, null, cal)

	var res := ms.start_crafting_project("Masterpiece Track", Enums.MusicalGenre.ROCK, "rebellion")
	var song: SongData = res["song"]
	song.music_progress = 100.0
	song.lyrics_progress = 100.0
	song.polishing_status = 1
	song.polishing_hours_remaining = 36.0

	# Tentativo Colpo d'Ala spendendo 2 punti ispirazione
	var burst_res := ms.attempt_polishing_burst(song.id, 2)
	assert_true(burst_res["success"], "Tentativo Colpo d'Ala eseguito")
	assert_eq(p.inspiration_points, 2, "2 punti ispirazione consumati (4 -> 2)")

	# Se ha avuto successo (oppure fallback controllato)
	if burst_res.get("is_masterpiece", false):
		assert_eq(song.polishing_status, 2, "Stato VERDE BRILLANTE (Masterpiece)")
		assert_true(song.is_masterpiece(), "is_masterpiece() restituisce true")
		assert_eq(burst_res["quality_bonus"], 20.0, "Bonus qualità +20.0")
		assert_eq(p.creative_burnout_days, 4, "Svuotamento creativo di 4 giorni attivato")
		assert_true(p.is_in_creative_burnout(), "is_in_creative_burnout() restituisce true")

		# Verifica impatto burnout su nuovo lavoro
		var res_burnout := ms.start_crafting_project("Traccia Post Burnout", Enums.MusicalGenre.ROCK, "love")
		assert_true(res_burnout.get("burnout_warning", false), "Warning burnout presente all'avvio")

		var s_post: SongData = res_burnout["song"]
		var stress_before := p.stress
		ms.work_on_music_progress(s_post.id, 1.0)
		assert_eq(p.stress - stress_before, 8, "Stress raddoppiato da burnout (+8 invece di +4)")
	else:
		assert_eq(song.polishing_status, 3, "Stato standard consolidato")
		assert_eq(burst_res["quality_bonus"], 5.0, "Bonus qualità standard +5.0")

# 4. Padronanza Live (20% -> 100%), Sinergia Strumento Dominante e Decay a 21 giorni
func test_live_mastery_and_dominant_instrument_synergy() -> void:
	print("\n4. Padronanza Live, Sinergia Strumento Dominante e Decay Repertorio:")
	var p := PlayerData.new()
	p.energy = 100
	p.money = 500.0
	p.skills["instrument"]["level"] = 25
	p.skills["performance"]["level"] = 25
	p.skills["charisma"]["level"] = 25
	p.skill_tree["skill_guitar"]["grade"] = 3 # Virtuoso chitarra per sinergia

	var cal := CalendarData.new()
	cal.day_number = 1
	var ss := SkillSystem.new(p)
	var cs := ConcertSystem.new(p, cal, ss)
	var bs := BandSystem.new(p, cal)
	var eds := EndDaySystem.new(p, cal)

	var s1 := SongData.new("live_song_01", "Live Anthem", Enums.MusicalGenre.ROCK, "rebellion")
	s1.status = Enums.SongStatus.PRODUCED
	s1.stage = Enums.SongStage.COMPLETED
	s1.quality_score = 80.0
	s1.mastery_live = 50.0
	s1.dominant_instrument = "guitar"
	s1.last_played_day = 1
	p.add_song(s1)

	# Brano al limite del floor (50%) per verificare che non decada mai sotto
	var s_floor := SongData.new("live_song_floor", "Floor Song", Enums.MusicalGenre.ROCK, "rebellion")
	s_floor.status = Enums.SongStatus.PRODUCED
	s_floor.stage = Enums.SongStage.COMPLETED
	s_floor.mastery_live = 50.0
	s_floor.last_played_day = 1
	p.add_song(s_floor)

	# Sessione di prove con la band (reclutiamo un compagno per abilitare le prove)
	var bm := BandMemberData.new("b1", "Jack", Enums.BandRole.BASS)
	p.band_members.append(bm)

	var reh_res := bs.hold_rehearsal_session()
	assert_true(reh_res["success"], "Sessione prove effettuata")
	assert_eq(s1.mastery_live, 65.0, "Padronanza live salita a 65% dopo le prove (50 -> 65)")

	# Esecuzione concerto live nel garage
	var venues: Array[VenueData] = VenueData.get_default_venues()
	var venue: VenueData = venues[0] # Garage
	var concert_res := cs.resolve_concert(venue, [s1], 10.0)
	assert_true(concert_res["success"], "Concerto live risolto con successo")
	assert_eq(s1.mastery_live, 80.0, "Padronanza live salita a 80% dopo il concerto (65 -> 80)")
	assert_eq(s1.last_played_day, 1, "last_played_day registrato a giorno 1")

	# Test Decay dopo oltre 21 giorni di inattività
	# Giorno 22: sono passati 21 giorni esatti (22 - 1 = 21, 21 % 7 == 0)
	s_floor.mastery_live = 50.0
	cal.day_number = 22
	eds.process_day_end(22)
	assert_eq(s1.mastery_live, 75.0, "Padronanza live scesa del 5% dopo 21 giorni di inattività (80 -> 75)")
	assert_eq(s_floor.mastery_live, 50.0, "Padronanza brano al floor rimane bloccata a 50% (nessun decay sotto 50%)")

	# Giorno 23 (22 giorni trascorsi, non divisibile per 7): nessun decadimento
	cal.day_number = 23
	eds.process_day_end(23)
	assert_eq(s1.mastery_live, 75.0, "Padronanza live invariata nel giorno infrasettimanale (75)")

# 5. Serializzazione atomica e persistenza Save/Load completa
func test_serialization_and_save_load() -> void:
	print("\n5. Serializzazione Atomica e Persistenza Save/Load:")
	var p1 := PlayerData.new()
	p1.inspiration_points = 4
	p1.max_inspiration_points = 7
	p1.creative_burnout_days = 3

	var s := SongData.new("serial_song_01", "Epic Symphony", Enums.MusicalGenre.METAL, "glory")
	s.music_progress = 85.5
	s.lyrics_progress = 92.0
	s.dominant_instrument = "bass"
	s.archetype = "anthem"
	s.complexity = 2
	s.polishing_status = 1
	s.polishing_hours_remaining = 24.5
	s.inspiration_invested = 2
	s.mastery_live = 65.0
	s.last_played_day = 14
	s.daily_music_sessions = 1
	s.daily_lyrics_sessions = 2
	p1.add_song(s)

	# Serializzazione
	var data: Dictionary = p1.to_dict()

	# Deserializzazione su nuova istanza pulita
	var p2 := PlayerData.new()
	p2.from_dict(data)

	assert_eq(p2.inspiration_points, 4, "Inspiration points persistiti (4)")
	assert_eq(p2.max_inspiration_points, 7, "Max inspiration points persistiti (7)")
	assert_eq(p2.creative_burnout_days, 3, "Creative burnout days persistiti (3)")
	assert_true(p2.is_in_creative_burnout(), "p2 risulta in creative burnout")

	var s_loaded: SongData = p2.get_song_by_id("serial_song_01")
	assert_true(s_loaded != null, "Canzone caricata con successo")
	assert_eq(s_loaded.title, "Epic Symphony", "Titolo persistito")
	assert_eq(s_loaded.music_progress, 85.5, "music_progress persistito (85.5)")
	assert_eq(s_loaded.lyrics_progress, 92.0, "lyrics_progress persistito (92.0)")
	assert_eq(s_loaded.dominant_instrument, "bass", "dominant_instrument persistito ('bass')")
	assert_eq(s_loaded.archetype, "anthem", "archetype persistito ('anthem')")
	assert_eq(s_loaded.complexity, 2, "complexity persistita (2)")
	assert_eq(s_loaded.polishing_status, 1, "polishing_status persistito (1 - Arancione)")
	assert_eq(s_loaded.polishing_hours_remaining, 24.5, "polishing_hours_remaining persistito (24.5)")
	assert_eq(s_loaded.inspiration_invested, 2, "inspiration_invested persistito (2)")
	assert_eq(s_loaded.mastery_live, 65.0, "mastery_live persistito (65.0)")
	assert_eq(s_loaded.last_played_day, 14, "last_played_day persistito (14)")
	assert_eq(s_loaded.daily_music_sessions, 1, "daily_music_sessions persistito (1)")
	assert_eq(s_loaded.daily_lyrics_sessions, 2, "daily_lyrics_sessions persistito (2)")
	assert_true(s_loaded.is_orange_polishing(), "is_orange_polishing() su brano caricato")
