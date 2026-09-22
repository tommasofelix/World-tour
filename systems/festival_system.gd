# GDD 2.0 / SP-11: Sottosistema Gestione Grandi Festival Estivi
class_name FestivalSystem
extends RefCounted

## Riferimento ai dati giocatore
var player_data: PlayerData

## Riferimento ai dati calendario
var calendar_data: CalendarData

## Riferimento a TravelSystem per riverbero e geografia
var travel_system: RefCounted

## Riferimento a ScheduleSystem per impegni a calendario
var schedule_system: RefCounted

## Riferimento a BandSystem per dinamiche di gruppo
var band_system: RefCounted

## Catalogo dei festival registrati (id -> FestivalData)
var festivals: Dictionary = {}

func _init(
	p_player: PlayerData = null,
	p_calendar: CalendarData = null,
	p_travel: RefCounted = null,
	p_schedule: RefCounted = null,
	p_band: RefCounted = null
) -> void:
	player_data = p_player
	calendar_data = p_calendar
	travel_system = p_travel
	schedule_system = p_schedule
	band_system = p_band
	_init_festival_catalog()

## Inizializza il catalogo predefinito dei 6 grandi festival continentali
func _init_festival_catalog() -> void:
	festivals.clear()
	
	# 1. MILANO: Rock in Milano Open Air
	var fest_mi := FestivalData.new(
		"fest_milano",
		"Rock in Milano Open Air",
		Enums.CityId.MILANO,
		"Idroscalo Arena",
		92, # Mese 4 (Giugno)
		4,
		35000,
		[Enums.MusicalGenre.ROCK, Enums.MusicalGenre.ELECTRONIC, Enums.MusicalGenre.POP],
		"The Chrome Shadows",
		74.0
	)
	festivals["fest_milano"] = fest_mi
	
	# 2. BOLOGNA: Independent Summer Fest
	var fest_bo := FestivalData.new(
		"fest_bologna",
		"Independent Summer Fest",
		Enums.CityId.BOLOGNA,
		"Arena Parco Nord",
		120, # Mese 5 (Luglio)
		5,
		20000,
		[Enums.MusicalGenre.INDIE, Enums.MusicalGenre.ROCK],
		"I Ribelli del Pratello",
		72.0
	)
	festivals["fest_bologna"] = fest_bo
	
	# 3. ROMA: Roma Rock & Live Fest
	var fest_ro := FestivalData.new(
		"fest_roma",
		"Roma Rock & Live Fest",
		Enums.CityId.ROMA,
		"Ippodromo delle Capannelle",
		134, # Mese 5 (Luglio)
		5,
		40000,
		[Enums.MusicalGenre.ROCK, Enums.MusicalGenre.POP],
		"Colosseo Sound Machine",
		76.0
	)
	festivals["fest_roma"] = fest_ro
	
	# 4. NAPOLI: Partenope Sound Fest
	var fest_na := FestivalData.new(
		"fest_napoli",
		"Partenope Sound Fest",
		Enums.CityId.NAPOLI,
		"Arenile di Bagnoli",
		152, # Mese 6 (Agosto)
		6,
		25000,
		[Enums.MusicalGenre.HIPHOP, Enums.MusicalGenre.ROCK, Enums.MusicalGenre.POP],
		"Vesuvio Posse",
		75.0
	)
	festivals["fest_napoli"] = fest_na
	
	# 5. LONDRA: Hyde Park & Download Calling
	var fest_lo := FestivalData.new(
		"fest_londra",
		"Hyde Park & Download Calling",
		Enums.CityId.LONDRA,
		"Hyde Park Great Arena",
		104, # Mese 4 (Giugno)
		4,
		65000,
		[Enums.MusicalGenre.ROCK, Enums.MusicalGenre.METAL, Enums.MusicalGenre.INDIE],
		"Royal Camden Vanguard",
		82.0
	)
	festivals["fest_londra"] = fest_lo
	
	# 6. BERLINO: Berlin Electronic & Heavy Gathering
	var fest_be := FestivalData.new(
		"fest_berlino",
		"Berlin Electronic & Heavy Gathering",
		Enums.CityId.BERLINO,
		"Tempelhof Airfield",
		160, # Mese 6 (Agosto)
		6,
		50000,
		[Enums.MusicalGenre.ELECTRONIC, Enums.MusicalGenre.METAL, Enums.MusicalGenre.ROCK],
		"Klangwerk Berlin",
		80.0
	)
	festivals["fest_berlino"] = fest_be

## Restituisce tutti i festival del catalogo
func get_all_festivals() -> Array[FestivalData]:
	var list: Array[FestivalData] = []
	for fest in festivals.values():
		list.append(fest)
	return list

## Restituisce un festival tramite ID
func get_festival(fest_id: String) -> FestivalData:
	return festivals.get(fest_id, null)

## Restituisce i festival che si svolgono in una determinata città
func get_festivals_for_city(city_id: int) -> Array[FestivalData]:
	var result: Array[FestivalData] = []
	for fest: FestivalData in festivals.values():
		if fest.city_id == city_id:
			result.append(fest)
	return result

## Restituisce i festival per cui la band ha già prenotato uno slot
func get_booked_festivals() -> Array[FestivalData]:
	var result: Array[FestivalData] = []
	for fest: FestivalData in festivals.values():
		if fest.is_slot_booked() and not fest.is_completed:
			result.append(fest)
	return result

## Controlla se la band può candidarsi per un determinato slot del festival
func can_apply_for_slot(fest_id: String, slot: int) -> Dictionary:
	var fest: FestivalData = get_festival(fest_id)
	if not fest:
		return { "allowed": false, "reason": "festival_not_found" }
		
	if fest.is_completed:
		return { "allowed": false, "reason": "already_completed" }
		
	var cur_day: int = calendar_data.day_number if calendar_data else 1
	if fest.day_number < cur_day:
		return { "allowed": false, "reason": "festival_already_passed" }
		
	if fest.is_slot_booked():
		return { "allowed": false, "reason": "already_booked" }
		
	var specs: Dictionary = FestivalData.get_slot_specs(slot, fest.capacity)
	if specs.is_empty():
		return { "allowed": false, "reason": "invalid_slot" }
		
	var req_rep: float = specs.min_reputation
	var manager_fee_bonus: float = 0.0
	
	# Influenza del Manager sulla reputazione e cachet
	if player_data and player_data.has_manager():
		match player_data.active_manager.manager_type:
			Enums.ManagerType.PRO_INDIE:
				req_rep *= 0.80 # Sconto 20% sul requisito reputazione
				manager_fee_bonus = 0.25 # +25% cachet
			Enums.ManagerType.INDUSTRY_SHARK:
				req_rep *= 0.65 # Sconto 35% sul requisito reputazione
				manager_fee_bonus = 0.50 # +50% cachet
			Enums.ManagerType.TRUSTED_FRIEND:
				manager_fee_bonus = 0.10 # +10% cachet
				
	var player_rep: float = player_data.reputation if player_data else 0.0
	if player_rep < req_rep:
		return {
			"allowed": false,
			"reason": "reputation_insufficient",
			"required_reputation": req_rep,
			"current_reputation": player_rep
		}
		
	var effective_fee: float = specs.guaranteed_fee * (1.0 + manager_fee_bonus)
	
	return {
		"allowed": true,
		"reason": "ok",
		"effective_min_rep": req_rep,
		"effective_fee": effective_fee,
		"estimated_audience": specs.estimated_audience
	}

## Prenota ufficialmente lo slot al festival e sincronizza con l'Agenda
func book_festival_slot(fest_id: String, slot: int) -> Dictionary:
	var check := can_apply_for_slot(fest_id, slot)
	if not check.allowed:
		return check
		
	var fest: FestivalData = get_festival(fest_id)
	fest.booked_slot = slot
	
	# Sincronizzazione con ScheduleSystem
	if schedule_system and schedule_system.has_method("add_event"):
		const CalendarEventDataScript = preload("res://data/models/calendar_event_data.gd")
		var event_id: String = "fest_event_" + fest.id
		var event_title: String = fest.name + " (" + Enums.get_festival_slot_name(slot) + ")"
		var period: int = Enums.TimePeriod.EVENING
		if slot == Enums.FestivalSlot.OPENING_AFTERNOON:
			period = Enums.TimePeriod.AFTERNOON
		elif slot == Enums.FestivalSlot.HEADLINER_NIGHT:
			period = Enums.TimePeriod.NIGHT
			
		var event_data = CalendarEventDataScript.new(
			event_id,
			event_title,
			Enums.CalendarEventType.FESTIVAL,
			fest.day_number,
			period,
			fest.id,
			fest.location_name,
			true
		)
		event_data.city_id = fest.city_id
		event_data.details = { "festival_id": fest.id, "slot": slot, "rival": fest.rival_band_name }
		schedule_system.add_event(event_data)
		
	if EventBus and EventBus.has_signal("festival_slot_booked"):
		EventBus.emit_signal("festival_slot_booked", fest.id, slot)
		
	return {
		"success": true,
		"festival_id": fest.id,
		"slot": slot,
		"day_number": fest.day_number,
		"fee": check.effective_fee
	}

## Risoluzione del concerto al festival (live, cachet, merch massivo, Steal the Show)
func perform_festival_concert(
	fest_id: String,
	songs: Array = [],
	mock_concert_score: float = -1.0
) -> Dictionary:
	var fest: FestivalData = get_festival(fest_id)
	if not fest:
		return { "success": false, "reason": "festival_not_found" }
		
	if not fest.is_slot_booked():
		return { "success": false, "reason": "slot_not_booked" }
		
	if fest.is_completed:
		return { "success": false, "reason": "already_completed" }
		
	# Verifica posizione geografica
	if player_data and player_data.current_city_id != fest.city_id:
		return { "success": false, "reason": "not_in_festival_city", "required_city": fest.city_id }
		
	var specs: Dictionary = FestivalData.get_slot_specs(fest.booked_slot, fest.capacity)
	
	# Calcolo Concert Score
	var concert_score: float = 70.0
	if mock_concert_score >= 0.0:
		concert_score = mock_concert_score
	elif songs.size() > 0:
		var sum_q: float = 0.0
		var genre_match_count: int = 0
		for s in songs:
			var q: float = s.quality_score if "quality_score" in s else 60.0
			sum_q += q
			if "genre" in s and s.genre in fest.genre_focus:
				genre_match_count += 1
		concert_score = sum_q / float(songs.size())
		# Bonus affinità genere per festival (+10% score se la metà dei brani è in linea)
		if genre_match_count >= int(songs.size() / 2.0):
			concert_score = min(100.0, concert_score * 1.10)
	else:
		# Punteggio basato su abilità del giocatore se nessuna canzone fornita
		var instrument_level: int = player_data.instrument_level if player_data else 10
		concert_score = clamp(50.0 + float(instrument_level) * 3.5, 50.0, 95.0)
		
	# Calcolo Affluenza
	var base_aud: int = specs.estimated_audience
	var pop_factor: float = 1.0
	if player_data:
		pop_factor = clamp(0.60 + (player_data.popularity / 100.0) * 0.50, 0.60, 1.20)
	var actual_audience: int = int(base_aud * pop_factor)
	
	# Calcolo Introiti: Cachet Garantito + Merchandising
	var guaranteed_fee: float = specs.guaranteed_fee
	if player_data and player_data.has_manager():
		match player_data.active_manager.manager_type:
			Enums.ManagerType.PRO_INDIE:
				guaranteed_fee *= 1.25
			Enums.ManagerType.INDUSTRY_SHARK:
				guaranteed_fee *= 1.50
			Enums.ManagerType.TRUSTED_FRIEND:
				guaranteed_fee *= 1.10
				
	# Vendite Merchandising Intensive (moltiplicatore x2.5 a x5.5)
	var merch_per_head: float = 0.75 # spesa media base
	var merch_revenue: float = actual_audience * merch_per_head * specs.merch_multiplier * (concert_score / 100.0)
	var gross_revenue: float = guaranteed_fee + merch_revenue
	
	# Commissione Manager
	var manager_cut: float = 0.0
	if player_data and player_data.has_manager():
		manager_cut = gross_revenue * player_data.active_manager.commission_pct
		
	var net_total: float = gross_revenue - manager_cut
	
	# Ripartizione Band
	var player_share: float = net_total
	var band_payout: float = 0.0
	if player_data and player_data.band_members.size() > 0:
		match player_data.revenue_split_mode:
			Enums.RevenueSplit.EQUAL_SPLIT:
				var total_members: int = player_data.band_members.size() + 1
				player_share = net_total / float(total_members)
				band_payout = net_total - player_share
			Enums.RevenueSplit.LEADER_BALANCED:
				player_share = net_total * 0.40
				band_payout = net_total * 0.60
			Enums.RevenueSplit.LEADER_PREDATORY:
				player_share = net_total * 0.70
				band_payout = net_total * 0.30
				
	if player_data:
		player_data.money += player_share
		
	# Dinamica "Rubare la Scena" (*Steal the Show*)
	var stole_the_show: bool = concert_score >= fest.rival_band_score
	var score_margin: float = concert_score - fest.rival_band_score
	
	var base_fan_rate: float = 0.06
	var new_fans: int = int(actual_audience * base_fan_rate * (concert_score / 100.0))
	var rep_gain: float = 2.0
	
	if stole_the_show:
		# Vittoria epica sul cartellone
		new_fans = int(new_fans * 1.30) # +30% fan
		rep_gain = 6.0
		if player_data:
			player_data.reputation += rep_gain
			player_data.morale = min(100.0, player_data.morale + 10.0)
		_apply_band_dynamics(10.0, 10.0, -15.0)
	else:
		if score_margin < -10.0:
			# Battuti nettamente dalla rivale
			rep_gain = 1.0
			if player_data:
				player_data.reputation += rep_gain
				player_data.morale = max(0.0, player_data.morale - 5.0)
			_apply_band_dynamics(0.0, 0.0, 12.0)
		else:
			# Prestazione comunque solida
			rep_gain = 3.0
			if player_data:
				player_data.reputation += rep_gain
				
	# Accredito Fan con Territorialità (85% città, 15% riverbero nazionale)
	if travel_system and travel_system.has_method("add_fans_in_city"):
		travel_system.add_fans_in_city(fest.city_id, new_fans)
	elif player_data:
		player_data.fans += new_fans
		
	# Consumo Energia & Stress
	if player_data:
		player_data.consume_energy(specs.energy_cost)
		player_data.add_stress(specs.stress_gain)
		
	# Chiusura e salvataggio esito
	fest.is_completed = true
	var result_data := {
		"success": true,
		"festival_id": fest.id,
		"festival_name": fest.name,
		"city_id": fest.city_id,
		"slot": fest.booked_slot,
		"slot_name": Enums.get_festival_slot_name(fest.booked_slot),
		"concert_score": concert_score,
		"rival_band_name": fest.rival_band_name,
		"rival_band_score": fest.rival_band_score,
		"stole_the_show": stole_the_show,
		"actual_audience": actual_audience,
		"guaranteed_fee": guaranteed_fee,
		"merch_revenue": merch_revenue,
		"gross_revenue": gross_revenue,
		"manager_cut": manager_cut,
		"player_share": player_share,
		"band_payout": band_payout,
		"new_fans": new_fans,
		"reputation_gain": rep_gain,
		"energy_spent": specs.energy_cost,
		"stress_gained": specs.stress_gain
	}
	fest.performance_result = result_data
	
	if EventBus and EventBus.has_signal("festival_performed"):
		EventBus.emit_signal("festival_performed", fest.id, result_data)
		
	return result_data

## Resa vocale lineare per NVDA dell'elenco festival
func get_festival_list_speech() -> String:
	var speech := "Grandi Festival Estivi Disponibili. "
	var count := 1
	for fest: FestivalData in get_all_festivals():
		var status_str := "Non prenotato"
		if fest.is_completed:
			status_str = "Concluso"
		elif fest.is_slot_booked():
			status_str = "Prenotato: " + Enums.get_festival_slot_name(fest.booked_slot)
			
		speech += "%d: %s a %s. Giorno %d (Mese %d). Capienza: %d. Rivale: %s. Stato: %s. " % [
			count,
			fest.name,
			Enums.get_city_name(fest.city_id),
			fest.day_number,
			fest.season_month,
			fest.capacity,
			fest.rival_band_name,
			status_str
		]
		count += 1
	return speech.strip_edges()

## Resa vocale lineare dei dettagli di un festival specifico
func get_festival_details_speech(fest_id: String) -> String:
	var fest: FestivalData = get_festival(fest_id)
	if not fest:
		return "Festival non trovato."
		
	var speech := "Festival: %s. Città: %s. Arena: %s. Giorno: %d (Mese %d). Capienza massima: %d persone. " % [
		fest.name,
		Enums.get_city_name(fest.city_id),
		fest.location_name,
		fest.day_number,
		fest.season_month,
		fest.capacity
	]
	
	speech += "Rivale sul cartellone: %s, punteggio benchmark %d. " % [
		fest.rival_band_name,
		int(fest.rival_band_score)
	]
	
	if fest.is_slot_booked():
		speech += "Slot attuale: %s. " % Enums.get_festival_slot_name(fest.booked_slot)
		if fest.is_completed:
			speech += "Edizione completata. "
	else:
		speech += "Slot selezionabili: 1 Pomeriggio, 2 Tramonto, 3 Headliner. "
		
	return speech.strip_edges()

## Serializzazione dizionario per il savegame
func to_dict() -> Dictionary:
	var fests_data: Dictionary = {}
	for f_id in festivals.keys():
		fests_data[f_id] = festivals[f_id].to_dict()
	return {
		"festivals": fests_data
	}

## Deserializzazione dal savegame
func from_dict(d: Dictionary) -> void:
	var fests_data: Dictionary = d.get("festivals", {})
	for f_id in fests_data.keys():
		if festivals.has(f_id):
			festivals[f_id].from_dict(fests_data[f_id])
		else:
			var new_fest := FestivalData.new()
			new_fest.from_dict(fests_data[f_id])
			festivals[f_id] = new_fest

func _apply_band_dynamics(affinity_delta: float, respect_delta: float, tension_delta: float) -> void:
	if not player_data:
		return
	for m in player_data.get_active_band_members():
		m.modify_affinity(affinity_delta)
		m.modify_respect(respect_delta)
		m.modify_tension(tension_delta)
	if band_system and band_system.has_method("_emit_chemistry_changed"):
		band_system._emit_chemistry_changed()

