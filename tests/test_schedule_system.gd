# res://tests/test_schedule_system.gd
extends Node

## Suite di Test Headless per il Calendario Sistemico & Agenda della Band (World-tour V4.0 / SP-09)
## Valida le formule del calendario lunare a 28 giorni, i giorni della settimana,
## le stagioni, gli impegni a calendario, le scadenze e i moltiplicatori del weekend.

const ScheduleSystemScript = preload("res://systems/schedule_system.gd")
const CalendarEventDataScript = preload("res://data/models/calendar_event_data.gd")
const CalendarDataScript = preload("res://data/models/calendar_data.gd")
const ConcertSystemScript = preload("res://systems/concert_system.gd")
const VenueDataScript = preload("res://data/models/venue_data.gd")
const SongDataScript = preload("res://data/models/song_data.gd")

var tests_passed: int = 0
var tests_failed: int = 0

func _ready() -> void:
	print("\n========================================================")
	print("   SUITE TEST CALENDARIO SISTEMICO & AGENDA (SP-09)     ")
	print("========================================================")
	
	test_calendar_math_and_28_day_cycles()
	test_calendar_event_model()
	test_schedule_system_core()
	test_concert_and_album_deadlines()
	test_daily_schedule_check_and_missed_events()
	test_weekend_concert_multipliers()
	test_linear_nvda_agenda_speech()
	test_serialization_and_save_load()
	
	print("\n--------------------------------------------------------")
	print("ESITO COMPLESSIVO TEST CALENDARIO & AGENDA:")
	print("  Test Superati: %d" % tests_passed)
	print("  Test Falliti:  %d" % tests_failed)
	print("--------------------------------------------------------\n")
	
	if tests_failed == 0:
		print("[SUCCESSO] Il Calendario Sistemico & Agenda Band (SP-09) è convalidato al 100%!")
		get_tree().quit(0)
	else:
		printerr("[ERRORE CRITICO] Alcuni test del calendario sono falliti!")
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

# 1. Matematica del Tempo: Convenzione Lunare a 28 Giorni
func test_calendar_math_and_28_day_cycles() -> void:
	print("\n1. Test Cicli Temporali a 28 Giorni, Settimane e Stagioni:")
	var cal = CalendarDataScript.new()
	
	# Giorno 1: Lunedì, 1 Gennaio, Anno 1, Primavera
	cal.day_number = 1
	assert_equal(cal.get_weekday(), Enums.Weekday.MONDAY, "Giorno 1 è Lunedì")
	assert_equal(cal.get_weekday_name(), "Lunedì", "Nome giorno 1: Lunedì")
	assert_equal(cal.get_day_of_month(), 1, "Giorno del mese: 1")
	assert_equal(cal.get_month(), 1, "Mese 1")
	assert_equal(cal.get_month_name(), "Gennaio", "Gennaio")
	assert_equal(cal.get_season(), Enums.Season.SPRING, "Stagione: Primavera")
	assert_equal(cal.get_year(), 1, "Anno 1")
	assert_equal(cal.is_weekend(), false, "Lunedì non è weekend")
	assert_equal(cal.is_prime_time(), false, "Lunedì non è prime time")
	
	# Giorno 5: Venerdì
	cal.day_number = 5
	assert_equal(cal.get_weekday(), Enums.Weekday.FRIDAY, "Giorno 5 è Venerdì")
	assert_equal(cal.is_prime_time(), true, "Venerdì è Prime Time")
	assert_equal(cal.is_weekend(), false, "Venerdì non è weekend pieno")
	
	# Giorno 6: Sabato
	cal.day_number = 6
	assert_equal(cal.get_weekday(), Enums.Weekday.SATURDAY, "Giorno 6 è Sabato")
	assert_equal(cal.is_weekend(), true, "Sabato è weekend")
	assert_equal(cal.is_prime_time(), true, "Sabato è prime time")
	
	# Giorno 28: Domenica (Fine Mese 1)
	cal.day_number = 28
	assert_equal(cal.get_weekday(), Enums.Weekday.SUNDAY, "Giorno 28 è Domenica")
	assert_equal(cal.get_day_of_month(), 28, "Giorno 28 del mese")
	assert_equal(cal.get_month(), 1, "Ancora Mese 1")
	assert_equal(cal.is_end_of_month(), true, "Giorno 28 è fine mese")
	
	# Giorno 29: Lunedì 1 Febbraio (Inizio Mese 2)
	cal.day_number = 29
	assert_equal(cal.get_weekday(), Enums.Weekday.MONDAY, "Giorno 29 è Lunedì (Inizio nuovo mese)")
	assert_equal(cal.get_day_of_month(), 1, "Giorno 1 del nuovo mese")
	assert_equal(cal.get_month(), 2, "Mese 2 (Febbraio)")
	assert_equal(cal.get_month_name(), "Febbraio", "Febbraio")
	assert_equal(cal.get_season(), Enums.Season.SPRING, "Mese 2 è ancora Primavera")
	
	# Giorno 85: Mese 4 (Estate) -> 3 mesi * 28 = 84 giorni
	cal.day_number = 85
	assert_equal(cal.get_day_of_month(), 1, "Giorno 85 è Giorno 1 del Mese 4")
	assert_equal(cal.get_month(), 4, "Mese 4 (Aprile)")
	assert_equal(cal.get_season(), Enums.Season.SUMMER, "Mese 4 è Estate")
	assert_equal(cal.get_season_name(), "Estate", "Nome stagione: Estate")
	
	# Anno 2: Giorno 337 (336 giorni per anno)
	cal.day_number = 337
	assert_equal(cal.get_year(), 2, "Giorno 337 entra nell'Anno 2")
	assert_equal(cal.get_month(), 1, "Ritorna a Mese 1 del nuovo anno")

# 2. Modello CalendarEventData
func test_calendar_event_model() -> void:
	print("\n2. Test Modello CalendarEventData:")
	var ev = CalendarEventDataScript.new(
		"ev_live_01",
		"Live al Velvet Club",
		Enums.CalendarEventType.CONCERT,
		12,
		Enums.TimePeriod.EVENING,
		"venue_velvet",
		"Velvet Club",
		true
	)
	assert_equal(ev.id, "ev_live_01", "ID evento impostato")
	assert_equal(ev.title, "Live al Velvet Club", "Titolo impostato")
	assert_equal(ev.event_type, Enums.CalendarEventType.CONCERT, "Tipo CONCERT")
	assert_equal(ev.day_number, 12, "Giorno 12")
	assert_equal(ev.period, Enums.TimePeriod.EVENING, "Fascia Sera")
	assert_equal(ev.is_critical, true, "Evento critico")
	assert_true(ev.get_summary_string().contains("Concerto Live"), "Summary contiene tipo evento")
	
	# Serializzazione
	var d = ev.to_dict()
	var ev_clone = CalendarEventDataScript.new()
	ev_clone.from_dict(d)
	assert_equal(ev_clone.id, ev.id, "Clone ID coincidente")
	assert_equal(ev_clone.title, ev.title, "Clone Title coincidente")
	assert_equal(ev_clone.is_critical, true, "Clone is_critical coincidente")

# 3. Motore ScheduleSystem
func test_schedule_system_core() -> void:
	print("\n3. Test Motore ScheduleSystem (Ordinamento, Query, Aggiunta e Rimozione):")
	var cal = CalendarDataScript.new()
	cal.day_number = 5
	var schedule = ScheduleSystemScript.new(null, cal)
	
	var ev1 = CalendarEventDataScript.new("e1", "Evento Giorno 10", Enums.CalendarEventType.REHEARSAL, 10, Enums.TimePeriod.AFTERNOON)
	var ev2 = CalendarEventDataScript.new("e2", "Evento Giorno 7", Enums.CalendarEventType.CONCERT, 7, Enums.TimePeriod.EVENING)
	var ev3 = CalendarEventDataScript.new("e3", "Evento Giorno 7 Pomeriggio", Enums.CalendarEventType.STUDIO_BOOKING, 7, Enums.TimePeriod.AFTERNOON)
	
	schedule.add_event(ev1)
	schedule.add_event(ev2)
	schedule.add_event(ev3)
	
	# Ordinamento cronologico automatico: prima giorno 7 pom, poi giorno 7 sera, poi giorno 10
	assert_equal(schedule.events[0].id, "e3", "Primo evento ordinato: e3 (Giorno 7 Pomeriggio)")
	assert_equal(schedule.events[1].id, "e2", "Secondo evento ordinato: e2 (Giorno 7 Sera)")
	assert_equal(schedule.events[2].id, "e1", "Terzo evento ordinato: e1 (Giorno 10)")
	
	# Query per giorno
	var day_7_events = schedule.get_events_for_day(7)
	assert_equal(day_7_events.size(), 2, "2 eventi trovati per il Giorno 7")
	
	# Query per periodo
	var day_7_eve = schedule.get_events_for_period(7, Enums.TimePeriod.EVENING)
	assert_equal(day_7_eve.size(), 1, "1 evento sera per il Giorno 7")
	assert_equal(day_7_eve[0].id, "e2", "Evento sera è e2")
	
	# has_event_at
	assert_equal(schedule.has_event_at(7, Enums.TimePeriod.EVENING), true, "has_event_at(7, Evening) == true")
	assert_equal(schedule.has_event_at(7, Enums.TimePeriod.MORNING), false, "has_event_at(7, Morning) == false")
	
	# Query imminenti (dal giorno 5 in poi)
	var upcoming = schedule.get_upcoming_events(5) # giorni 5..10
	assert_equal(upcoming.size(), 3, "Tutti e 3 gli eventi sono imminenti nei prossimi 5 giorni")
	
	# Rimozione
	var removed = schedule.remove_event("e3")
	assert_equal(removed, true, "e3 rimosso con successo")
	assert_equal(schedule.events.size(), 2, "Rimangono 2 eventi")

# 4. Scadenze e Prenotazioni
func test_concert_and_album_deadlines() -> void:
	print("\n4. Test Prenotazione Concerti, Scadenze Album e Affitto:")
	var cal = CalendarDataScript.new()
	cal.day_number = 3
	var schedule = ScheduleSystemScript.new(null, cal)
	
	# Prenotazione concerto tra 4 giorni (giorno 7)
	var concert_ev = schedule.book_concert_date("venue_matrix", "Matrix Club", 4)
	assert_equal(concert_ev.day_number, 7, "Concerto fissato per il Giorno 7")
	assert_equal(concert_ev.location_id, "venue_matrix", "Locale: venue_matrix")
	assert_equal(concert_ev.is_critical, true, "Concerto concordato è critico")
	
	# Scadenza album Major tra 56 giorni (giorno 59)
	var album_ev = schedule.schedule_album_deadline("Rising Storm", 56, "Apex Global Records")
	assert_equal(album_ev.day_number, 59, "Deadline fissata a giorno 59")
	assert_equal(album_ev.event_type, Enums.CalendarEventType.CONTRACT_DEADLINE, "Tipo CONTRACT_DEADLINE")
	
	# Affitto mensile automatico per il Mese 1 (giorno 28)
	schedule.ensure_monthly_rent_scheduled()
	var rent_ev = schedule.get_event_by_id("rent_month_1_year_1")
	assert_true(rent_ev != null, "Evento affitto mensile creato")
	if rent_ev:
		assert_equal(rent_ev.day_number, 28, "Affitto fissato al giorno 28 di fine mese")

# 5. Controllo Giornaliero ed Eventi Mancati
func test_daily_schedule_check_and_missed_events() -> void:
	print("\n5. Test Controllo Giornaliero e Penalità per Eventi Mancati:")
	var player = PlayerData.new()
	player.reputation = 20.0
	player.morale = 80
	player.stress = 10
	
	var cal = CalendarDataScript.new()
	cal.day_number = 5
	
	var schedule = ScheduleSystemScript.new(player, cal)
	
	# Evento critico non completato fissato per il giorno 4 (ieri)
	var ev_missed = CalendarEventDataScript.new("e_yesterday", "Live Ieri", Enums.CalendarEventType.CONCERT, 4, Enums.TimePeriod.EVENING, "", "", true)
	schedule.add_event(ev_missed)
	
	# Evento di oggi (giorno 5)
	var ev_today = CalendarEventDataScript.new("e_today", "Prove Oggi", Enums.CalendarEventType.REHEARSAL, 5, Enums.TimePeriod.AFTERNOON)
	schedule.add_event(ev_today)
	
	var report = schedule.process_daily_schedule_check(5)
	assert_equal(report.get("missed_count", 0), 1, "Rilevato 1 evento critico mancato ieri")
	assert_equal(report.get("todays_events_count", 0), 1, "Rilevato 1 evento per oggi")
	assert_true(player.reputation < 20.0, "Reputazione diminuita per evento mancato")
	assert_true(player.stress > 10, "Stress aumentato per evento mancato")

# 6. Moltiplicatori Weekend su ConcertSystem
func test_weekend_concert_multipliers() -> void:
	print("\n6. Test Moltiplicatori di Affluenza Weekend nel ConcertSystem:")
	var player = PlayerData.new()
	player.popularity = 20.0
	player.energy = 100
	player.money = 200.0
	
	var cal = CalendarDataScript.new()
	var venue = VenueDataScript.new("pub_test", "Red Pub", 100, 50.0, 0.0, 1.0, 10.0)
	
	var song = SongDataScript.new("s1", "Rock Hit", Enums.MusicalGenre.ROCK, "ribellione")
	song.quality_score = 60.0
	song.status = Enums.SongStatus.PRODUCED
	var setlist: Array[SongData] = [song]
	
	# Concerto di Mercoledì (giorno 3) -> feriale, nessun bonus
	cal.day_number = 3
	var concert_sys = ConcertSystemScript.new(player, cal)
	var res_wed = concert_sys.resolve_concert(venue, setlist, 10.0)
	var aud_wed: int = res_wed.get("audience", 0)
	
	# Concerto di Venerdì (giorno 5) -> bonus +50% affluenza
	player.money = 200.0
	player.energy = 100
	cal.day_number = 5
	var res_fri = concert_sys.resolve_concert(venue, setlist, 10.0)
	var aud_fri: int = res_fri.get("audience", 0)
	assert_true(aud_fri >= int(round(float(aud_wed) * 1.40)), "Affluenza Venerdì potenziata (+50% weekend)")
	
	# Concerto di Sabato (giorno 6) -> bonus +100% affluenza
	player.money = 200.0
	player.energy = 100
	cal.day_number = 6
	var res_sat = concert_sys.resolve_concert(venue, setlist, 10.0)
	var aud_sat: int = res_sat.get("audience", 0)
	assert_true(aud_sat >= int(round(float(aud_wed) * 1.80)), "Affluenza Sabato massima (+100% prime time)")

# 7. Resa Vocale Lineare per Screen Reader NVDA
func test_linear_nvda_agenda_speech() -> void:
	print("\n7. Test Lettura Vocale Lineare Sequenziale per NVDA:")
	var cal = CalendarDataScript.new()
	cal.day_number = 1
	var schedule = ScheduleSystemScript.new(null, cal)
	
	# Nessun evento
	var speech_empty = schedule.get_linear_agenda_speech(7)
	assert_true(speech_empty.contains("Nessun impegno confermato"), "Agenda vuota segnalata linearmente")
	
	# Con eventi
	var ev1 = CalendarEventDataScript.new("e1", "Live Red Pub", Enums.CalendarEventType.CONCERT, 1, Enums.TimePeriod.EVENING)
	var ev2 = CalendarEventDataScript.new("e2", "Studio Registrazione", Enums.CalendarEventType.STUDIO_BOOKING, 3, Enums.TimePeriod.AFTERNOON)
	schedule.add_event(ev1)
	schedule.add_event(ev2)
	
	var speech_with_events = schedule.get_linear_agenda_speech(7)
	assert_true(speech_with_events.contains("Oggi"), "Menzione dell'evento odierno")
	assert_true(speech_with_events.contains("Live Red Pub"), "Titolo evento presente")
	assert_true(speech_with_events.contains("Tra 2 giorni"), "Calcolo giorni rimanenti lineare")
	print("  [ESEMPIO VOCALE NVDA]: \"%s\"" % speech_with_events)

# 8. Serializzazione e Salvataggio
func test_serialization_and_save_load() -> void:
	print("\n8. Test Serializzazione e Ripristino Dati:")
	var schedule = ScheduleSystemScript.new()
	var ev1 = CalendarEventDataScript.new("e_save_1", "Test Save", Enums.CalendarEventType.CONCERT, 10, Enums.TimePeriod.NIGHT, "v1", "Locale 1", true)
	schedule.add_event(ev1)
	
	var serialized = schedule.to_dict()
	assert_equal(serialized.size(), 1, "1 evento serializzato")
	
	var restored_schedule = ScheduleSystemScript.new()
	restored_schedule.from_dict(serialized)
	assert_equal(restored_schedule.events.size(), 1, "1 evento ripristinato")
	assert_equal(restored_schedule.events[0].id, "e_save_1", "ID ripristinato correttamente")
	assert_equal(restored_schedule.events[0].title, "Test Save", "Titolo ripristinato correttamente")
	assert_equal(restored_schedule.events[0].is_critical, true, "Flag critico ripristinato")
