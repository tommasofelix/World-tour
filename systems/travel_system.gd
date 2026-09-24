# res://systems/travel_system.gd
class_name TravelSystem
extends RefCounted

## Motore della Mappa Geografica, Spostamenti Interurbani e Fanbase Territoriale (F8.1)
## Governa il cambio di città, i costi dei biglietti, la fatica da viaggio,
## l'affinità di genere delle scene locali e il radicamento territoriale della band.

const CityDataScript = preload("res://data/models/city_data.gd")

var player_data: PlayerData
var calendar_data: CalendarData
var cities: Array[CityData] = []
var current_city_id: int = Enums.CityId.MILANO

func _init(p_player: PlayerData = null, p_calendar: CalendarData = null) -> void:
	player_data = p_player
	calendar_data = p_calendar
	cities = CityDataScript.get_all_cities()

	if player_data:
		current_city_id = player_data.current_city_id
		_ensure_player_city_data()

func _ensure_player_city_data() -> void:
	if not player_data:
		return
	for c in cities:
		if not player_data.city_fans.has(c.id):
			# Milano parte con i fan iniziali se presenti
			player_data.city_fans[c.id] = player_data.fans if c.id == Enums.CityId.MILANO else 0
		if not player_data.city_popularity.has(c.id):
			player_data.city_popularity[c.id] = player_data.popularity if c.id == Enums.CityId.MILANO else 0.0

## Recupera la struttura dati di una città dato il suo ID
func get_city_by_id(city_id: int) -> CityData:
	for c in cities:
		if c.id == city_id:
			return c
	return null

## Restituisce la città attuale in cui si trova la band
func get_current_city() -> CityData:
	return get_city_by_id(current_city_id)

## Restituisce i locali per concerti presenti nella città attuale
func get_current_city_venues() -> Array[VenueData]:
	var cur = get_current_city()
	return cur.venues if cur else []

## Calcola costi di viaggio, energia e stress tra due città
func calculate_travel_cost(from_city_id: int, to_city_id: int) -> Dictionary:
	if from_city_id == to_city_id:
		return {"money_cost": 0.0, "energy_cost": 0, "stress_cost": 0, "is_international": false, "is_transoceanic": false}

	var from_city = get_city_by_id(from_city_id)
	var to_city = get_city_by_id(to_city_id)
	var is_intl: bool = (from_city and from_city.is_international) or (to_city and to_city.is_international)
	var is_transoceanic: bool = false

	# Verifica transoceanico (se una delle città è oltreoceano rispetto all'altra)
	var from_ocean: bool = from_city and from_city.is_transoceanic
	var to_ocean: bool = to_city and to_city.is_transoceanic

	if from_ocean != to_ocean:
		# Da Europa/Italia a Americhe/Asia/Oceania o viceversa
		is_transoceanic = true
		is_intl = true
	elif from_ocean and to_ocean:
		# Entrambe oltreoceano: verifica se sullo stesso continente o trans-continentale/trans-pacifico
		var is_same_continent: bool = false
		if (from_city_id in [Enums.CityId.NEW_YORK, Enums.CityId.LOS_ANGELES]) and (to_city_id in [Enums.CityId.NEW_YORK, Enums.CityId.LOS_ANGELES]):
			is_same_continent = true
		elif (from_city_id in [Enums.CityId.SAO_PAULO, Enums.CityId.BUENOS_AIRES]) and (to_city_id in [Enums.CityId.SAO_PAULO, Enums.CityId.BUENOS_AIRES]):
			is_same_continent = true

		if is_same_continent:
			is_transoceanic = false
			is_intl = true
		else:
			is_transoceanic = true
			is_intl = true

	var money: float = 50.0
	var energy: int = 20
	var stress: int = 8

	if is_transoceanic:
		# Voli a lungo raggio transoceanici
		if from_city_id in [Enums.CityId.TOKYO, Enums.CityId.SYDNEY, Enums.CityId.SEOUL] or to_city_id in [Enums.CityId.TOKYO, Enums.CityId.SYDNEY, Enums.CityId.SEOUL]:
			money = 1150.0
			energy = 55
			stress = 30
		elif from_city_id in [Enums.CityId.SAO_PAULO, Enums.CityId.BUENOS_AIRES] or to_city_id in [Enums.CityId.SAO_PAULO, Enums.CityId.BUENOS_AIRES]:
			money = 1050.0
			energy = 52
			stress = 28
		elif from_city_id == Enums.CityId.LOS_ANGELES or to_city_id == Enums.CityId.LOS_ANGELES:
			money = 980.0
			energy = 50
			stress = 26
		else: # New York
			money = 850.0
			energy = 45
			stress = 22
	elif from_ocean and to_ocean:
		# Tratte continentali oltreoceano interne (es. NY-LA o San Paolo-Buenos Aires)
		if (from_city_id in [Enums.CityId.SAO_PAULO, Enums.CityId.BUENOS_AIRES]) and (to_city_id in [Enums.CityId.SAO_PAULO, Enums.CityId.BUENOS_AIRES]):
			money = 220.0
			energy = 25
			stress = 10
		else:
			money = 350.0
			energy = 30
			stress = 12
	else:
		# Matrice nazionale e continentale europea
		var pair_key := "%d_%d" % [mini(from_city_id, to_city_id), maxi(from_city_id, to_city_id)]
		match pair_key:
			"0_1": # Milano - Bologna (Breve)
				money = 35.0
				energy = 15
				stress = 5
			"0_2": # Milano - Roma (Medio)
				money = 75.0
				energy = 25
				stress = 10
			"0_3": # Milano - Napoli (Lungo nazionale)
				money = 110.0
				energy = 32
				stress = 14
			"1_2": # Bologna - Roma (Breve-Medio)
				money = 55.0
				energy = 18
				stress = 7
			"1_3": # Bologna - Napoli (Medio-Lungo)
				money = 85.0
				energy = 26
				stress = 11
			"2_3": # Roma - Napoli (Breve)
				money = 40.0
				energy = 14
				stress = 5
			"4_5": # Londra - Berlino (Internazionale tra capitali estere)
				money = 180.0
				energy = 35
				stress = 15
			_:
				# Viaggi europei internazionali
				if is_intl:
					money = 220.0
					energy = 45
					stress = 20
				else:
					money = 80.0
					energy = 25
					stress = 10

	return {
		"money_cost": money,
		"energy_cost": energy,
		"stress_cost": stress,
		"is_international": is_intl,
		"is_transoceanic": is_transoceanic
	}

## Verifica se il giocatore può viaggiare verso la città indicata
func can_travel_to(target_city_id: int) -> Dictionary:
	if not player_data:
		return {"allowed": false, "reason": "no_player_data", "message": "Dati giocatore non trovati."}

	if target_city_id == current_city_id:
		return {"allowed": false, "reason": "already_there", "message": "Ti trovi già in questa città."}

	var target_city = get_city_by_id(target_city_id)
	if not target_city:
		return {"allowed": false, "reason": "city_not_found", "message": "Città di destinazione non valida."}

	# Verifica reputazione per città estere
	if target_city.is_international and player_data.reputation < target_city.min_reputation_req:
		return {
			"allowed": false,
			"reason": "reputation_insufficient",
			"message": "Reputazione insufficiente per la scena internazionale di %s (%.1f richiesta, attuale: %.1f)." % [
				target_city.name, target_city.min_reputation_req, player_data.reputation
			]
		}

	var costs := calculate_travel_cost(current_city_id, target_city_id)
	if player_data.money < costs.money_cost:
		return {
			"allowed": false,
			"reason": "money_insufficient",
			"message": "Fondi insufficienti per il viaggio a %s (%.2f € richiesti, saldo: %.2f €)." % [
				target_city.name, costs.money_cost, player_data.money
			]
		}

	if player_data.energy < costs.energy_cost:
		return {
			"allowed": false,
			"reason": "energy_insufficient",
			"message": "Troppo stanco per affrontare il viaggio a %s (%d energia richiesta, disponibile: %d)." % [
				target_city.name, costs.energy_cost, player_data.energy
			]
		}

	return {
		"allowed": true,
		"reason": "ok",
		"message": "Pronto a partire per %s!" % target_city.name,
		"costs": costs
	}

## Esegue il viaggio verso la città di destinazione
func travel_to(target_city_id: int) -> Dictionary:
	var check := can_travel_to(target_city_id)
	if not check.allowed:
		return {"success": false, "reason": check.reason, "message": check.message}

	var costs: Dictionary = check.costs
	var old_city_id: int = current_city_id
	var target_city = get_city_by_id(target_city_id)

	# Deduzione spese e fatica
	player_data.modify_money(-costs.money_cost)
	EventBus.money_changed.emit(player_data.money, -costs.money_cost, "Viaggio a %s" % target_city.name)

	player_data.consume_energy(costs.energy_cost)
	player_data.add_stress(costs.stress_cost)

	# Status Jet Lag per voli transoceanici
	var jet_lag_applied: bool = false
	if costs.get("is_transoceanic", false):
		player_data.jet_lag_days = 2
		jet_lag_applied = true

	# Colleziona adesivo città sul veicolo della band
	var new_sticker_unlocked: bool = false
	if not player_data.visited_city_stickers.has(target_city_id):
		player_data.visited_city_stickers.append(target_city_id)
		new_sticker_unlocked = true

	# Aggiornamento posizione
	current_city_id = target_city_id
	player_data.current_city_id = target_city_id
	_ensure_player_city_data()

	EventBus.city_changed.emit(old_city_id, target_city_id)

	var speech: String = "Viaggio completato! Benvenuto a %s (%s). Spesa: %.2f euro. Energia consumata: %d. %s" % [
		target_city.name,
		target_city.country,
		costs.money_cost,
		costs.energy_cost,
		target_city.description
	]
	if jet_lag_applied:
		speech += " ATTENZIONE: Volo transoceanico completato! La band risente del Jet Lag per 2 giorni (-20% efficienza riposo)."
	if new_sticker_unlocked:
		speech += " Nuovo adesivo di %s applicato sul retro del veicolo della band!" % target_city.name

	AccessibilityManager.announce(speech, true)

	return {
		"success": true,
		"from_city": old_city_id,
		"to_city": target_city_id,
		"city_name": target_city.name,
		"money_spent": costs.money_cost,
		"energy_spent": costs.energy_cost,
		"stress_gained": costs.stress_cost,
		"is_transoceanic": costs.get("is_transoceanic", false),
		"jet_lag_applied": jet_lag_applied,
		"new_sticker": new_sticker_unlocked,
		"message": speech
	}

# ==============================================================================
# GESTIONE DELLA FANBASE TERRITORIALE & NOTORIETÀ LOCALE
# ==============================================================================

## Restituisce il numero di fan residenti in una specifica città
func get_fans_in_city(city_id: int) -> int:
	_ensure_player_city_data()
	return int(player_data.city_fans.get(city_id, 0)) if player_data else 0

## Restituisce la popolarità percentuale in una specifica città
func get_popularity_in_city(city_id: int) -> float:
	_ensure_player_city_data()
	return float(player_data.city_popularity.get(city_id, 0.0)) if player_data else 0.0

## Aggiunge nuovi fan fidelizzati prioritariamente alla città specificata
func add_fans_in_city(city_id: int, new_fans: int) -> void:
	if not player_data or new_fans <= 0:
		return
	_ensure_player_city_data()

	var local_share: int = int(round(float(new_fans) * 0.85))
	var national_overflow: int = new_fans - local_share

	# Accredito locale principale
	player_data.city_fans[city_id] = get_fans_in_city(city_id) + local_share

	# Riverbero percentuale distribuito sulle altre città
	var other_cities: Array[CityData] = []
	for c in cities:
		if c.id != city_id:
			other_cities.append(c)
	if not other_cities.is_empty() and national_overflow > 0:
		var per_city: int = maxi(1, int(floor(float(national_overflow) / float(other_cities.size()))))
		for oc in other_cities:
			player_data.city_fans[oc.id] = get_fans_in_city(oc.id) + per_city

	# Ricalcolo totale complessivo dei fan
	var total: int = 0
	for cid in player_data.city_fans:
		total += int(player_data.city_fans[cid])
	player_data.fans = total

## Modifica la popolarità percentuale nella città indicata
func modify_popularity_in_city(city_id: int, delta: float) -> void:
	if not player_data:
		return
	_ensure_player_city_data()

	var cur_pop: float = get_popularity_in_city(city_id)
	var new_pop: float = clampf(cur_pop + delta, 0.0, 100.0)
	player_data.city_popularity[city_id] = new_pop

	# Aggiorna la popolarità globale come media ponderata (con peso doppio per la capitale/Milano)
	var sum_pop: float = 0.0
	for cid in player_data.city_popularity:
		sum_pop += float(player_data.city_popularity[cid])
	player_data.popularity = clampf(sum_pop / float(maxi(1, cities.size())), 0.0, 100.0)

# ==============================================================================
# EVENTI CITTADINI TEMPORANEI (NOTTE BIANCA, FIERA MUSICA, FESTIVAL URBANO)
# ==============================================================================

var city_event_overrides: Dictionary = {}

func set_city_event(city_id: int, event_type: int) -> void:
	city_event_overrides[city_id] = event_type

func clear_city_event(city_id: int) -> void:
	city_event_overrides.erase(city_id)

## Restituisce l'evento temporaneo attivo nella città per la giornata indicata
func get_active_city_event(city_id: int, day_number: int = -1) -> Dictionary:
	var day: int = day_number if day_number > 0 else (calendar_data.day_number if calendar_data else 1)

	var event_type: int = Enums.CityEventType.NONE
	if city_event_overrides.has(city_id):
		event_type = int(city_event_overrides[city_id])
	else:
		# Cicli temporali deterministici
		var nb_city: int = (day / 14) % maxi(1, cities.size())
		if city_id == nb_city and (day % 14 == 0 or day % 14 == 13):
			event_type = Enums.CityEventType.WHITE_NIGHT
		elif (day + city_id * 5) % 28 == 14 and city_id in [Enums.CityId.MILANO, Enums.CityId.LONDRA, Enums.CityId.BERLINO, Enums.CityId.NEW_YORK, Enums.CityId.TOKYO]:
			event_type = Enums.CityEventType.MUSIC_EXPO
		elif (day + city_id * 2) % 21 == 7:
			event_type = Enums.CityEventType.STREET_CULTURE_FEST

	match event_type:
		Enums.CityEventType.WHITE_NIGHT:
			return {
				"type": Enums.CityEventType.WHITE_NIGHT,
				"name": "Notte Bianca",
				"description": "Festa totale in città! Locali gremiti, affluenza concerti raddoppiata (+100%) e +50% conversione fan.",
				"audience_mult": 2.0,
				"fan_mult": 1.5,
				"rep_bonus": 2.0,
				"merch_mult": 1.5
			}
		Enums.CityEventType.MUSIC_EXPO:
			return {
				"type": Enums.CityEventType.MUSIC_EXPO,
				"name": "Fiera Internazionale della Musica",
				"description": "Raduno dell'industria discografica: requisiti etichette/manager -20%, bonus +5.0 reputazione su qualsiasi show.",
				"audience_mult": 1.25,
				"fan_mult": 1.2,
				"rep_bonus": 5.0,
				"merch_mult": 1.2
			}
		Enums.CityEventType.STREET_CULTURE_FEST:
			return {
				"type": Enums.CityEventType.STREET_CULTURE_FEST,
				"name": "Festival Culturale Urbano",
				"description": "Celebrazione della musica indipendente nei pub e club: affluenza +35%, vendite merchandising +30%.",
				"audience_mult": 1.35,
				"fan_mult": 1.25,
				"rep_bonus": 1.0,
				"merch_mult": 1.30
			}
		_:
			return {
				"type": Enums.CityEventType.NONE,
				"name": "Nessun Evento",
				"description": "Attività ordinaria nella metropoli.",
				"audience_mult": 1.0,
				"fan_mult": 1.0,
				"rep_bonus": 0.0,
				"merch_mult": 1.0
			}

# ==============================================================================
# VOCALIZZAZIONE LINEARE PER SCREEN READER (NVDA / ZERO MOUSE)
# ==============================================================================

## Restituisce un elenco lineare ottimizzato per NVDA di tutte le destinazioni
func get_linear_travel_options_speech() -> String:
	var cur_city = get_current_city()
	var cur_name: String = cur_city.name if cur_city else "Milano"
	var lines: Array[String] = []
	lines.append("Rete Viaggi World-Tour: Attualmente ti trovi a %s." % cur_name)

	var idx: int = 1
	for c in cities:
		if c.id == current_city_id:
			continue
		var costs := calculate_travel_cost(current_city_id, c.id)
		var check := can_travel_to(c.id)
		var status_str: String = "Disponibile" if check.allowed else ("Non disponibile: %s" % check.message)
		var fans_count: int = get_fans_in_city(c.id)
		var ev := get_active_city_event(c.id)
		var ev_text: String = " [Evento: %s]" % ev.name if ev.type != Enums.CityEventType.NONE else ""
		var flight_text: String = " (Volo Intercontinentale)" if costs.get("is_transoceanic", false) else ""

		lines.append("Destinazione %d: %s (%s)%s%s. Costo: %.2f euro, fatica: %d energia. Fan locali: %d. Stato: %s." % [
			idx,
			c.name,
			c.country,
			flight_text,
			ev_text,
			costs.money_cost,
			costs.energy_cost,
			fans_count,
			status_str
		])
		idx += 1

	return " ".join(lines)

## Descrizione dettagliata della posizione corrente
func get_current_location_speech() -> String:
	var cur = get_current_city()
	if not cur:
		return "Posizione attuale non determinata."
	var fans_here: int = get_fans_in_city(cur.id)
	var pop_here: float = get_popularity_in_city(cur.id)
	var cur_ev := get_active_city_event(cur.id)
	var ev_info: String = " Evento oggi: %s (%s)." % [cur_ev.name, cur_ev.description] if cur_ev.type != Enums.CityEventType.NONE else ""
	var jet_info: String = " ATTENZIONE: Jet Lag attivo per ancora %d giorni!" % player_data.jet_lag_days if (player_data and player_data.jet_lag_days > 0) else ""
	return "Posizione: %s (%s). Fan in questa città: %d. Notorietà locale: %.1f%%. Locali disponibili: %d.%s%s" % [
		cur.name,
		cur.country,
		fans_here,
		pop_here,
		cur.venues.size(),
		ev_info,
		jet_info
	]

# ==============================================================================
# SERIALIZZAZIONE & SALVATAGGIO
# ==============================================================================

func to_dict() -> Dictionary:
	return {
		"current_city_id": current_city_id,
		"city_event_overrides": city_event_overrides.duplicate()
	}

func from_dict(dict: Dictionary) -> void:
	current_city_id = int(dict.get("current_city_id", current_city_id))
	city_event_overrides.clear()
	if dict.has("city_event_overrides") and dict["city_event_overrides"] is Dictionary:
		for cid in dict["city_event_overrides"]:
			city_event_overrides[int(cid)] = int(dict["city_event_overrides"][cid])
	if player_data:
		player_data.current_city_id = current_city_id
		_ensure_player_city_data()
