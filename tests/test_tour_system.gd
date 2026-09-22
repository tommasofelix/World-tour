# res://tests/test_tour_system.gd
extends Node

## Suite di Test Headless per Pianificazione & Gestione del Tour (World-tour V4.0 / Fase 8.2)
## Valida il catalogo veicoli (Rusty Van, Pro Van, Luxury Bus), la pianificazione
## delle tournée multi-tappa, l'Hype progressivo, l'integrazione con ScheduleSystem e ConcertSystem,
## le dinamiche della band, la resa vocale NVDA e la persistenza atomica.

const TourDataScript = preload("res://data/models/tour_data.gd")
const TourSystemScript = preload("res://systems/tour_system.gd")
const PlayerDataScript = preload("res://data/models/player_data.gd")
const CalendarDataScript = preload("res://data/models/calendar_data.gd")
const ScheduleSystemScript = preload("res://systems/schedule_system.gd")
const TravelSystemScript = preload("res://systems/travel_system.gd")
const BandSystemScript = preload("res://systems/band_system.gd")
const ConcertSystemScript = preload("res://systems/concert_system.gd")
const VenueDataScript = preload("res://data/models/venue_data.gd")
const SongDataScript = preload("res://data/models/song_data.gd")

var tests_passed: int = 0
var tests_failed: int = 0

func _ready() -> void:
	print("\n========================================================")
	print("   SUITE TEST PIANIFICAZIONE & GESTIONE TOUR (F8.2)     ")
	print("========================================================")
	
	test_vehicle_specs_and_costs()
	test_tour_data_model()
	test_tour_feasibility_checks()
	test_tour_planning_and_schedule_integration()
	test_logistics_and_vehicle_fatigue()
	test_breakdown_mechanics()
	test_cumulative_hype_mechanics()
	test_concert_system_tour_integration()
	test_tour_completion_and_band_dynamics()
	test_linear_nvda_speech_and_serialization()
	
	print("\n--------------------------------------------------------")
	print("ESITO COMPLESSIVO TEST TOUR & TOURNÉE (F8.2):")
	print("  Test Superati: %d" % tests_passed)
	print("  Test Falliti:  %d" % tests_failed)
	print("--------------------------------------------------------\n")
	
	if tests_failed == 0:
		print("[SUCCESSO] La Pianificazione & Gestione del Tour (F8.2) è convalidata al 100%!")
		get_tree().quit(0)
	else:
		printerr("[ERRORE CRITICO] Alcuni test del sistema tour sono falliti!")
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

# ------------------------------------------------------------------------------
# 1. SPECIFICHE VEICOLI (TourVehicleType)
# ------------------------------------------------------------------------------
func test_vehicle_specs_and_costs() -> void:
	print("\n--- TEST 1: CATALOGO VEICOLI & SPECIFICHE LOGISTICHE ---")
	var rusty := TourSystemScript.get_vehicle_specs(Enums.TourVehicleType.RUSTY_VAN)
	assert_equal(rusty.cost_per_stop, 40.0, "Furgone Scassato costa 40.0 € per tappa")
	assert_equal(rusty.stress_per_stop, 15, "Furgone Scassato genera +15 stress a tappa")
	assert_equal(rusty.energy_per_stop, -20, "Furgone Scassato consuma 20 energia a tappa")
	assert_almost_equal(rusty.breakdown_chance, 0.15, 0.01, "Furgone Scassato ha 15% rischio guasto")
	
	var pro := TourSystemScript.get_vehicle_specs(Enums.TourVehicleType.PRO_VAN)
	assert_equal(pro.cost_per_stop, 150.0, "Van Professionale costa 150.0 € per tappa")
	assert_equal(pro.stress_per_stop, 5, "Van Professionale genera moderato stress (+5)")
	assert_equal(pro.breakdown_chance, 0.0, "Van Professionale ha 0% rischio guasti")
	assert_true(pro.min_reputation >= 15.0, "Van Professionale richiede reputazione >= 15.0")
	
	var luxury := TourSystemScript.get_vehicle_specs(Enums.TourVehicleType.LUXURY_BUS)
	assert_equal(luxury.cost_per_stop, 450.0, "Tour Bus di Lusso costa 450.0 € per tappa")
	assert_equal(luxury.stress_per_stop, 0, "Tour Bus di Lusso azzera lo stress da viaggio (0 stress)")
	assert_true(luxury.energy_per_stop > 0, "Tour Bus di Lusso rigenera energia durante il viaggio (+15)")
	assert_true(luxury.hype_bonus >= 0.15, "Tour Bus di Lusso conferisce bonus Hype iniziale (+15%)")

# ------------------------------------------------------------------------------
# 2. MODELLO DATI TOUR (TourData)
# ------------------------------------------------------------------------------
func test_tour_data_model() -> void:
	print("\n--- TEST 2: MODELLO DATI TOUR ---")
	var tour := TourDataScript.new("tour_test", "Rock Wave Tour", Enums.TourVehicleType.PRO_VAN, 10)
	assert_equal(tour.id, "tour_test", "ID tour impostato correttamente")
	assert_equal(tour.title, "Rock Wave Tour", "Titolo tour impostato")
	assert_equal(tour.vehicle_type, Enums.TourVehicleType.PRO_VAN, "Tipo veicolo Pro Van")
	assert_equal(tour.status, TourDataScript.TourStatus.PLANNED, "Stato iniziale PLANNED")
	assert_equal(tour.stops.size(), 0, "Nessuna tappa inizialmente")
	
	tour.add_stop(Enums.CityId.MILANO, "Milano", "milano_club", "Alcatraz", 12)
	tour.add_stop(Enums.CityId.BOLOGNA, "Bologna", "bologna_covo", "Covo", 14)
	assert_equal(tour.stops.size(), 2, "Aggiunte 2 tappe")
	assert_equal(tour.is_tour_finished(), false, "Tour non ancora concluso")
	
	var cur := tour.get_current_stop()
	assert_equal(cur.city_id, Enums.CityId.MILANO, "La prima tappa è a Milano")

# ------------------------------------------------------------------------------
# 3. CONTROLLI DI FATTIBILITÀ (can_plan_tour)
# ------------------------------------------------------------------------------
func test_tour_feasibility_checks() -> void:
	print("\n--- TEST 3: CONTROLLI DI FATTIBILITÀ TOUR ---")
	var player := PlayerDataScript.new()
	player.money = 200.0
	player.reputation = 5.0
	
	var calendar := CalendarDataScript.new()
	calendar.day_number = 1
	
	var tour_sys := TourSystemScript.new(player, calendar)
	
	var valid_stops: Array[Dictionary] = [
		{ "city_id": Enums.CityId.MILANO, "venue_id": "v1", "venue_name": "Club 1", "day_number": 3 },
		{ "city_id": Enums.CityId.BOLOGNA, "venue_id": "v2", "venue_name": "Club 2", "day_number": 5 }
	]
	
	# Reputazione insufficiente per Luxury Bus (richiede 40, player ha 5)
	var check_lux := tour_sys.can_plan_tour(Enums.TourVehicleType.LUXURY_BUS, valid_stops)
	assert_equal(check_lux.allowed, false, "Luxury Bus rifiutato per reputazione insufficiente")
	assert_equal(check_lux.reason, "reputation_insufficient_for_vehicle", "Motivazione reputazione corretta")
	
	# Troppe poche tappe (< 2)
	var check_few := tour_sys.can_plan_tour(Enums.TourVehicleType.RUSTY_VAN, [{ "city_id": 0, "day_number": 3 }])
	assert_equal(check_few.allowed, false, "Tour rifiutato se ha meno di 2 tappe")
	
	# Fondi insufficienti per noleggio (Pro Van per 2 tappe = 300 €, player ha 200 €)
	player.reputation = 20.0
	var check_broke := tour_sys.can_plan_tour(Enums.TourVehicleType.PRO_VAN, valid_stops)
	assert_equal(check_broke.allowed, false, "Pro Van rifiutato se fondi insufficienti")
	assert_equal(check_broke.reason, "funds_insufficient_for_vehicle", "Motivazione fondi corretta")
	
	# Date nel passato
	var invalid_dates: Array[Dictionary] = [
		{ "city_id": Enums.CityId.MILANO, "venue_id": "v1", "venue_name": "Club 1", "day_number": 0 },
		{ "city_id": Enums.CityId.BOLOGNA, "venue_id": "v2", "venue_name": "Club 2", "day_number": 2 }
	]
	var check_dates := tour_sys.can_plan_tour(Enums.TourVehicleType.RUSTY_VAN, invalid_dates)
	assert_equal(check_dates.allowed, false, "Tour rifiutato con date nel passato o incoerenti")
	
	# Pianificazione valida con Rusty Van (2 tappe * 40 = 80 €, player ha 200 €)
	var check_valid := tour_sys.can_plan_tour(Enums.TourVehicleType.RUSTY_VAN, valid_stops)
	assert_equal(check_valid.allowed, true, "Pianificazione valida consentita con Rusty Van")
	assert_equal(check_valid.rental_cost, 80.0, "Costo noleggio calcolato a 80.0 €")

# ------------------------------------------------------------------------------
# 4. PIANIFICAZIONE & SINCRONIZZAZIONE AGENDA
# ------------------------------------------------------------------------------
func test_tour_planning_and_schedule_integration() -> void:
	print("\n--- TEST 4: PIANIFICAZIONE & SINCRONIZZAZIONE AGENDA ---")
	var player := PlayerDataScript.new()
	player.money = 1000.0
	player.reputation = 20.0
	
	var calendar := CalendarDataScript.new()
	calendar.day_number = 5
	
	var schedule := ScheduleSystemScript.new(player, calendar)
	var tour_sys := TourSystemScript.new(player, calendar, null, schedule)
	
	var stops: Array[Dictionary] = [
		{ "city_id": Enums.CityId.MILANO, "venue_id": "v_mi", "venue_name": "Magazzini", "day_number": 7 },
		{ "city_id": Enums.CityId.BOLOGNA, "venue_id": "v_bo", "venue_name": "Estragon", "day_number": 9 },
		{ "city_id": Enums.CityId.ROMA, "venue_id": "v_ro", "venue_name": "Atlantico", "day_number": 11 }
	]
	
	var res := tour_sys.plan_tour("Giro d'Italia", Enums.TourVehicleType.PRO_VAN, stops)
	assert_true(res.success, "Tour pianificato con successo")
	assert_equal(tour_sys.active_tour.status, TourDataScript.TourStatus.IN_PROGRESS, "Lo stato del tour è IN_PROGRESS")
	assert_equal(player.money, 1000.0 - 450.0, "Detratti 450.0 € per noleggio Pro Van (3 tappe * 150)")
	
	# Verifica che gli impegni a calendario siano stati registrati
	var ev_day7 := schedule.get_events_for_day(7)
	assert_true(ev_day7.size() > 0, "Tappa 1 registrata sul calendario al giorno 7")
	assert_equal(ev_day7[0].event_type, Enums.CalendarEventType.TOUR_STOP, "Tipo evento è TOUR_STOP")
	
	var ev_day9 := schedule.get_events_for_day(9)
	assert_true(ev_day9.size() > 0, "Tappa 2 registrata sul calendario al giorno 9")
	
	var ev_day11 := schedule.get_events_for_day(11)
	assert_true(ev_day11.size() > 0, "Tappa 3 registrata sul calendario al giorno 11")

# ------------------------------------------------------------------------------
# 5. LOGISTICA & FATICA DA MEZZO DI TRASPORTO
# ------------------------------------------------------------------------------
func test_logistics_and_vehicle_fatigue() -> void:
	print("\n--- TEST 5: LOGISTICA & FATICA DA MEZZO ---")
	var player := PlayerDataScript.new()
	player.money = 2000.0
	player.energy = 80
	player.stress = 10.0
	player.reputation = 50.0
	player.current_city_id = Enums.CityId.MILANO
	
	var calendar := CalendarDataScript.new()
	var travel := TravelSystemScript.new(player, calendar)
	var tour_sys := TourSystemScript.new(player, calendar, travel, null)
	
	# Tour con Luxury Bus
	var stops: Array[Dictionary] = [
		{ "city_id": Enums.CityId.ROMA, "venue_id": "v_ro", "venue_name": "Atlantico", "day_number": 3 },
		{ "city_id": Enums.CityId.NAPOLI, "venue_id": "v_na", "venue_name": "Palapartenope", "day_number": 5 }
	]
	tour_sys.plan_tour("Luxury Tour", Enums.TourVehicleType.LUXURY_BUS, stops)
	
	# Spostamento verso Tappa 1 (Roma) con Luxury Bus
	var move_res := tour_sys.advance_to_next_stop()
	assert_true(move_res.success, "Spostamento con Luxury Bus riuscito")
	assert_equal(player.current_city_id, Enums.CityId.ROMA, "Giocatore spostato a Roma")
	assert_equal(travel.current_city_id, Enums.CityId.ROMA, "TravelSystem sincronizzato a Roma")
	
	# Con Luxury Bus: 0 stress aggiuntivo, recupero +15 energia
	assert_almost_equal(player.stress, 10.0, 0.01, "Nessun accumulo di stress con il Luxury Bus")
	assert_equal(player.energy, 95, "Energia rigenerata a bordo (+15, da 80 a 95)")

# ------------------------------------------------------------------------------
# 6. GESTIONE IMPREVISTI MECCANICI (Rusty Van)
# ------------------------------------------------------------------------------
func test_breakdown_mechanics() -> void:
	print("\n--- TEST 6: IMPREVISTI MECCANICI VEICOLO ECONOMICO ---")
	var specs := TourSystemScript.get_vehicle_specs(Enums.TourVehicleType.RUSTY_VAN)
	assert_true(specs.breakdown_chance > 0.0, "Rusty Van include probabilità di guasto meccanico")
	assert_true(specs.breakdown_cost > 0.0, "Riparazione guasto ha un costo in denaro")
	
	var pro_specs := TourSystemScript.get_vehicle_specs(Enums.TourVehicleType.PRO_VAN)
	assert_equal(pro_specs.breakdown_chance, 0.0, "Pro Van garantisce zero rischi di guasto stradale ordinario")

# ------------------------------------------------------------------------------
# 7. MECCANICA HYPE CUMULATIVO A CATENA
# ------------------------------------------------------------------------------
func test_cumulative_hype_mechanics() -> void:
	print("\n--- TEST 7: HYPE PROGRESSIVO A CATENA ---")
	var player := PlayerDataScript.new()
	player.money = 1000.0
	player.reputation = 20.0
	var tour_sys := TourSystemScript.new(player)
	
	var stops: Array[Dictionary] = [
		{ "city_id": Enums.CityId.MILANO, "venue_id": "v1", "venue_name": "Club 1", "day_number": 2 },
		{ "city_id": Enums.CityId.BOLOGNA, "venue_id": "v2", "venue_name": "Club 2", "day_number": 4 }
	]
	tour_sys.plan_tour("Hype Tour", Enums.TourVehicleType.PRO_VAN, stops)
	assert_almost_equal(tour_sys.get_tour_hype_multiplier(), 1.0, 0.01, "Hype di partenza è 1.0 (neutro)")
	
	# Registrazione di un concerto trionfale (Score 85.0 >= 70.0)
	var concert_result := {
		"gross_revenue": 500.0,
		"player_share": 350.0,
		"rent_cost": 100.0,
		"new_fans": 80,
		"concert_score": 85.0
	}
	var res := tour_sys.record_stop_result(concert_result)
	assert_true(res.success, "Esito tappa registrato con successo")
	assert_almost_equal(res.hype_gained, 0.05, 0.01, "Guadagnato +5% Hype per show eccellente")
	assert_almost_equal(tour_sys.get_tour_hype_multiplier(), 1.05, 0.01, "Moltiplicatore Hype sale a 1.05")

# ------------------------------------------------------------------------------
# 8. INTEGRAZIONE CONCERTI & HYPE (ConcertSystem)
# ------------------------------------------------------------------------------
func test_concert_system_tour_integration() -> void:
	print("\n--- TEST 8: INTEGRAZIONE CONCERT SYSTEM & TOUR ---")
	var player := PlayerDataScript.new()
	player.money = 1000.0
	player.energy = 90
	player.popularity = 40.0
	player.reputation = 30.0
	
	var calendar := CalendarDataScript.new()
	var tour_sys := TourSystemScript.new(player, calendar)
	var concert_sys := ConcertSystemScript.new(player, calendar)
	
	var stops: Array[Dictionary] = [
		{ "city_id": Enums.CityId.MILANO, "venue_id": "milano_pub", "venue_name": "Navigli Rock Pub", "day_number": 2 },
		{ "city_id": Enums.CityId.BOLOGNA, "venue_id": "bologna_covo", "venue_name": "Covo Indie Club", "day_number": 4 }
	]
	tour_sys.plan_tour("Live Tour", Enums.TourVehicleType.PRO_VAN, stops)
	tour_sys.active_tour.accumulated_hype = 1.20 # +20% hype accumulato
	
	if GameManager:
		GameManager.player_data = player
		GameManager.tour_system = tour_sys
		
	var venue := VenueDataScript.new("test_v", "Test Venue", 100, 50.0, 10.0, 20.0, 10.0, "Club", "Intimo")
	var song := SongDataScript.new("s_test", "Hit Song", Enums.MusicalGenre.ROCK, "Energy")
	song.quality_score = 75.0
	song.status = Enums.SongStatus.PRODUCED
	
	var result := concert_sys.resolve_concert(venue, [song], 10.0)
	assert_true(result.get("success", false), "Concerto eseguito con successo")
	assert_true(result.has("tour_hype_mult"), "Il risultato include tour_hype_mult")
	assert_almost_equal(result.tour_hype_mult, 1.20, 0.01, "Il concerto ha applicato il moltiplicatore Hype del tour (1.20)")

# ------------------------------------------------------------------------------
# 9. CONCLUSIONE TOUR & DINAMICHE BAND
# ------------------------------------------------------------------------------
func test_tour_completion_and_band_dynamics() -> void:
	print("\n--- TEST 9: CONCLUSIONE TOUR & DINAMICHE BAND ---")
	var player := PlayerDataScript.new()
	player.money = 2000.0
	player.reputation = 20.0
	
	const BandMemberDataScript = preload("res://data/models/band_member_data.gd")
	var member := BandMemberDataScript.new("m1", "Marco Bass", Enums.BandRole.BASS, Enums.BandPersonality.RELIABLE, Enums.MusicalGenre.ROCK, 50)
	member.affinity = 50.0
	member.musical_respect = 50.0
	member.tension = 30.0
	player.add_band_member(member)
	
	var calendar := CalendarDataScript.new()
	var band := BandSystemScript.new(player, calendar)
	var tour_sys := TourSystemScript.new(player, calendar, null, null, band)
	
	var stops: Array[Dictionary] = [
		{ "city_id": Enums.CityId.MILANO, "venue_id": "v1", "venue_name": "Club 1", "day_number": 2 },
		{ "city_id": Enums.CityId.BOLOGNA, "venue_id": "v2", "venue_name": "Club 2", "day_number": 4 }
	]
	tour_sys.plan_tour("Triumphant Tour", Enums.TourVehicleType.PRO_VAN, stops)
	
	# Tappa 1
	tour_sys.record_stop_result({ "gross_revenue": 600.0, "player_share": 400.0, "rent_cost": 100.0, "new_fans": 60, "concert_score": 80.0 })
	# Tappa 2 (conclude il tour)
	tour_sys.record_stop_result({ "gross_revenue": 800.0, "player_share": 500.0, "rent_cost": 150.0, "new_fans": 70, "concert_score": 85.0 })
	
	assert_true(tour_sys.active_tour.is_tour_finished(), "Tutte le tappe del tour risultano completate")
	assert_equal(tour_sys.active_tour.status, TourDataScript.TourStatus.COMPLETED, "Stato aggiornato a COMPLETED")
	
	# Il tour trionfale consolida la band: +15 Affinità, +15 Rispetto, -20 Tensione
	assert_almost_equal(member.affinity, 65.0, 0.01, "Affinità aumentata a 65.0 (+15)")
	assert_almost_equal(member.musical_respect, 65.0, 0.01, "Rispetto musicale aumentato a 65.0 (+15)")
	assert_almost_equal(member.tension, 10.0, 0.01, "Tensione interna scesa a 10.0 (-20)")
	assert_true(player.reputation > 20.0, "Reputazione complessiva del musicista aumentata")

# ------------------------------------------------------------------------------
# 10. RESA VOCALE NVDA & SERIALIZZAZIONE
# ------------------------------------------------------------------------------
func test_linear_nvda_speech_and_serialization() -> void:
	print("\n--- TEST 10: RESA VOCALE NVDA & SERIALIZZAZIONE ---")
	var player := PlayerDataScript.new()
	player.money = 1000.0
	player.reputation = 25.0
	var tour_sys := TourSystemScript.new(player)
	
	var stops: Array[Dictionary] = [
		{ "city_id": Enums.CityId.MILANO, "venue_id": "v1", "venue_name": "Club 1", "day_number": 2 },
		{ "city_id": Enums.CityId.BOLOGNA, "venue_id": "v2", "venue_name": "Club 2", "day_number": 4 }
	]
	tour_sys.plan_tour("Acoustic Journey", Enums.TourVehicleType.PRO_VAN, stops)
	
	# Resa Vocale
	var speech := tour_sys.get_tour_summary_speech()
	assert_true(speech.length() > 0, "Discorso vocale generato")
	assert_true(speech.find("Acoustic Journey") != -1, "Discorso include il titolo del tour")
	assert_true(speech.find("Van Professionale") != -1, "Discorso include il nome del veicolo")
	assert_true(speech.find("┌") == -1 and speech.find("│") == -1, "Zero caratteri grafici ASCII per NVDA")
	
	# Serializzazione & Deserializzazione
	var save_dict := tour_sys.to_dict()
	assert_true(save_dict.has("active_tour"), "Dizionario di salvataggio include active_tour")
	
	var loaded_sys := TourSystemScript.new(player)
	loaded_sys.from_dict(save_dict)
	assert_true(loaded_sys.active_tour != null, "Tour attivo ripristinato con successo")
	assert_equal(loaded_sys.active_tour.title, "Acoustic Journey", "Titolo del tour ripristinato")
	assert_equal(loaded_sys.active_tour.vehicle_type, Enums.TourVehicleType.PRO_VAN, "Tipo veicolo ripristinato")
	assert_equal(loaded_sys.active_tour.stops.size(), 2, "Numero di tappe ripristinato")
