# res://tests/test_festival_system.gd
extends Node

## Suite di Test Headless per Grandi Festival Estivi (World-tour V4.0 / Fase 8.3)
## Valida il catalogo dei 6 festival continentali, gli slot di esibizione (Pomeriggio, Tramonto, Headliner),
## l'influenza dei Manager, la sincronizzazione su ScheduleSystem, le vendite massive di merchandising,
## la meccanica "Rubare la Scena" contro la rivale del cartellone, la resa vocale NVDA e il save/load atomico.

const FestivalDataScript = preload("res://data/models/festival_data.gd")
const FestivalSystemScript = preload("res://systems/festival_system.gd")
const PlayerDataScript = preload("res://data/models/player_data.gd")
const CalendarDataScript = preload("res://data/models/calendar_data.gd")
const ScheduleSystemScript = preload("res://systems/schedule_system.gd")
const TravelSystemScript = preload("res://systems/travel_system.gd")
const BandSystemScript = preload("res://systems/band_system.gd")
const BandMemberDataScript = preload("res://data/models/band_member_data.gd")
const ManagerDataScript = preload("res://data/models/manager_data.gd")
const SongDataScript = preload("res://data/models/song_data.gd")

var tests_passed: int = 0
var tests_failed: int = 0

func _ready() -> void:
	print("\n========================================================")
	print("   SUITE TEST GRANDI FESTIVAL ESTIVI & SLOTS (F8.3)     ")
	print("========================================================")
	
	test_festival_catalog_initialization()
	test_slot_specifications()
	test_eligibility_checks_and_reputation()
	test_manager_influence_on_festival()
	test_booking_and_schedule_integration()
	test_festival_performance_audience_and_merch()
	test_steal_the_show_victory()
	test_steal_the_show_defeat_dynamics()
	test_territorial_fan_spread_and_fatigue()
	test_linear_nvda_speech_and_savegame_serialization()
	
	print("\n--------------------------------------------------------")
	print("ESITO COMPLESSIVO TEST GRANDI FESTIVAL ESTIVI (F8.3):")
	print("  Test Superati: %d" % tests_passed)
	print("  Test Falliti:  %d" % tests_failed)
	print("--------------------------------------------------------\n")
	
	if tests_failed == 0:
		print("[SUCCESSO] I Grandi Festival Estivi (F8.3) sono convalidati al 100%!")
		get_tree().quit(0)
	else:
		printerr("[ERRORE CRITICO] Alcuni test del sistema festival sono falliti!")
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
# 1. CATALOGO DEI 6 GRANDI FESTIVAL CONTINENTALI
# ------------------------------------------------------------------------------
func test_festival_catalog_initialization() -> void:
	print("\n--- TEST 1: CATALOGO DEI 6 GRANDI FESTIVAL CONTINENTALI ---")
	var fest_sys := FestivalSystemScript.new()
	var all_fests := fest_sys.get_all_festivals()
	assert_equal(all_fests.size(), 6, "Presenti esattamente 6 festival continentali")
	
	var mi := fest_sys.get_festival("fest_milano")
	assert_true(mi != null, "Festival di Milano presente")
	assert_equal(mi.city_id, Enums.CityId.MILANO, "Milano è la città ospitante")
	assert_equal(mi.capacity, 35000, "Capienza Milano: 35.000 persone")
	assert_equal(mi.day_number, 92, "Giorno 92 (Mese 4 - Estate)")
	assert_equal(mi.rival_band_name, "The Chrome Shadows", "Rivale di Milano: The Chrome Shadows")
	
	var bo := fest_sys.get_festival("fest_bologna")
	assert_true(bo != null, "Festival di Bologna presente")
	assert_equal(bo.capacity, 20000, "Capienza Bologna: 20.000 persone")
	assert_equal(bo.rival_band_name, "I Ribelli del Pratello", "Rivale di Bologna: I Ribelli del Pratello")
	
	var ro := fest_sys.get_festival("fest_roma")
	assert_equal(ro.capacity, 40000, "Capienza Roma: 40.000 persone")
	
	var na := fest_sys.get_festival("fest_napoli")
	assert_equal(na.capacity, 25000, "Capienza Napoli: 25.000 persone")
	
	var lo := fest_sys.get_festival("fest_londra")
	assert_equal(lo.capacity, 65000, "Capienza Londra (Hyde Park): 65.000 persone")
	
	var be := fest_sys.get_festival("fest_berlino")
	assert_equal(be.capacity, 50000, "Capienza Berlino (Tempelhof): 50.000 persone")

# ------------------------------------------------------------------------------
# 2. SPECIFICHE DEI 3 SLOT ORARI
# ------------------------------------------------------------------------------
func test_slot_specifications() -> void:
	print("\n--- TEST 2: SPECIFICHE DEI 3 SLOT ORARI ---")
	var afternoon := FestivalDataScript.get_slot_specs(Enums.FestivalSlot.OPENING_AFTERNOON, 30000)
	assert_almost_equal(afternoon.audience_share, 0.20, 0.01, "Slot Pomeriggio: 20% pubblico")
	assert_equal(afternoon.estimated_audience, 6000, "Pubblico stimato Pomeriggio: 6.000 persone")
	assert_equal(afternoon.guaranteed_fee, 600.0, "Cachet garantito Pomeriggio: 600.0 €")
	assert_equal(afternoon.min_reputation, 15.0, "Reputazione minima Pomeriggio: 15.0")
	assert_almost_equal(afternoon.merch_multiplier, 2.5, 0.01, "Moltiplicatore Merch Pomeriggio: x2.5")
	
	var sunset := FestivalDataScript.get_slot_specs(Enums.FestivalSlot.SUNSET_SLOT, 30000)
	assert_almost_equal(sunset.audience_share, 0.60, 0.01, "Slot Tramonto: 60% pubblico")
	assert_equal(sunset.estimated_audience, 18000, "Pubblico stimato Tramonto: 18.000 persone")
	assert_equal(sunset.guaranteed_fee, 3000.0, "Cachet garantito Tramonto: 3.000 €")
	assert_equal(sunset.min_reputation, 35.0, "Reputazione minima Tramonto: 35.0")
	assert_almost_equal(sunset.merch_multiplier, 4.0, 0.01, "Moltiplicatore Merch Tramonto: x4.0")
	
	var headliner := FestivalDataScript.get_slot_specs(Enums.FestivalSlot.HEADLINER_NIGHT, 30000)
	assert_almost_equal(headliner.audience_share, 1.0, 0.01, "Slot Headliner: 100% pubblico")
	assert_equal(headliner.estimated_audience, 30000, "Pubblico stimato Headliner: 30.000 persone")
	assert_equal(headliner.guaranteed_fee, 12000.0, "Cachet garantito Headliner: 12.000 €")
	assert_equal(headliner.min_reputation, 60.0, "Reputazione minima Headliner: 60.0")
	assert_almost_equal(headliner.merch_multiplier, 5.5, 0.01, "Moltiplicatore Merch Headliner: x5.5")

# ------------------------------------------------------------------------------
# 3. CONTROLLI DI IDONEITÀ E REQUISITI REPUTAZIONE
# ------------------------------------------------------------------------------
func test_eligibility_checks_and_reputation() -> void:
	print("\n--- TEST 3: CONTROLLI IDONEITÀ CANDIDATURA ---")
	var player := PlayerDataScript.new()
	player.reputation = 10.0 # Reputazione bassa da esordiente
	var calendar := CalendarDataScript.new()
	calendar.day_number = 1
	var fest_sys := FestivalSystemScript.new(player, calendar)
	
	# Reputazione 10.0 < 15.0 -> Pomeriggio bloccato
	var check_pomeriggio := fest_sys.can_apply_for_slot("fest_milano", Enums.FestivalSlot.OPENING_AFTERNOON)
	assert_equal(check_pomeriggio.allowed, false, "Slot Pomeriggio rifiutato con reputazione 10.0")
	assert_equal(check_pomeriggio.reason, "reputation_insufficient", "Causa rifiuto: reputation_insufficient")
	
	# Alziamo la reputazione a 25.0: Pomeriggio consentito, Tramonto bloccato (richiede 35.0)
	player.reputation = 25.0
	var check_pom_ok := fest_sys.can_apply_for_slot("fest_milano", Enums.FestivalSlot.OPENING_AFTERNOON)
	assert_equal(check_pom_ok.allowed, true, "Slot Pomeriggio consentito con reputazione 25.0")
	var check_tramonto := fest_sys.can_apply_for_slot("fest_milano", Enums.FestivalSlot.SUNSET_SLOT)
	assert_equal(check_tramonto.allowed, false, "Slot Tramonto rifiutato con reputazione 25.0 (< 35.0)")
	
	# Reputazione 65.0: Headliner consentito
	player.reputation = 65.0
	var check_head := fest_sys.can_apply_for_slot("fest_milano", Enums.FestivalSlot.HEADLINER_NIGHT)
	assert_equal(check_head.allowed, true, "Headliner consentito con reputazione 65.0 (>= 60.0)")

# ------------------------------------------------------------------------------
# 4. INFLUENZA DEL MANAGER SUL FESTIVAL
# ------------------------------------------------------------------------------
func test_manager_influence_on_festival() -> void:
	print("\n--- TEST 4: INFLUENZA MANAGER SULLE CANDIDATURE FESTIVAL ---")
	var player := PlayerDataScript.new()
	player.reputation = 40.0
	var calendar := CalendarDataScript.new()
	var fest_sys := FestivalSystemScript.new(player, calendar)
	
	# Senza manager, Headliner richiede 60.0 (player ha 40.0 -> bloccato)
	var check_no_mgr := fest_sys.can_apply_for_slot("fest_milano", Enums.FestivalSlot.HEADLINER_NIGHT)
	assert_equal(check_no_mgr.allowed, false, "Senza manager Headliner rifiutato con rep 40.0")
	
	# Con Manager Squalo dell'Industria (INDUSTRY_SHARK): sconto 35% (60.0 * 0.65 = 39.0)
	player.active_manager = ManagerDataScript.new("m_shark", "Squalo Boss", Enums.ManagerType.INDUSTRY_SHARK)
	player.active_manager.is_hired = true
	var check_shark := fest_sys.can_apply_for_slot("fest_milano", Enums.FestivalSlot.HEADLINER_NIGHT)
	assert_equal(check_shark.allowed, true, "Con Manager Squalo, Headliner consentito a rep 40.0 (soglia ridotta a 39.0)")
	# Cachet base 12.000 + 50% = 18.000 €
	assert_almost_equal(check_shark.effective_fee, 18000.0, 0.01, "Cachet maggiorato del 50% con Manager Squalo")

# ------------------------------------------------------------------------------
# 5. PRENOTAZIONE SLOT & SINCRONIZZAZIONE AGENDA
# ------------------------------------------------------------------------------
func test_booking_and_schedule_integration() -> void:
	print("\n--- TEST 5: PRENOTAZIONE SLOT & AGENDA CALENDARIO ---")
	var player := PlayerDataScript.new()
	player.reputation = 40.0
	var calendar := CalendarDataScript.new()
	calendar.day_number = 10
	var schedule_sys := ScheduleSystemScript.new(player, calendar)
	var fest_sys := FestivalSystemScript.new(player, calendar, null, schedule_sys)
	
	var book_res := fest_sys.book_festival_slot("fest_bologna", Enums.FestivalSlot.SUNSET_SLOT)
	assert_true(book_res.success, "Prenotazione slot Tramonto a Bologna riuscita")
	
	var fest := fest_sys.get_festival("fest_bologna")
	assert_equal(fest.booked_slot, Enums.FestivalSlot.SUNSET_SLOT, "Slot prenotato memorizzato nel festival")
	
	# Verifica evento a calendario al giorno 120
	var events := schedule_sys.get_events_for_day(120)
	assert_equal(events.size(), 1, "Evento festival registrato sul calendario al giorno 120")
	assert_equal(events[0].event_type, Enums.CalendarEventType.FESTIVAL, "Tipo evento è FESTIVAL")
	assert_true(events[0].title.find("Independent Summer Fest") != -1, "Titolo evento contiene nome festival")
	
	# Non si può riprenotare un festival già prenotato
	var double_book := fest_sys.book_festival_slot("fest_bologna", Enums.FestivalSlot.HEADLINER_NIGHT)
	assert_equal(double_book.allowed, false, "Doppia prenotazione rifiutata")
	assert_equal(double_book.reason, "already_booked", "Motivazione already_booked corretta")

# ------------------------------------------------------------------------------
# 6. SIMULAZIONE CONCERTO: PUBBLICO & MERCH MASSIVO
# ------------------------------------------------------------------------------
func test_festival_performance_audience_and_merch() -> void:
	print("\n--- TEST 6: SIMULAZIONE CONCERTO, AFFLUENZA & MERCH ---")
	var player := PlayerDataScript.new()
	player.money = 500.0
	player.popularity = 50.0
	player.reputation = 40.0
	player.current_city_id = Enums.CityId.BOLOGNA
	
	var calendar := CalendarDataScript.new()
	calendar.day_number = 120
	var fest_sys := FestivalSystemScript.new(player, calendar)
	fest_sys.book_festival_slot("fest_bologna", Enums.FestivalSlot.SUNSET_SLOT)
	
	var res := fest_sys.perform_festival_concert("fest_bologna", [], 75.0)
	assert_true(res.success, "Esibizione al festival completata")
	assert_true(res.actual_audience > 8000, "Affluenza massiva registrata (> 8.000 persone)")
	assert_true(res.merch_revenue > 2000.0, "Incasso merchandising massivo (> 2.000 € grazie al moltiplicatore x4.0)")
	assert_equal(res.guaranteed_fee, 3000.0, "Cachet garantito di 3.000 € corrisposto")
	assert_true(player.money > 500.0 + 3000.0, "Saldo giocatore incrementato di cachet + vendite merch")

# ------------------------------------------------------------------------------
# 7. MECCANICA 'RUBARE LA SCENA' (STEAL THE SHOW) - VITTORIA
# ------------------------------------------------------------------------------
func test_steal_the_show_victory() -> void:
	print("\n--- TEST 7: 'RUBARE LA SCENA' CONTRO LA RIVALE (VITTORIA) ---")
	var player := PlayerDataScript.new()
	player.reputation = 50.0
	player.morale = 60.0
	player.current_city_id = Enums.CityId.MILANO
	
	var member := BandMemberDataScript.new("m1", "Luca Drum", Enums.BandRole.DRUMS, Enums.BandPersonality.RELIABLE, Enums.MusicalGenre.ROCK, 50)
	member.affinity = 50.0
	member.musical_respect = 50.0
	member.tension = 30.0
	player.add_band_member(member)
	
	var calendar := CalendarDataScript.new()
	var band_sys := BandSystemScript.new(player, calendar)
	var fest_sys := FestivalSystemScript.new(player, calendar, null, null, band_sys)
	fest_sys.book_festival_slot("fest_milano", Enums.FestivalSlot.SUNSET_SLOT)
	
	# Rivale di Milano è The Chrome Shadows con score 74.0. Eseguiamo concerto a 85.0!
	var res := fest_sys.perform_festival_concert("fest_milano", [], 85.0)
	assert_true(res.stole_the_show, "Steal the Show riuscito! Battuta la band rivale (85.0 >= 74.0)")
	assert_equal(res.reputation_gain, 6.0, "Bonus reputazione aumentato a +6.0 per trionfo sul cartellone")
	assert_almost_equal(player.morale, 70.0, 0.01, "Morale aumentato di +10.0 (da 60 a 70)")
	assert_almost_equal(member.affinity, 60.0, 0.01, "Affinità band salita a 60.0 (+10)")
	assert_almost_equal(member.tension, 15.0, 0.01, "Tensione band scesa a 15.0 (-15)")

# ------------------------------------------------------------------------------
# 8. MECCANICA 'RUBARE LA SCENA' - SCONFITTA
# ------------------------------------------------------------------------------
func test_steal_the_show_defeat_dynamics() -> void:
	print("\n--- TEST 8: 'RUBARE LA SCENA' - SCONFITTA & TENSIONE ---")
	var player := PlayerDataScript.new()
	player.reputation = 40.0
	player.morale = 50.0
	player.current_city_id = Enums.CityId.MILANO
	
	var member := BandMemberDataScript.new("m2", "Gigi Synth", Enums.BandRole.KEYBOARDS, Enums.BandPersonality.PERFECTIONIST, Enums.MusicalGenre.ROCK, 50)
	member.tension = 20.0
	player.add_band_member(member)
	
	var calendar := CalendarDataScript.new()
	var band_sys := BandSystemScript.new(player, calendar)
	var fest_sys := FestivalSystemScript.new(player, calendar, null, null, band_sys)
	fest_sys.book_festival_slot("fest_milano", Enums.FestivalSlot.OPENING_AFTERNOON)
	
	# Punteggio 55.0 contro rivale 74.0 (margine peggiore di -10)
	var res := fest_sys.perform_festival_concert("fest_milano", [], 55.0)
	assert_equal(res.stole_the_show, false, "Steal the Show non riuscito (55.0 < 74.0)")
	assert_almost_equal(player.morale, 45.0, 0.01, "Morale calato a 45.0 (-5.0 per sconfitta sul cartellone)")
	assert_almost_equal(member.tension, 32.0, 0.01, "Tensione aumentata a 32.0 (+12.0)")

# ------------------------------------------------------------------------------
# 9. TERRITORIALITÀ FAN & FATICA
# ------------------------------------------------------------------------------
func test_territorial_fan_spread_and_fatigue() -> void:
	print("\n--- TEST 9: TERRITORIALITÀ DEI FAN & FATICA FISICA ---")
	var player := PlayerDataScript.new()
	player.energy = 100
	player.stress = 10.0
	player.reputation = 65.0
	player.current_city_id = Enums.CityId.ROMA
	
	var calendar := CalendarDataScript.new()
	var travel_sys := TravelSystemScript.new(player, calendar)
	var fest_sys := FestivalSystemScript.new(player, calendar, travel_sys)
	fest_sys.book_festival_slot("fest_roma", Enums.FestivalSlot.HEADLINER_NIGHT)
	
	# Esibizione da Headliner a Roma
	var res := fest_sys.perform_festival_concert("fest_roma", [], 80.0)
	assert_true(res.new_fans > 500, "Oltre 500 nuovi fan acquisiti nell'arena romana")
	# Roma riceve l'85% dei fan
	var roma_fans: int = travel_sys.get_fans_in_city(Enums.CityId.ROMA)
	assert_true(roma_fans > 400, "Roma riceve l'85% della fanbase locale (> 400 fan)")
	# Consumo energia 50 e stress +30 da Headliner
	assert_equal(player.energy, 50, "Energia ridotta di 50 (100 -> 50)")
	assert_almost_equal(player.stress, 40.0, 0.01, "Stress aumentato di 30 (10.0 -> 40.0)")

# ------------------------------------------------------------------------------
# 10. RESA VOCALE NVDA & SERIALIZZAZIONE SAVEGAME
# ------------------------------------------------------------------------------
func test_linear_nvda_speech_and_savegame_serialization() -> void:
	print("\n--- TEST 10: RESA VOCALE NVDA & SERIALIZZAZIONE ---")
	var player := PlayerDataScript.new()
	player.reputation = 40.0
	var calendar := CalendarDataScript.new()
	var fest_sys := FestivalSystemScript.new(player, calendar)
	
	# Resa vocale lista
	var list_speech := fest_sys.get_festival_list_speech()
	assert_true(list_speech.length() > 0, "Discorso vocale lista generato")
	assert_true(list_speech.find("Rock in Milano Open Air") != -1, "Include festival di Milano")
	assert_true(list_speech.find("Independent Summer Fest") != -1, "Include festival di Bologna")
	assert_true(list_speech.find("┌") == -1 and list_speech.find("│") == -1, "Zero caratteri grafici ASCII per NVDA")
	
	# Resa vocale dettagli
	var detail_speech := fest_sys.get_festival_details_speech("fest_milano")
	assert_true(detail_speech.find("Idroscalo") != -1, "Dettagli includono nome arena Idroscalo")
	assert_true(detail_speech.find("The Chrome Shadows") != -1, "Dettagli includono band rivale")
	
	# Serializzazione & Deserializzazione
	fest_sys.book_festival_slot("fest_napoli", Enums.FestivalSlot.SUNSET_SLOT)
	var save_dict := fest_sys.to_dict()
	assert_true(save_dict.has("festivals"), "Dizionario include festivals")
	
	var loaded_sys := FestivalSystemScript.new(player, calendar)
	loaded_sys.from_dict(save_dict)
	
	var loaded_na := loaded_sys.get_festival("fest_napoli")
	assert_true(loaded_na != null, "Festival di Napoli ripristinato")
	assert_equal(loaded_na.booked_slot, Enums.FestivalSlot.SUNSET_SLOT, "Slot Tramonto ripristinato a Napoli")
	assert_equal(loaded_na.rival_band_name, "Vesuvio Posse", "Rivale Vesuvio Posse ripristinata")
