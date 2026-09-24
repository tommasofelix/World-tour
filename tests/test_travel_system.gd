# res://tests/test_travel_system.gd
extends Node

## Suite di Test Headless per Mappa Geografica & Sistema delle Città (World-tour V4.0 / Fase 8.1)
## Valida il catalogo delle 6 città (Milano, Bologna, Roma, Napoli, Londra, Berlino),
## la matrice di viaggio (costi, energia, stress), la penetrazione territoriale dei fan con riverbero,
## l'affinità di genere musicale per città, i locali cittadini, la resa NVDA e la serializzazione.

const CityDataScript = preload("res://data/models/city_data.gd")
const TravelSystemScript = preload("res://systems/travel_system.gd")
const PlayerDataScript = preload("res://data/models/player_data.gd")
const VenueDataScript = preload("res://data/models/venue_data.gd")
const SongDataScript = preload("res://data/models/song_data.gd")
const ConcertSystemScript = preload("res://systems/concert_system.gd")

var tests_passed: int = 0
var tests_failed: int = 0

func _ready() -> void:
	print("\n========================================================")
	print("   SUITE TEST MAPPA GEOGRAFICA & SISTEMA CITTÀ (F8.1)   ")
	print("========================================================")

	test_city_data_catalog()
	test_genre_affinities()
	test_travel_cost_and_fatigue_matrix()
	test_travel_feasibility_checks()
	test_travel_execution_and_player_state()
	test_territorial_fans_and_reverberation()
	test_current_city_venues()
	test_concert_system_city_affinity_integration()
	test_transoceanic_travel_and_jet_lag()
	test_city_events_and_concert_multipliers()
	test_linear_nvda_travel_speech()
	test_serialization_and_save_load()

	print("\n--------------------------------------------------------")
	print("ESITO COMPLESSIVO TEST MAPPA & CITTÀ (F8.1 / SEZIONE 6):")
	print("  Test Superati: %d" % tests_passed)
	print("  Test Falliti:  %d" % tests_failed)
	print("--------------------------------------------------------\n")

	if tests_failed == 0:
		print("[SUCCESSO] La Mappa Geografica & Sistema delle Città (Sezione 6) è convalidata al 100%!")
		get_tree().quit(0)
	else:
		printerr("[ERRORE CRITICO] Alcuni test del sistema viaggi e città sono falliti!")
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
# 1. CATALOGO DELLE CITTÀ (CityData)
# ------------------------------------------------------------------------------
func test_city_data_catalog() -> void:
	print("\n--- TEST 1: CATALOGO CITTÀ (12 METROPOLI) ---")
	var cities: Array[CityData] = CityDataScript.get_all_cities()
	assert_equal(cities.size(), 16, "Il catalogo contiene esattamente 16 città (4 nazionali, 5 europee, 7 oltreoceano)")

	var city_ids: Array[int] = []
	for c in cities:
		city_ids.append(c.id)

	assert_true(city_ids.has(Enums.CityId.MILANO), "Milano presente nel catalogo")
	assert_true(city_ids.has(Enums.CityId.BOLOGNA), "Bologna presente nel catalogo")
	assert_true(city_ids.has(Enums.CityId.ROMA), "Roma presente nel catalogo")
	assert_true(city_ids.has(Enums.CityId.NAPOLI), "Napoli presente nel catalogo")
	assert_true(city_ids.has(Enums.CityId.LONDRA), "Londra presente nel catalogo")
	assert_true(city_ids.has(Enums.CityId.BERLINO), "Berlino presente nel catalogo")
	assert_true(city_ids.has(Enums.CityId.DUBLINO), "Dublino presente nel catalogo")
	assert_true(city_ids.has(Enums.CityId.PARIGI), "Parigi presente nel catalogo")
	assert_true(city_ids.has(Enums.CityId.MADRID), "Madrid presente nel catalogo")
	assert_true(city_ids.has(Enums.CityId.NEW_YORK), "New York presente nel catalogo")
	assert_true(city_ids.has(Enums.CityId.LOS_ANGELES), "Los Angeles presente nel catalogo")
	assert_true(city_ids.has(Enums.CityId.TOKYO), "Tokyo presente nel catalogo")
	assert_true(city_ids.has(Enums.CityId.SAO_PAULO), "San Paolo presente nel catalogo")
	assert_true(city_ids.has(Enums.CityId.BUENOS_AIRES), "Buenos Aires presente nel catalogo")
	assert_true(city_ids.has(Enums.CityId.SYDNEY), "Sydney presente nel catalogo")
	assert_true(city_ids.has(Enums.CityId.SEOUL), "Seoul presente nel catalogo")

	var milano: CityData = CityDataScript.get_city(Enums.CityId.MILANO)
	assert_equal(milano.name, "Milano", "Nome di Milano corretto")
	assert_equal(milano.is_international, false, "Milano è nazionale")
	assert_equal(milano.min_reputation_req, 0.0, "Milano accessibile senza reputazione iniziale")
	assert_true(milano.venues.size() > 0, "Milano ha locali associati")

	var londra: CityData = CityDataScript.get_city(Enums.CityId.LONDRA)
	assert_equal(londra.name, "Londra", "Nome di Londra corretto")
	assert_equal(londra.is_international, true, "Londra è internazionale")
	assert_true(londra.min_reputation_req >= 30.0, "Londra richiede reputazione da star (>= 30.0)")

	var ny: CityData = CityDataScript.get_city(Enums.CityId.NEW_YORK)
	assert_equal(ny.name, "New York", "Nome di New York corretto")
	assert_true(ny.is_transoceanic, "New York ha flag is_transoceanic true")
	assert_true(ny.min_reputation_req >= 50.0, "New York richiede reputazione superstar (>= 50.0)")

	var tokyo: CityData = CityDataScript.get_city(Enums.CityId.TOKYO)
	assert_equal(tokyo.name, "Tokyo", "Nome di Tokyo corretto")
	assert_true(tokyo.is_transoceanic, "Tokyo ha flag is_transoceanic true")
	assert_true(tokyo.min_reputation_req >= 60.0, "Tokyo richiede reputazione superstar (>= 60.0)")

# ------------------------------------------------------------------------------
# 2. AFFINITÀ DI GENERE MUSICALE PER CITTÀ
# ------------------------------------------------------------------------------
func test_genre_affinities() -> void:
	print("\n--- TEST 2: AFFINITÀ DI GENERE MUSICALE ---")
	var bologna: CityData = CityDataScript.get_city(Enums.CityId.BOLOGNA)
	assert_true(bologna != null, "Bologna recuperata correttamente")

	var indie_aff: float = bologna.get_affinity_for_genre(Enums.MusicalGenre.INDIE)
	assert_true(indie_aff >= 1.25, "Bologna ha un'affinità alta per l'Indie (>= 1.25, bonus +25%%)")

	var berlino: CityData = CityDataScript.get_city(Enums.CityId.BERLINO)
	var electro_aff: float = berlino.get_affinity_for_genre(Enums.MusicalGenre.ELECTRONIC)
	var metal_aff: float = berlino.get_affinity_for_genre(Enums.MusicalGenre.METAL)
	assert_true(electro_aff >= 1.30, "Berlino eccelle nell'Elettronica (>= 1.30)")
	assert_true(metal_aff >= 1.20, "Berlino apprezza fortemente il Metal (>= 1.20)")

	var napoli: CityData = CityDataScript.get_city(Enums.CityId.NAPOLI)
	var hiphop_aff: float = napoli.get_affinity_for_genre(Enums.MusicalGenre.HIPHOP)
	assert_true(hiphop_aff >= 1.30, "Napoli ha una fortissima scena HipHop/Urban (>= 1.30)")

	var neutral_aff: float = napoli.get_affinity_for_genre(Enums.MusicalGenre.ELECTRONIC)
	assert_almost_equal(neutral_aff, 1.0, 0.05, "Genere neutro ha moltiplicatore base 1.0")

# ------------------------------------------------------------------------------
# 3. MATRICE COSTI, ENERGIA E STRESS DA VIAGGIO
# ------------------------------------------------------------------------------
func test_travel_cost_and_fatigue_matrix() -> void:
	print("\n--- TEST 3: MATRICE COSTI & FATICA DA VIAGGIO ---")
	var travel_sys: TravelSystem = TravelSystemScript.new()
	travel_sys.current_city_id = Enums.CityId.MILANO

	# Viaggio a se stessi: nessun costo
	var same_city: Dictionary = travel_sys.calculate_travel_cost(Enums.CityId.MILANO, Enums.CityId.MILANO)
	assert_equal(same_city.money_cost, 0.0, "Spostarsi nella stessa città costa 0")
	assert_equal(same_city.energy_cost, 0, "Spostarsi nella stessa città consuma 0 energia")
	assert_equal(same_city.stress_cost, 0, "Spostarsi nella stessa città non genera stress")

	# Tratta breve nazionale (Milano -> Bologna)
	var mi_bo: Dictionary = travel_sys.calculate_travel_cost(Enums.CityId.MILANO, Enums.CityId.BOLOGNA)
	assert_true(mi_bo.money_cost > 0.0, "Tratta Milano-Bologna ha un costo in denaro")
	assert_true(mi_bo.energy_cost >= 10 and mi_bo.energy_cost <= 25, "Tratta breve consuma energia moderata (10-25)")
	assert_true(mi_bo.stress_cost >= 5 and mi_bo.stress_cost <= 15, "Tratta breve genera stress contenuto (5-15)")

	# Tratta internazionale (Milano -> Londra)
	var mi_lon: Dictionary = travel_sys.calculate_travel_cost(Enums.CityId.MILANO, Enums.CityId.LONDRA)
	assert_true(mi_lon.money_cost > mi_bo.money_cost, "Volo internazionale per Londra costa più del treno per Bologna")
	assert_true(mi_lon.energy_cost > mi_bo.energy_cost, "Volo internazionale consuma più energia della tratta breve")
	assert_true(mi_lon.stress_cost > mi_bo.stress_cost, "Volo internazionale genera più stress")

# ------------------------------------------------------------------------------
# 4. CONTROLLI DI FATTIBILITÀ (can_travel_to)
# ------------------------------------------------------------------------------
func test_travel_feasibility_checks() -> void:
	print("\n--- TEST 4: CONTROLLI DI FATTIBILITÀ VIAGGIO ---")
	var player: PlayerData = PlayerDataScript.new()
	player.money = 500.0
	player.energy = 80
	player.stress = 20.0
	player.reputation = 10.0
	player.current_city_id = Enums.CityId.MILANO

	var travel_sys: TravelSystem = TravelSystemScript.new(player)

	# Destinazione coincidente
	var check_same: Dictionary = travel_sys.can_travel_to(Enums.CityId.MILANO)
	assert_equal(check_same.allowed, false, "Non si può viaggiare verso la città in cui ci si trova già")

	# Destinazione consentita (Bologna)
	var check_bo: Dictionary = travel_sys.can_travel_to(Enums.CityId.BOLOGNA)
	assert_equal(check_bo.allowed, true, "Viaggio per Bologna consentito con risorse sufficienti")

	# Reputazione insufficiente per Londra (richiede 30.0, player ha 10.0)
	var check_lon: Dictionary = travel_sys.can_travel_to(Enums.CityId.LONDRA)
	assert_equal(check_lon.allowed, false, "Viaggio per Londra bloccato per reputazione insufficiente")
	assert_equal(check_lon.reason, "reputation_insufficient", "Ragione blocco: reputation_insufficient")

	# Denaro insufficiente
	player.money = 5.0
	var check_broke: Dictionary = travel_sys.can_travel_to(Enums.CityId.BOLOGNA)
	assert_equal(check_broke.allowed, false, "Viaggio bloccato se fondi insufficienti")
	assert_equal(check_broke.reason, "money_insufficient", "Ragione blocco: money_insufficient")

	# Energia insufficiente
	player.money = 500.0
	player.energy = 5
	var check_tired: Dictionary = travel_sys.can_travel_to(Enums.CityId.BOLOGNA)
	assert_equal(check_tired.allowed, false, "Viaggio bloccato se energia insufficiente")
	assert_equal(check_tired.reason, "energy_insufficient", "Ragione blocco: energy_insufficient")

# ------------------------------------------------------------------------------
# 5. ESECUZIONE VIAGGIO & STATO GIOCATORE
# ------------------------------------------------------------------------------
func test_travel_execution_and_player_state() -> void:
	print("\n--- TEST 5: ESECUZIONE VIAGGIO & DECURTAZIONE RISORSE ---")
	var player: PlayerData = PlayerDataScript.new()
	player.current_city_id = Enums.CityId.MILANO
	player.money = 1000.0
	player.energy = 100
	player.stress = 10.0
	player.reputation = 50.0

	var travel_sys: TravelSystem = TravelSystemScript.new(player)

	var calc: Dictionary = travel_sys.calculate_travel_cost(Enums.CityId.MILANO, Enums.CityId.ROMA)
	var cost: float = calc.money_cost
	var energy_loss: int = calc.energy_cost
	var stress_add: int = calc.stress_cost

	var result: Dictionary = travel_sys.travel_to(Enums.CityId.ROMA)
	assert_true(result.success, "Spostamento Milano -> Roma completato con successo")
	assert_equal(travel_sys.current_city_id, Enums.CityId.ROMA, "La città corrente in TravelSystem è ora Roma")
	assert_equal(player.current_city_id, Enums.CityId.ROMA, "La città corrente in PlayerData è sincronizzata a Roma")

	assert_almost_equal(player.money, 1000.0 - cost, 0.01, "Denaro decurtato correttamente")
	assert_equal(player.energy, 100 - energy_loss, "Energia decurtata correttamente")
	assert_almost_equal(player.stress, 10.0 + float(stress_add), 0.01, "Stress incrementato correttamente")

# ------------------------------------------------------------------------------
# 6. TERRITORIALITÀ FAN & RIVERBERO NAZIONALE/INTERNAZIONALE
# ------------------------------------------------------------------------------
func test_territorial_fans_and_reverberation() -> void:
	print("\n--- TEST 6: TERRITORIALITÀ FAN & RIVERBERO ---")
	var player: PlayerData = PlayerDataScript.new()
	player.fans = 100
	player.current_city_id = Enums.CityId.MILANO

	var travel_sys: TravelSystem = TravelSystemScript.new(player)
	player.city_fans = {
		Enums.CityId.MILANO: 100,
		Enums.CityId.BOLOGNA: 0,
		Enums.CityId.ROMA: 0,
		Enums.CityId.NAPOLI: 0,
		Enums.CityId.LONDRA: 0,
		Enums.CityId.BERLINO: 0
	}

	# Aggiungiamo 100 fan a Bologna:
	# 85% vanno a Bologna (+85), 15% distribuiti con riverbero (+1 fan a ciascuna delle altre 15 metropoli)
	travel_sys.add_fans_in_city(Enums.CityId.BOLOGNA, 100)

	var bo_fans: int = travel_sys.get_fans_in_city(Enums.CityId.BOLOGNA)
	assert_equal(bo_fans, 85, "Bologna riceve l'85% dei nuovi fan (85 fan)")

	var mi_fans: int = travel_sys.get_fans_in_city(Enums.CityId.MILANO)
	assert_equal(mi_fans, 101, "Milano riceve il riverbero (+1 fan = 101)")

	var ro_fans: int = travel_sys.get_fans_in_city(Enums.CityId.ROMA)
	assert_equal(ro_fans, 1, "Roma riceve il riverbero (+1 fan)")

	assert_equal(player.fans, 200, "Il totale dei fan su tutte le città ammonta a 200 (100 iniziali + 85 locali + 15 riverbero)")

	# Modifica popolarità locale
	travel_sys.modify_popularity_in_city(Enums.CityId.ROMA, 25.0)
	assert_almost_equal(travel_sys.get_popularity_in_city(Enums.CityId.ROMA), 25.0, 0.01, "Popolarità a Roma aumentata a 25.0")
	travel_sys.modify_popularity_in_city(Enums.CityId.ROMA, 90.0)
	assert_almost_equal(travel_sys.get_popularity_in_city(Enums.CityId.ROMA), 100.0, 0.01, "Popolarità clampata a massimo 100.0")
	travel_sys.modify_popularity_in_city(Enums.CityId.ROMA, -150.0)
	assert_almost_equal(travel_sys.get_popularity_in_city(Enums.CityId.ROMA), 0.0, 0.01, "Popolarità clampata a minimo 0.0")

# ------------------------------------------------------------------------------
# 7. FILTRO LOCALI DELLA CITTÀ ATTUALE
# ------------------------------------------------------------------------------
func test_current_city_venues() -> void:
	print("\n--- TEST 7: LOCALI DELLA CITTÀ ATTUALE ---")
	var travel_sys: TravelSystem = TravelSystemScript.new()
	travel_sys.current_city_id = Enums.CityId.NAPOLI

	var napoli_venues: Array[VenueData] = travel_sys.get_current_city_venues()
	assert_true(napoli_venues.size() > 0, "Napoli ha almeno un locale disponibile")

	var has_scugnizzo: bool = false
	for v: VenueData in napoli_venues:
		if v.name.find("Spaccanapoli") != -1 or v.name.find("Palapartenope") != -1 or v.id.find("napoli") != -1:
			has_scugnizzo = true
			break
	assert_true(has_scugnizzo, "Napoli espone locali specifici del territorio partenopeo")

	travel_sys.current_city_id = Enums.CityId.BERLINO
	var berlin_venues: Array[VenueData] = travel_sys.get_current_city_venues()
	var has_kraft: bool = false
	for v: VenueData in berlin_venues:
		if v.name.find("Kreuzberg") != -1 or v.name.find("Columbiahalle") != -1 or v.id.find("berlin") != -1:
			has_kraft = true
			break
	assert_true(has_kraft, "Berlino espone locali berlinesi (underground/techno/industrial)")

# ------------------------------------------------------------------------------
# 8. INTEGRAZIONE AFFINITÀ GENERE IN CONCERT SYSTEM
# ------------------------------------------------------------------------------
func test_concert_system_city_affinity_integration() -> void:
	print("\n--- TEST 8: INTEGRAZIONE AFFINITÀ GENERE NEL CONCERTO ---")
	var player: PlayerData = PlayerDataScript.new()
	player.current_city_id = Enums.CityId.BERLINO
	player.money = 500.0
	player.energy = 80
	player.popularity = 30.0
	player.reputation = 60.0
	player.skills = { "performance": 80, "charisma": 80 }

	if GameManager:
		GameManager.player_data = player
		if GameManager.travel_system:
			GameManager.travel_system.player_data = player
			GameManager.travel_system.current_city_id = Enums.CityId.BERLINO

	var concert_sys: ConcertSystem = ConcertSystemScript.new(player)
	var travel_sys: TravelSystem = TravelSystemScript.new(player)
	travel_sys.current_city_id = Enums.CityId.BERLINO

	# Canzone Elettronica a Berlino: bonus affinità 1.35x (+35%)
	var electro_song: SongData = SongDataScript.new("s_elec", "Techno Pulse", Enums.MusicalGenre.ELECTRONIC, "Nightlife")
	electro_song.quality_score = 80.0
	electro_song.status = Enums.SongStatus.PRODUCED

	var berlin_venue: VenueData = travel_sys.get_current_city_venues()[0]
	var setlist: Array[SongData] = [electro_song]

	var result: Dictionary = concert_sys.resolve_concert(berlin_venue, setlist, 8.0)
	assert_true(result.get("success", false), "Concerto a Berlino eseguito con successo")
	assert_true(result.has("city_affinity_mult"), "Il risultato del concerto include city_affinity_mult")
	assert_true(result.city_affinity_mult >= 1.30, "A Berlino la canzone Elettronica ottiene bonus affinità >= 1.30")
	if GameManager and GameManager.travel_system:
		assert_true(GameManager.travel_system.get_fans_in_city(Enums.CityId.BERLINO) > 0, "I fan del concerto sono stati accreditati alla città di Berlino")

# ------------------------------------------------------------------------------
# 8b. VOLI TRANSOCEANICI, FATICA & STATUS JET LAG (SEZIONE 6)
# ------------------------------------------------------------------------------
func test_transoceanic_travel_and_jet_lag() -> void:
	print("\n--- TEST 8b: VOLI TRANSOCEANICI & STATUS JET LAG ---")
	var player: PlayerData = PlayerDataScript.new()
	player.current_city_id = Enums.CityId.MILANO
	player.money = 5000.0
	player.energy = 100
	player.stress = 0.0
	player.reputation = 60.0

	var travel_sys: TravelSystem = TravelSystemScript.new(player)

	# Verifica calcolo costi transoceanici (Milano -> New York)
	var calc := travel_sys.calculate_travel_cost(Enums.CityId.MILANO, Enums.CityId.NEW_YORK)
	assert_true(calc.get("is_transoceanic", false), "La tratta Milano -> New York è rilevata come transoceanica")
	assert_true(calc.money_cost >= 800.0, "Volo transoceanico costa >= 800 €")
	assert_true(calc.energy_cost >= 40, "Fatica transoceanica consuma >= 40 energia")
	assert_true(calc.stress_cost >= 20, "Fatica transoceanica genera >= 20 stress")

	# Esecuzione volo
	var res := travel_sys.travel_to(Enums.CityId.NEW_YORK)
	assert_true(res.success, "Volo per New York completato con successo")
	assert_equal(player.jet_lag_days, 2, "Applicati 2 giorni di status Jet Lag")
	assert_true(player.visited_city_stickers.has(Enums.CityId.NEW_YORK), "Adesivo di New York aggiunto alla collezione")

# ------------------------------------------------------------------------------
# 8c. EVENTI TEMPORANEI CITTADINI & MOLTIPLICATORI CONCERTO (SEZIONE 6)
# ------------------------------------------------------------------------------
func test_city_events_and_concert_multipliers() -> void:
	print("\n--- TEST 8c: EVENTI CITTADINI & CONCERTI ---")
	var player: PlayerData = PlayerDataScript.new()
	player.current_city_id = Enums.CityId.ROMA
	player.money = 1000.0
	player.energy = 100
	player.popularity = 40.0
	player.reputation = 40.0
	player.skills = { "performance": 75, "charisma": 75 }

	var travel_sys: TravelSystem = TravelSystemScript.new(player)
	travel_sys.current_city_id = Enums.CityId.ROMA

	if GameManager:
		GameManager.player_data = player
		GameManager.travel_system = travel_sys

	# Imposta Notte Bianca a Roma
	travel_sys.set_city_event(Enums.CityId.ROMA, Enums.CityEventType.WHITE_NIGHT)
	var active_evt := travel_sys.get_active_city_event(Enums.CityId.ROMA)
	assert_equal(active_evt.type, Enums.CityEventType.WHITE_NIGHT, "Notte Bianca attiva a Roma")
	assert_almost_equal(active_evt.audience_mult, 2.0, 0.01, "Moltiplicatore pubblico Notte Bianca: 2.0x")

	# Concerto a Roma durante Notte Bianca
	var concert_sys: ConcertSystem = ConcertSystemScript.new(player)
	var song: SongData = SongDataScript.new("s_roma", "Canzone Romana", Enums.MusicalGenre.ROCK, "Romantica")
	song.quality_score = 75.0
	song.status = Enums.SongStatus.PRODUCED

	var roma_venue: VenueData = travel_sys.get_current_city_venues()[0]
	var res := concert_sys.resolve_concert(roma_venue, [song], 10.0)
	assert_true(res.get("success", false), "Concerto eseguito con successo durante evento")
	assert_true(res.has("city_event_name"), "Risultato concerto include city_event_name")
	assert_almost_equal(float(res.city_event_audience_mult), 2.0, 0.01, "Moltiplicatore evento riflesso nel concerto (2.0x)")

	# Pulizia evento
	travel_sys.clear_city_event(Enums.CityId.ROMA)
	var cleared_evt := travel_sys.get_active_city_event(Enums.CityId.ROMA)
	assert_equal(cleared_evt.type, Enums.CityEventType.NONE, "Evento rimosso correttamente (NONE)")

# ------------------------------------------------------------------------------
# 9. RESA VOCALE LINEARE PER NVDA
# ------------------------------------------------------------------------------
func test_linear_nvda_travel_speech() -> void:
	print("\n--- TEST 9: RESA VOCALE LINEARE PER NVDA ---")
	var player: PlayerData = PlayerDataScript.new()
	player.money = 500.0
	player.energy = 80
	player.stress = 15.0
	player.reputation = 25.0
	player.current_city_id = Enums.CityId.MILANO

	var travel_sys: TravelSystem = TravelSystemScript.new(player)

	var speech: String = travel_sys.get_linear_travel_options_speech()
	assert_true(speech.length() > 0, "La stringa vocale non è vuota")
	assert_true(speech.find("Attualmente ti trovi a Milano") != -1, "La stringa indica la città attuale")
	assert_true(speech.find("Bologna") != -1, "La stringa include Bologna")
	assert_true(speech.find("Londra") != -1, "La stringa include Londra")
	# Assenza di caratteri grafici box-drawing ASCII per NVDA
	assert_true(speech.find("┌") == -1 and speech.find("│") == -1 and speech.find("─") == -1, "Zero caratteri grafici box-drawing ASCII per NVDA")

# ------------------------------------------------------------------------------
# 10. SERIALIZZAZIONE E SALVATAGGIO / CARICAMENTO
# ------------------------------------------------------------------------------
func test_serialization_and_save_load() -> void:
	print("\n--- TEST 10: SERIALIZZAZIONE & SAVE/LOAD ---")
	var travel_sys: TravelSystem = TravelSystemScript.new()
	travel_sys.current_city_id = Enums.CityId.ROMA

	var save_dict: Dictionary = travel_sys.to_dict()
	assert_equal(save_dict.current_city_id, Enums.CityId.ROMA, "Serializzazione mantiene current_city_id")

	var loaded_sys: TravelSystem = TravelSystemScript.new()
	loaded_sys.from_dict(save_dict)
	assert_equal(loaded_sys.current_city_id, Enums.CityId.ROMA, "Ripristino carica correttamente current_city_id")
