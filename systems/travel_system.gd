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
		return {"money_cost": 0.0, "energy_cost": 0, "stress_cost": 0, "is_international": false}
		
	var from_city = get_city_by_id(from_city_id)
	var to_city = get_city_by_id(to_city_id)
	var is_intl: bool = (from_city and from_city.is_international) or (to_city and to_city.is_international)
	
	# Matrice distanze/costi standard
	var money: float = 50.0
	var energy: int = 20
	var stress: int = 8
	
	# Coppie specifiche nazionali
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
			# Viaggi internazionali dall'Italia verso Londra o Berlino
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
		"is_international": is_intl
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
	AccessibilityManager.announce(speech, true)
	
	return {
		"success": true,
		"from_city": old_city_id,
		"to_city": target_city_id,
		"city_name": target_city.name,
		"money_spent": costs.money_cost,
		"energy_spent": costs.energy_cost,
		"stress_gained": costs.stress_cost,
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
		
		lines.append("Destinazione %d: %s (%s). Costo: %.2f euro, fatica: %d energia. Fan locali: %d. Stato: %s." % [
			idx,
			c.name,
			c.country,
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
	return "Posizione: %s (%s). Fan in questa città: %d. Notorietà locale: %.1f%%. Locali disponibili: %d." % [
		cur.name,
		cur.country,
		fans_here,
		pop_here,
		cur.venues.size()
	]

# ==============================================================================
# SERIALIZZAZIONE & SALVATAGGIO
# ==============================================================================

func to_dict() -> Dictionary:
	return {
		"current_city_id": current_city_id
	}

func from_dict(dict: Dictionary) -> void:
	current_city_id = int(dict.get("current_city_id", current_city_id))
	if player_data:
		player_data.current_city_id = current_city_id
		_ensure_player_city_data()
