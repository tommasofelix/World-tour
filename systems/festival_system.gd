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

	# 7. DUBLINO: St. Patrick & Celtic Rock Fest
	var fest_du := FestivalData.new(
		"fest_dublino",
		"St. Patrick & Celtic Rock Fest",
		Enums.CityId.DUBLINO,
		"Phoenix Park Great Lawn",
		100, # Mese 4 (Giugno)
		4,
		45000,
		[Enums.MusicalGenre.ROCK, Enums.MusicalGenre.INDIE, Enums.MusicalGenre.POP],
		"Celtic Fiddle Rebels",
		78.0
	)
	festivals["fest_dublino"] = fest_du
	
	# 8. PARIGI: Festival de l'Étoile & French Touch
	var fest_pa := FestivalData.new(
		"fest_parigi",
		"Festival de l'Étoile & French Touch",
		Enums.CityId.PARIGI,
		"Bois de Boulogne Arena",
		128, # Mese 5 (Luglio)
		5,
		55000,
		[Enums.MusicalGenre.ELECTRONIC, Enums.MusicalGenre.POP, Enums.MusicalGenre.INDIE],
		"Le Syndicate Neon",
		81.0
	)
	festivals["fest_parigi"] = fest_pa
	
	# 9. MADRID: Festival Sol y Fuego
	var fest_ma := FestivalData.new(
		"fest_madrid",
		"Festival Sol y Fuego",
		Enums.CityId.MADRID,
		"Parque del Retiro Live Arena",
		146, # Mese 6 (Agosto)
		6,
		40000,
		[Enums.MusicalGenre.ROCK, Enums.MusicalGenre.POP, Enums.MusicalGenre.HIPHOP],
		"Torero Electric Band",
		77.0
	)
	festivals["fest_madrid"] = fest_ma
	
	# 10. NEW YORK: Central Park Global Megafest
	var fest_ny := FestivalData.new(
		"fest_new_york",
		"Central Park Global Megafest",
		Enums.CityId.NEW_YORK,
		"Central Park Great Meadow",
		116, # Mese 5 (Luglio)
		5,
		70000,
		[Enums.MusicalGenre.HIPHOP, Enums.MusicalGenre.ROCK, Enums.MusicalGenre.POP],
		"Gotham Underground Kings",
		85.0
	)
	festivals["fest_new_york"] = fest_ny
	
	# 11. LOS ANGELES: Sunset Boulevard Summer Open Air
	var fest_la := FestivalData.new(
		"fest_los_angeles",
		"Sunset Boulevard Summer Open Air",
		Enums.CityId.LOS_ANGELES,
		"Hollywood Bowl Pavilion",
		108, # Mese 4 (Giugno)
		4,
		60000,
		[Enums.MusicalGenre.POP, Enums.MusicalGenre.ROCK, Enums.MusicalGenre.ELECTRONIC],
		"Sunset Strip Sirens",
		83.0
	)
	festivals["fest_los_angeles"] = fest_la
	
	# 12. TOKYO: Tokyo Neo Sound Festival
	var fest_tk := FestivalData.new(
		"fest_tokyo",
		"Tokyo Neo Sound Festival",
		Enums.CityId.TOKYO,
		"Yoyogi Park Dome Open Air",
		164, # Mese 6 (Agosto)
		6,
		65000,
		[Enums.MusicalGenre.ELECTRONIC, Enums.MusicalGenre.ROCK, Enums.MusicalGenre.POP],
		"Neo Tokyo Cyber Syndicate",
		84.0
	)
	festivals["fest_tokyo"] = fest_tk

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

## Verifica se la band può partecipare al contest primaverile Battle of the Bands
func can_enter_battle_of_bands() -> Dictionary:
	var cur_month: int = 3
	var cur_day: int = 60
	if calendar_data:
		cur_month = calendar_data.season_month if "season_month" in calendar_data else int((calendar_data.day_number - 1) / 28) + 1
		cur_day = calendar_data.day_number
	
	# Stagione primaverile: Mese 3 / Giorni 57-84
	var is_spring: bool = (cur_month == 3) or (cur_day >= 57 and cur_day <= 84)
	if not is_spring:
		return { "allowed": false, "reason": "not_spring_season" }
		
	if player_data and player_data.battle_of_bands_pass:
		return { "allowed": false, "reason": "already_won" }
		
	if player_data and player_data.songs.size() == 0:
		return { "allowed": false, "reason": "no_songs_available" }
		
	return {
		"allowed": true,
		"reason": "ok",
		"rival_band_name": "The Young Challengers",
		"rival_band_score": 65.0,
		"entry_fee": 0.0,
		"reward_money": 300.0,
		"reward_reputation": 8.0
	}

## Esegue la sfida al contest primaverile Battle of the Bands
func compete_in_battle_of_bands(songs: Array = [], mock_score: float = -1.0) -> Dictionary:
	var check := can_enter_battle_of_bands()
	if not check.allowed and mock_score < 0.0:
		if check.reason == "already_won":
			return { "success": false, "reason": check.reason }
		elif check.reason == "not_spring_season" and not (player_data and player_data.battle_of_bands_pass):
			pass
		else:
			return { "success": false, "reason": check.reason }
			
	var concert_score: float = 68.0
	if mock_score >= 0.0:
		concert_score = mock_score
	elif songs.size() > 0:
		var sum_q: float = 0.0
		for s in songs:
			sum_q += s.quality_score if "quality_score" in s else 60.0
		concert_score = sum_q / float(songs.size())
	elif player_data:
		concert_score = clamp(50.0 + float(player_data.instrument_level) * 3.0, 50.0, 95.0)
		
	var rival_score: float = 65.0
	var won: bool = concert_score >= rival_score
	
	if won:
		if player_data:
			player_data.battle_of_bands_pass = true
			player_data.money += 300.0
			player_data.reputation += 8.0
			player_data.morale = min(100.0, player_data.morale + 20.0)
			player_data.festival_trophies.append("Trofeo Battle of the Bands (Primavera)")
			if travel_system and travel_system.has_method("add_fans_in_city"):
				travel_system.add_fans_in_city(player_data.current_city_id, 45)
			else:
				player_data.fans += 45
		_apply_band_dynamics(15.0, 15.0, -20.0)
	else:
		if player_data:
			player_data.reputation += 2.0
			player_data.morale = max(0.0, player_data.morale - 5.0)
		_apply_band_dynamics(0.0, 0.0, 8.0)
		
	var res := {
		"success": true,
		"won": won,
		"concert_score": concert_score,
		"rival_score": rival_score,
		"reward_money": 300.0 if won else 0.0,
		"reputation_gain": 8.0 if won else 2.0,
		"pass_awarded": won
	}
	
	if EventBus and EventBus.has_signal("battle_of_bands_completed"):
		EventBus.emit_signal("battle_of_bands_completed", res)
		
	return res

## Configura la tipologia di palco per un festival (Main Stage vs Underground Tent)
func set_festival_stage_type(fest_id: String, stage_type: int) -> bool:
	var fest: FestivalData = get_festival(fest_id)
	if not fest:
		return false
	fest.stage_type = stage_type
	return true

## Configura la condizione meteo per un festival
func set_festival_weather(fest_id: String, weather: int) -> bool:
	var fest: FestivalData = get_festival(fest_id)
	if not fest:
		return false
	fest.weather = weather
	return true

## Attiva o disattiva il conflitto di orario per un festival
func set_festival_time_clash(fest_id: String, active: bool) -> bool:
	var fest: FestivalData = get_festival(fest_id)
	if not fest:
		return false
	fest.time_clash_active = active
	return true

## Restituisce le opzioni di sponsorizzazione disponibili per il festival
func get_available_sponsors(fest_id: String) -> Array[Dictionary]:
	var fest: FestivalData = get_festival(fest_id)
	var cap_factor: float = (float(fest.capacity) / 35000.0) if fest else 1.0
	
	return [
		{
			"type": Enums.FestivalSponsorType.NONE,
			"name": "Nessuno Sponsor (Pura Integrità)",
			"description": "Zero compromessi commerciali, massima integrità per i fan puristi.",
			"cash_advance": 0.0,
			"energy_bonus": 0,
			"morale_bonus": 0.0,
			"tension_reduction": 0.0,
			"score_bonus": 0.0
		},
		{
			"type": Enums.FestivalSponsorType.ENERGY_DRINK,
			"name": "Energy Drink Extreme",
			"description": "Lattine sul palco e sui monitor. +15 Energia, compenso immediato garantito.",
			"cash_advance": round(1000.0 * cap_factor),
			"energy_bonus": 15,
			"morale_bonus": 0.0,
			"tension_reduction": 0.0,
			"score_bonus": 2.0
		},
		{
			"type": Enums.FestivalSponsorType.CRAFT_BEER,
			"name": "Birrificio Artigianale Indipendente",
			"description": "Fornitura cassa birre artigianali per il backstage. +20 Morale, -15 Tensione band.",
			"cash_advance": round(750.0 * cap_factor),
			"energy_bonus": 0,
			"morale_bonus": 20.0,
			"tension_reduction": 15.0,
			"score_bonus": 0.0
		},
		{
			"type": Enums.FestivalSponsorType.STREETWEAR_GEAR,
			"name": "Marchio Streetwear & Rock Gear",
			"description": "Abiti di scena esclusivi e giacche per tutta la band. +5 Carisma scenico.",
			"cash_advance": round(1500.0 * cap_factor),
			"energy_bonus": 0,
			"morale_bonus": 10.0,
			"tension_reduction": 0.0,
			"score_bonus": 5.0
		}
	]

## Firma un accordo di sponsorizzazione per il festival
func sign_festival_sponsor(fest_id: String, sponsor_type: int) -> Dictionary:
	var fest: FestivalData = get_festival(fest_id)
	if not fest:
		return { "success": false, "reason": "festival_not_found" }
		
	var sponsors := get_available_sponsors(fest_id)
	var chosen_sponsor: Dictionary = {}
	for sp in sponsors:
		if sp.type == sponsor_type:
			chosen_sponsor = sp
			break
			
	if chosen_sponsor.is_empty():
		return { "success": false, "reason": "invalid_sponsor" }
		
	fest.active_sponsor = sponsor_type
	var cash: float = chosen_sponsor.cash_advance
	if player_data and cash > 0.0:
		player_data.money += cash
	if player_data and chosen_sponsor.energy_bonus > 0:
		player_data.recover_energy(chosen_sponsor.energy_bonus)
	if player_data and chosen_sponsor.morale_bonus > 0:
		player_data.morale = min(100.0, player_data.morale + chosen_sponsor.morale_bonus)
	if chosen_sponsor.tension_reduction > 0:
		_apply_band_dynamics(5.0, 5.0, -chosen_sponsor.tension_reduction)
		
	if EventBus and EventBus.has_signal("festival_sponsor_signed"):
		EventBus.emit_signal("festival_sponsor_signed", fest_id, sponsor_type)
		
	return {
		"success": true,
		"festival_id": fest_id,
		"sponsor_type": sponsor_type,
		"sponsor_name": chosen_sponsor.name,
		"cash_advance": cash
	}

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
				
	# Influenza del Pass Speciale Battle of the Bands (Sezione 7)
	if player_data and player_data.battle_of_bands_pass:
		if slot == Enums.FestivalSlot.OPENING_AFTERNOON:
			req_rep = 0.0 # Requisito azzerato per l'Opening Slot
		elif slot == Enums.FestivalSlot.SUNSET_SLOT:
			req_rep = max(0.0, req_rep * 0.50) # Requisito dimezzato per il Sunset Slot
				
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

## Risoluzione del concerto al festival (live, cachet, merch massivo, Steal the Show, mosse estreme, meteo, palchi)
func perform_festival_concert(
	fest_id: String,
	songs: Array = [],
	mock_concert_score: float = -1.0,
	extreme_move: int = Enums.FestivalExtremeMove.NONE,
	storm_choice: int = 0,
	time_clash_choice: int = -1,
	mock_move_success: Variant = null
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
	var energy_cost: int = specs.energy_cost
	var stress_gain: float = specs.stress_gain
	
	# Calcolo Concert Score
	var concert_score: float = 70.0
	var genre_match_count: int = 0
	if mock_concert_score >= 0.0:
		concert_score = mock_concert_score
	elif songs.size() > 0:
		var sum_q: float = 0.0
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
		
	# Bonus Sponsor su concert_score
	if fest.active_sponsor == Enums.FestivalSponsorType.STREETWEAR_GEAR:
		concert_score = min(100.0, concert_score + 5.0)
	elif fest.active_sponsor == Enums.FestivalSponsorType.ENERGY_DRINK:
		concert_score = min(100.0, concert_score + 2.0)
		
	# Calcolo Affluenza
	var base_aud: int = specs.estimated_audience
	var pop_factor: float = 1.0
	if player_data:
		pop_factor = clamp(0.60 + (player_data.popularity / 100.0) * 0.50, 0.60, 1.20)
	var actual_audience: int = int(base_aud * pop_factor)
	
	# Modificatore Tipologia Palco (Main Stage vs Underground Tent - Sezione 7)
	var underground_fan_bonus: float = 1.0
	var underground_merch_bonus: float = 1.0
	if fest.stage_type == Enums.FestivalStageType.UNDERGROUND_TENT:
		actual_audience = int(actual_audience * 0.50) # 50% capienza tenda
		underground_fan_bonus = 1.50 # +50% conversione fan
		underground_merch_bonus = 1.30 # +30% vendite merch
		_apply_band_dynamics(0.0, 0.0, -10.0) # ambiente intimo rilassa la band
		
	# Risoluzione Conflitto di Orario (Time Clash - Sezione 7)
	if fest.time_clash_active or time_clash_choice >= 0:
		match time_clash_choice:
			0: # Attacco aggressivo: ruba pubblico al palco rivale
				actual_audience = int(actual_audience * 1.20)
				energy_cost += 10
			1: # Show intimo per i fan fedeli
				underground_fan_bonus *= 1.30
			2: # Momento virale a sorpresa
				if player_data:
					player_data.reputation += 3.0
					
	# Risoluzione Mosse Sceniche Estreme (Extreme Stage Moves - Sezione 7)
	var move_success: bool = false
	if extreme_move != Enums.FestivalExtremeMove.NONE:
		fest.extreme_move_attempted = extreme_move
		if mock_move_success != null:
			move_success = bool(mock_move_success)
		else:
			match extreme_move:
				Enums.FestivalExtremeMove.STAGE_DIVING:
					move_success = (player_data != null and player_data.energy >= 30)
				Enums.FestivalExtremeMove.RIGGING_CLIMB:
					move_success = (player_data != null and player_data.instrument_level >= 10)
				Enums.FestivalExtremeMove.CROWD_SOLO:
					move_success = (player_data != null and player_data.instrument_level >= 12)
					
		if extreme_move == Enums.FestivalExtremeMove.STAGE_DIVING:
			if move_success:
				concert_score = min(100.0, concert_score + 15.0)
				underground_fan_bonus *= 1.25
			else:
				if player_data:
					player_data.morale = max(0.0, player_data.morale - 10.0)
					player_data.add_stress(10.0)
		elif extreme_move == Enums.FestivalExtremeMove.RIGGING_CLIMB:
			if move_success:
				concert_score = min(100.0, concert_score + 20.0)
				if player_data:
					player_data.reputation += 4.0
			else:
				if player_data:
					player_data.money = max(0.0, player_data.money - 150.0)
				concert_score = max(35.0, concert_score - 10.0)
		elif extreme_move == Enums.FestivalExtremeMove.CROWD_SOLO:
			if move_success:
				concert_score = min(100.0, concert_score + 15.0)
			else:
				concert_score = max(35.0, concert_score - 5.0)
				
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
	var merch_revenue: float = actual_audience * merch_per_head * specs.merch_multiplier * (concert_score / 100.0) * underground_merch_bonus
	
	# Condizioni Meteo Estive all'Aperto (Sezione 7)
	if fest.weather == Enums.FestivalWeather.SUNNY_HEATWAVE:
		energy_cost += 15 # Disidratazione/fatica
		merch_revenue *= 1.20 # Spesa bevande/gadget estivi
	elif fest.weather == Enums.FestivalWeather.SUMMER_STORM:
		if storm_choice == 0:
			# Suona sotto il diluvio: momento eroico
			concert_score = min(100.0, concert_score + 5.0)
			underground_fan_bonus *= 1.25
		else:
			# Pausa tecnica: esecuzione sicura
			pass
			
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
	var new_fans: int = int(actual_audience * base_fan_rate * (concert_score / 100.0) * underground_fan_bonus)
	var rep_gain: float = 2.0
	var backstage_msg: String = ""
	
	if stole_the_show:
		# Vittoria epica sul cartellone
		new_fans = int(new_fans * 1.30) # +30% fan
		rep_gain = 6.0
		if player_data:
			player_data.reputation += rep_gain
			player_data.morale = min(100.0, player_data.morale + 10.0)
			player_data.festival_trophies.append("Steal the Show a %s" % fest.name)
		_apply_band_dynamics(10.0, 10.0, -15.0)
		backstage_msg = "La band rivale %s ammette la tua superiorità con rispetto nel backstage!" % fest.rival_band_name
	else:
		if score_margin < -10.0:
			# Battuti nettamente dalla rivale
			rep_gain = 1.0
			if player_data:
				player_data.reputation += rep_gain
				player_data.morale = max(0.0, player_data.morale - 5.0)
			_apply_band_dynamics(0.0, 0.0, 12.0)
			backstage_msg = "La band rivale %s festeggia il trionfo nel backstage prendendoti in giro." % fest.rival_band_name
		else:
			# Prestazione comunque solida
			rep_gain = 3.0
			if player_data:
				player_data.reputation += rep_gain
			backstage_msg = "Scambio di complimenti nel backstage con la band rivale %s." % fest.rival_band_name
				
	# Accredito Fan con Territorialità (85% città, 15% riverbero nazionale)
	if travel_system and travel_system.has_method("add_fans_in_city"):
		travel_system.add_fans_in_city(fest.city_id, new_fans)
	elif player_data:
		player_data.fans += new_fans
		
	# Consumo Energia & Stress
	if player_data:
		player_data.consume_energy(energy_cost)
		player_data.add_stress(stress_gain)
		
	# Chiusura e salvataggio esito
	fest.is_completed = true
	var result_data := {
		"success": true,
		"festival_id": fest.id,
		"festival_name": fest.name,
		"city_id": fest.city_id,
		"slot": fest.booked_slot,
		"slot_name": Enums.get_festival_slot_name(fest.booked_slot),
		"stage_type": fest.stage_type,
		"stage_type_name": Enums.get_festival_stage_type_name(fest.stage_type),
		"weather": fest.weather,
		"weather_name": Enums.get_festival_weather_name(fest.weather),
		"active_sponsor": fest.active_sponsor,
		"sponsor_name": Enums.get_festival_sponsor_type_name(fest.active_sponsor),
		"extreme_move": extreme_move,
		"extreme_move_name": Enums.get_festival_extreme_move_name(extreme_move),
		"move_success": move_success,
		"backstage_reaction": backstage_msg,
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
		"energy_spent": energy_cost,
		"stress_gained": stress_gain
	}
	fest.performance_result = result_data
	
	if EventBus and EventBus.has_signal("festival_performed"):
		EventBus.emit_signal("festival_performed", fest.id, result_data)
		
	return result_data

## Resa vocale lineare per NVDA dell'elenco festival
func get_festival_list_speech() -> String:
	var speech := "Grandi Festival Estivi Disponibili. "
	if player_data and player_data.battle_of_bands_pass:
		speech += "Pass Speciale Battle of the Bands Attivo! "
	var count := 1
	for fest: FestivalData in get_all_festivals():
		var status_str := "Non prenotato"
		if fest.is_completed:
			status_str = "Concluso"
		elif fest.is_slot_booked():
			status_str = "Prenotato: " + Enums.get_festival_slot_name(fest.booked_slot)
			
		speech += "%d: %s a %s. Giorno %d (Mese %d). Capienza: %d. Rivale: %s. Stato: %s. Palco: %s. " % [
			count,
			fest.name,
			Enums.get_city_name(fest.city_id),
			fest.day_number,
			fest.season_month,
			fest.capacity,
			fest.rival_band_name,
			status_str,
			Enums.get_festival_stage_type_name(fest.stage_type)
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
	
	speech += "Palco: %s. Meteo: %s. Sponsor: %s. " % [
		Enums.get_festival_stage_type_name(fest.stage_type),
		Enums.get_festival_weather_name(fest.weather),
		Enums.get_festival_sponsor_type_name(fest.active_sponsor)
	]
	
	if player_data and player_data.battle_of_bands_pass:
		speech += "Pass Battle of the Bands attivo: requisiti ridotti. "
		
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

