# res://systems/tour_system.gd
class_name TourSystem
extends RefCounted

## Motore di Pianificazione, Logistica e Gestione dei Tour Musicali (Fase 8.2 / SP-10)
## Governa l'organizzazione delle tournée multi-tappa (3-8 date), la scelta dei veicoli
## di trasporto (Rusty Van, Pro Van, Luxury Bus), i guasti stradali, l'accumulo di Hype progressivo,
## il bilancio economico finale e l'impatto psicologico sulla band.

const TourDataScript = preload("res://data/models/tour_data.gd")
const CityDataScript = preload("res://data/models/city_data.gd")
const VenueDataScript = preload("res://data/models/venue_data.gd")
const CalendarEventDataScript = preload("res://data/models/calendar_event_data.gd")

var player_data: PlayerData
var calendar_data: CalendarData
var travel_system: TravelSystem
var schedule_system: ScheduleSystem
var band_system: BandSystem

var active_tour: TourData = null
var tour_history: Array[TourData] = []
var pending_road_dilemma: Dictionary = {}
var forced_road_dilemma: int = -1

func _init(
	p_player: PlayerData = null,
	p_calendar: CalendarData = null,
	p_travel: TravelSystem = null,
	p_schedule: ScheduleSystem = null,
	p_band: BandSystem = null
) -> void:
	player_data = p_player
	calendar_data = p_calendar
	travel_system = p_travel
	schedule_system = p_schedule
	band_system = p_band

# ==============================================================================
# PARAMETRI & SPECIFICHE DEI MEZZI DI TRASPORTO (VEHICLES)
# ==============================================================================

## Restituisce le specifiche e l'impatto logistico di un veicolo
static func get_vehicle_specs(vehicle_type: int) -> Dictionary:
	match vehicle_type:
		Enums.TourVehicleType.RUSTY_VAN:
			return {
				"name": "Furgone Scassato",
				"cost_per_stop": 40.0,
				"stress_per_stop": 15,
				"energy_per_stop": -20,
				"breakdown_chance": 0.15,
				"breakdown_cost": 60.0,
				"min_reputation": 0.0,
				"hype_bonus": 0.0,
				"band_tension_mod": 0,
				"description": "Economico ma estenuante. 15% rischio guasto meccanico."
			}
		Enums.TourVehicleType.PRO_VAN:
			return {
				"name": "Van Professionale",
				"cost_per_stop": 150.0,
				"stress_per_stop": 5,
				"energy_per_stop": -10,
				"breakdown_chance": 0.0,
				"breakdown_cost": 0.0,
				"min_reputation": 15.0,
				"hype_bonus": 0.0,
				"band_tension_mod": 0,
				"description": "Spazioso, affidabile e bilanciato. Zero rischi di guasto."
			}
		Enums.TourVehicleType.LUXURY_BUS:
			return {
				"name": "Tour Bus di Lusso",
				"cost_per_stop": 450.0,
				"stress_per_stop": 0,
				"energy_per_stop": 15, # Recupero a bordo con le cuccette!
				"breakdown_chance": 0.0,
				"breakdown_cost": 0.0,
				"min_reputation": 40.0,
				"hype_bonus": 0.15,
				"band_tension_mod": -10,
				"description": "Massimo comfort con cuccette lounge. +15% hype iniziale e riposo a bordo."
			}
		_:
			return {
				"name": "Veicolo Standard",
				"cost_per_stop": 100.0,
				"stress_per_stop": 10,
				"energy_per_stop": -15,
				"breakdown_chance": 0.0,
				"breakdown_cost": 0.0,
				"min_reputation": 0.0,
				"hype_bonus": 0.0,
				"band_tension_mod": 0,
				"description": "Veicolo generico."
			}

# ==============================================================================
# PIANIFICAZIONE DEL TOUR (PLANNING)
# ==============================================================================

## Verifica se è possibile pianificare un tour con i parametri forniti
func can_plan_tour(vehicle_type: int, stops_config: Array, p_player: PlayerData = null) -> Dictionary:
	var pl: PlayerData = p_player if p_player else player_data
	if not pl:
		return {"allowed": false, "reason": "no_player_data", "message": "Dati giocatore assenti."}

	if active_tour != null and active_tour.status == TourData.TourStatus.IN_PROGRESS:
		return {"allowed": false, "reason": "tour_already_active", "message": "Hai già un tour in corso (%s)." % active_tour.title}

	if stops_config.size() < 2:
		return {"allowed": false, "reason": "too_few_stops", "message": "Un tour deve contenere almeno 2 tappe."}

	if stops_config.size() > 8:
		return {"allowed": false, "reason": "too_many_stops", "message": "Un tour può contenere al massimo 8 tappe."}

	var specs := get_vehicle_specs(vehicle_type)
	if pl.reputation < float(specs.min_reputation):
		return {
			"allowed": false,
			"reason": "reputation_insufficient_for_vehicle",
			"message": "Reputazione insufficiente per il %s (%.1f richiesta, attuale: %.1f)." % [
				specs.name, float(specs.min_reputation), pl.reputation
			]
		}

	# Calcolo costo totale noleggio veicolo
	var total_rental: float = float(specs.cost_per_stop) * float(stops_config.size())
	if pl.money < total_rental:
		return {
			"allowed": false,
			"reason": "funds_insufficient_for_vehicle",
			"message": "Fondi insufficienti per noleggiare il %s per %d tappe (%.2f € richiesti, saldo: %.2f €)." % [
				specs.name, stops_config.size(), total_rental, pl.money
			]
		}

	# Verifica coerenza temporale delle date a calendario
	var last_day: int = calendar_data.day_number if calendar_data else 1
	for i in range(stops_config.size()):
		var st = stops_config[i]
		var day: int = int(st.get("day_number", 0))
		if day <= last_day:
			return {
				"allowed": false,
				"reason": "invalid_dates",
				"message": "La tappa %d (Giorno %d) deve essere programmata nel futuro (dopo il giorno %d)." % [i + 1, day, last_day]
			}
		last_day = day

	return {
		"allowed": true,
		"reason": "ok",
		"message": "Tutti i requisiti per la tournée sono soddisfatti.",
		"rental_cost": total_rental
	}

## Pianifica e avvia ufficialmente una nuova tournée
func plan_tour(title: String, vehicle_type: int, stops_config: Array) -> Dictionary:
	var check := can_plan_tour(vehicle_type, stops_config)
	if not check.allowed:
		return {"success": false, "reason": check.reason, "message": check.message}

	var specs := get_vehicle_specs(vehicle_type)
	var rental_cost: float = float(check.rental_cost)
	var cur_day: int = calendar_data.day_number if calendar_data else 1

	# Deduzione spesa anticipata noleggio
	player_data.modify_money(-rental_cost)
	EventBus.money_changed.emit(player_data.money, -rental_cost, "Noleggio Veicolo Tour: %s" % specs.name)

	# Creazione modello TourData
	var tour := TourDataScript.new("", title, vehicle_type, cur_day)
	tour.total_expenses += rental_cost

	# Aggiunta tappe e calendarizzazione eventi
	for st in stops_config:
		var cid: int = int(st.get("city_id", Enums.CityId.MILANO))
		var c_data: CityData = CityDataScript.get_city(cid)
		var c_name: String = c_data.name if c_data else Enums.get_city_name(cid)
		var vid: String = str(st.get("venue_id", ""))
		var v_name: String = str(st.get("venue_name", "Locale Tour"))
		var day_num: int = int(st.get("day_number", cur_day + 1))
		var is_day_off: bool = bool(st.get("is_day_off", false))

		if is_day_off:
			tour.add_day_off(cid, c_name, day_num)
			if schedule_system:
				var ev := CalendarEventDataScript.new(
					"",
					"Day Off Tour: Riposo a %s" % c_name,
					Enums.CalendarEventType.TOUR_STOP,
					day_num,
					Enums.TimePeriod.AFTERNOON,
					"",
					"Giorno Libero",
					false
				)
				ev.city_id = cid
				schedule_system.add_event(ev)
		else:
			tour.add_stop(cid, c_name, vid, v_name, day_num)
			if schedule_system:
				var ev := CalendarEventDataScript.new(
					"",
					"Tappa Tour: %s a %s" % [title, c_name],
					Enums.CalendarEventType.TOUR_STOP,
					day_num,
					Enums.TimePeriod.EVENING,
					vid,
					v_name,
					true
				)
				ev.city_id = cid
				schedule_system.add_event(ev)

	# Bonus morale/tensione per Luxury Bus
	if vehicle_type == Enums.TourVehicleType.LUXURY_BUS:
		_apply_band_dynamics(0.0, 0.0, float(specs.band_tension_mod))

	active_tour = tour
	active_tour.status = TourData.TourStatus.IN_PROGRESS

	EventBus.tour_planned.emit(active_tour)

	var speech := "Tour '%s' pianificato con successo! Veicolo: %s. %d tappe programmate. Spesa noleggio: %.2f euro." % [
		title, specs.name, stops_config.size(), rental_cost
	]
	AccessibilityManager.announce(speech, true)

	return {
		"success": true,
		"tour_id": tour.id,
		"title": tour.title,
		"stops_count": tour.stops.size(),
		"rental_cost": rental_cost,
		"message": speech
	}

# ==============================================================================
# LOGISTICA DI VIAGGIO & AVANZAMENTO TAPPE
# ==============================================================================

## Esegue lo spostamento logistico verso la città della prossima tappa del tour
func advance_to_next_stop() -> Dictionary:
	if active_tour == null or active_tour.status != TourData.TourStatus.IN_PROGRESS:
		return {"success": false, "reason": "no_active_tour", "message": "Nessun tour attivo in corso."}

	var cur_stop: Dictionary = active_tour.get_current_stop()
	if cur_stop.is_empty():
		return {"success": false, "reason": "no_more_stops", "message": "Nessuna tappa rimanente."}

	var target_city_id: int = int(cur_stop.get("city_id", Enums.CityId.MILANO))
	var target_city_name: String = str(cur_stop.get("city_name", "Milano"))
	var specs := get_vehicle_specs(active_tour.vehicle_type)

	# Gestione Giorno di Riposo (Day Off): riposo della band senza logistica estenuante
	if cur_stop.get("is_day_off", false):
		if travel_system:
			travel_system.current_city_id = target_city_id
		player_data.current_city_id = target_city_id
		award_city_sticker(target_city_id)

		player_data.energy = mini(100, player_data.energy + 25)
		player_data.reduce_stress(20.0)
		_apply_band_dynamics(5.0, 5.0, -15.0)
		cur_stop["completed"] = true
		var stop_idx: int = int(cur_stop.get("stop_index", 0))
		active_tour.current_stop_index += 1

		var is_finished: bool = active_tour.is_tour_finished()
		if is_finished:
			finish_tour()

		var speech := "Giorno di riposo (Day Off) a %s per la Tappa %d! La band recupera le forze: +25 energia, -20 stress, tensione ridotta." % [
			target_city_name,
			stop_idx + 1
		]
		AccessibilityManager.announce(speech, true)
		return {
			"success": true,
			"is_day_off": true,
			"city_id": target_city_id,
			"city_name": target_city_name,
			"stop_index": stop_idx,
			"is_tour_finished": is_finished,
			"message": speech
		}

	var breakdown_occurred: bool = false
	var breakdown_cost: float = 0.0

	# Verifica guasto meccanico (per Rusty Van)
	if float(specs.breakdown_chance) > 0.0 and randf() <= float(specs.breakdown_chance):
		breakdown_occurred = true
		breakdown_cost = float(specs.breakdown_cost)
		player_data.modify_money(-breakdown_cost)
		player_data.add_stress(10.0)
		EventBus.money_changed.emit(player_data.money, -breakdown_cost, "Riparazione Guasto Furgone")
		_apply_band_dynamics(0.0, 0.0, 10.0)

	# Applicazione fatica/stress specifici del mezzo di trasporto
	var stress_gain: float = float(specs.stress_per_stop)
	var energy_delta: int = int(specs.energy_per_stop)

	if stress_gain > 0:
		player_data.add_stress(stress_gain)
	if energy_delta < 0:
		player_data.consume_energy(absi(energy_delta))
	elif energy_delta > 0:
		player_data.energy = mini(100, player_data.energy + energy_delta)

	# Sincronizzazione posizione geografica
	if travel_system:
		travel_system.current_city_id = target_city_id
	player_data.current_city_id = target_city_id
	award_city_sticker(target_city_id)

	var speech := "Arrivo a %s per la Tappa %d! Veicolo: %s." % [
		target_city_name,
		int(cur_stop.get("stop_index", 0)) + 1,
		specs.name
	]
	if breakdown_occurred:
		speech += " ATTENZIONE: Guasto meccanico durante il viaggio! Spesi %.2f euro per la riparazione." % breakdown_cost
	if energy_delta > 0:
		speech += " Il riposo sulle cuccette ha rigenerato %d energia!" % energy_delta

	# Verifica dilemma stradale procedurale
	var dilemma_res := check_and_trigger_road_dilemma()
	if dilemma_res.get("triggered", false):
		speech += " " + dilemma_res.get("message", "")
	else:
		AccessibilityManager.announce(speech, true)

	return {
		"success": true,
		"is_day_off": false,
		"city_id": target_city_id,
		"city_name": target_city_name,
		"stop_index": cur_stop.get("stop_index", 0),
		"breakdown": breakdown_occurred,
		"breakdown_cost": breakdown_cost,
		"dilemma": dilemma_res,
		"message": speech
	}

# ==============================================================================
# RISOLUZIONE CONCERTI & HYPE CUMULATIVO
# ==============================================================================

## Registra l'esito del concerto per la tappa attiva del tour
func record_stop_result(concert_result: Dictionary) -> Dictionary:
	if active_tour == null or active_tour.status != TourData.TourStatus.IN_PROGRESS:
		return {"success": false, "reason": "no_active_tour"}

	var cur_stop := active_tour.get_current_stop()
	if cur_stop.is_empty():
		return {"success": false, "reason": "no_current_stop"}

	cur_stop["completed"] = true
	cur_stop["concert_result"] = concert_result.duplicate(true)

	# Aggiornamento contabilità cumulativa del tour
	var gross: float = float(concert_result.get("gross_revenue", 0.0))
	var player_cut: float = float(concert_result.get("player_share", 0.0))
	var rent: float = float(concert_result.get("rent_cost", 0.0))
	var fans_new: int = int(concert_result.get("new_fans", 0))
	var score: float = float(concert_result.get("concert_score", 0.0))

	active_tour.total_gross_revenue += gross
	active_tour.total_expenses += rent
	active_tour.total_net_profit += player_cut
	active_tour.total_fans_gained += fans_new

	# Meccanica dell'Hype Progressivo a Catena (+5% per concerti ben riusciti)
	var hype_gained: float = 0.0
	if score >= 70.0:
		hype_gained = 0.05
		active_tour.accumulated_hype += hype_gained

	var stop_idx: int = int(cur_stop.get("stop_index", 0))
	active_tour.current_stop_index += 1

	EventBus.tour_stop_completed.emit(stop_idx, concert_result)

	var is_finished: bool = active_tour.is_tour_finished()
	if is_finished:
		finish_tour()

	return {
		"success": true,
		"stop_index": stop_idx,
		"hype_gained": hype_gained,
		"current_hype": active_tour.accumulated_hype,
		"is_tour_finished": is_finished
	}

## Restituisce il moltiplicatore corrente di hype del tour per i concerti
func get_tour_hype_multiplier() -> float:
	if active_tour != null and active_tour.status == TourData.TourStatus.IN_PROGRESS:
		return active_tour.accumulated_hype
	return 1.0

# ==============================================================================
# CONCLUSIONE DEL TOUR & BILANCIO BAND
# ==============================================================================

## Conclude la tournée, elabora il rendiconto e aggiorna i legami della band
func finish_tour() -> Dictionary:
	if active_tour == null:
		return {"success": false, "reason": "no_active_tour"}

	active_tour.status = TourData.TourStatus.COMPLETED

	var net_profit: float = active_tour.total_net_profit
	var is_triumphant: bool = net_profit > 0 and active_tour.total_fans_gained > 50

	# Impatto sulle dinamiche umane della band
	if is_triumphant:
		_apply_band_dynamics(15.0, 15.0, -20.0)
	else:
		_apply_band_dynamics(0.0, 0.0, 15.0)

	# Bonus Reputazione complessiva
	var rep_bonus: float = 5.0 if is_triumphant else 2.0
	player_data.reputation += rep_bonus

	var summary := {
		"tour_id": active_tour.id,
		"title": active_tour.title,
		"is_triumphant": is_triumphant,
		"total_gross": active_tour.total_gross_revenue,
		"total_expenses": active_tour.total_expenses,
		"total_net": net_profit,
		"total_fans": active_tour.total_fans_gained,
		"final_hype": active_tour.accumulated_hype,
		"reputation_awarded": rep_bonus
	}

	tour_history.append(active_tour)
	EventBus.tour_finished.emit(summary)

	var speech := "Tour '%s' CONCENTRATO E CONCLUSO! Esito: %s. Incasso netto totale: %.2f euro. Nuovi fan: %d. Reputazione guadagnata: +%.1f." % [
		active_tour.title,
		"Trionfale" if is_triumphant else "Faticoso",
		net_profit,
		active_tour.total_fans_gained,
		rep_bonus
	]
	AccessibilityManager.announce(speech, true)

	return summary

# ==============================================================================
# SCREEN READER (NVDA / ZERO MOUSE) & PRESENTAZIONE
# ==============================================================================

## Restituisce il resoconto vocale lineare del tour
func get_tour_summary_speech() -> String:
	if active_tour == null:
		return "Nessun tour attualmente programmato o in corso. Premi O per pianificare una nuova tournée."
	return active_tour.get_summary_speech()

# ==============================================================================
# PROMOZIONI RADIO, ADESIVI & DILEMMI STRADALI (SEZIONE 6)
# ==============================================================================

## Verifica se è possibile svolgere una promozione radiofonica mattutina per la tappa corrente
func can_do_radio_interview() -> Dictionary:
	if active_tour == null or active_tour.status != TourData.TourStatus.IN_PROGRESS:
		return {"allowed": false, "reason": "no_active_tour", "message": "Nessun tour attivo in corso."}
	var cur_stop := active_tour.get_current_stop()
	if cur_stop.is_empty():
		return {"allowed": false, "reason": "no_stop", "message": "Nessuna tappa attiva per l'intervista."}
	if cur_stop.get("is_day_off", false):
		return {"allowed": false, "reason": "day_off", "message": "Oggi è un giorno di riposo (Day Off): niente promozioni radio."}
	if cur_stop.get("radio_interview_done", false):
		return {"allowed": false, "reason": "already_done", "message": "Intervista radiofonica già effettuata per questa tappa."}
	if not player_data or player_data.energy < 15:
		return {"allowed": false, "reason": "insufficient_energy", "message": "Energia insufficiente per l'intervista radio (richiesti 15 energia)."}
	return {"allowed": true, "reason": "ok", "message": "Pronto per l'intervista radio promozionale mattutina."}

## Esegue l'intervista radiofonica promozionale
func do_radio_interview() -> Dictionary:
	var check := can_do_radio_interview()
	if not check.allowed:
		return {"success": false, "reason": check.reason, "message": check.message}

	var cur_stop := active_tour.get_current_stop()
	player_data.consume_energy(15)
	active_tour.accumulated_hype += 0.10
	active_tour.radio_interviews_count += 1
	cur_stop["radio_interview_done"] = true

	var city_id: int = int(cur_stop.get("city_id", player_data.current_city_id))
	var cur_fans: int = player_data.get_city_fans(city_id)
	var cur_pop: float = player_data.get_city_popularity(city_id)

	player_data.city_fans[city_id] = cur_fans + 25
	player_data.city_popularity[city_id] = minf(100.0, cur_pop + 10.0)

	var c_name := str(cur_stop.get("city_name", Enums.get_city_name(city_id)))
	var speech := "Intervista radiofonica mattutina a %s completata con successo! Hype del tour aumentato del 10%% (attuale: %.2fx), +25 nuovi fan locali e popolarità cittadina salita a %.1f." % [
		c_name, active_tour.accumulated_hype, player_data.city_popularity[city_id]
	]
	AccessibilityManager.announce(speech, true)

	var res := {
		"success": true,
		"city_id": city_id,
		"city_name": c_name,
		"hype_bonus": 0.10,
		"total_hype": active_tour.accumulated_hype,
		"new_fans": 25,
		"new_popularity": player_data.city_popularity[city_id],
		"message": speech
	}
	if EventBus.has_signal("tour_radio_interview_completed"):
		EventBus.tour_radio_interview_completed.emit(res)
	return res

## Assegna l'adesivo della città visitata al diario di bordo del veicolo
func award_city_sticker(city_id: int) -> bool:
	if not player_data:
		return false
	if not player_data.visited_city_stickers.has(city_id):
		player_data.visited_city_stickers.append(city_id)
		if EventBus.has_signal("city_sticker_collected"):
			EventBus.city_sticker_collected.emit(city_id)
		return true
	return false

## Restituisce il resoconto vocale lineare del diario di bordo e adesivi del veicolo
func get_vehicle_stickers_speech() -> String:
	if not player_data:
		return "Nessun dato veicolo disponibile."
	var stickers: Array[int] = player_data.visited_city_stickers
	var v_name: String = player_data.vehicle_custom_name
	if stickers.is_empty():
		return "Diario di Bordo del Veicolo '%s': nessun adesivo delle città collezionato finora." % v_name
	var names: Array[String] = []
	for cid in stickers:
		names.append(Enums.get_city_name(cid))
	return "Diario di Bordo del Veicolo '%s': %d adesivi collezionati: %s." % [
		v_name,
		stickers.size(),
		", ".join(names)
	]

## Forza il prossimo dilemma stradale (usato per testing deterministico)
func force_next_road_dilemma(dilemma_type: int) -> void:
	forced_road_dilemma = dilemma_type

## Verifica la comparsa di un dilemma stradale durante il tragitto
func check_and_trigger_road_dilemma() -> Dictionary:
	if forced_road_dilemma == -1 and randf() > 0.35:
		return {"triggered": false}

	var dtype: int = forced_road_dilemma
	if dtype == -1:
		var dilemmas := [
			Enums.RoadDilemmaType.FLAT_TIRE_RAIN,
			Enums.RoadDilemmaType.REST_STOP_NIGHT,
			Enums.RoadDilemmaType.BUDGET_MOTEL,
			Enums.RoadDilemmaType.LOST_ROUTE
		]
		dtype = dilemmas[randi() % dilemmas.size()]
	forced_road_dilemma = -1

	var d_def := _get_road_dilemma_definition(dtype)
	pending_road_dilemma = d_def.duplicate(true)

	var speech := "DILEMMA STRADALE: %s! %s. Opzione 1: %s. Opzione 2: %s. Opzione 3: %s." % [
		d_def.title,
		d_def.description,
		d_def.options[1].label,
		d_def.options[2].label,
		d_def.options[3].label
	]
	AccessibilityManager.announce(speech, true)

	if EventBus.has_signal("road_dilemma_triggered"):
		EventBus.road_dilemma_triggered.emit(pending_road_dilemma)

	return {
		"triggered": true,
		"dilemma": pending_road_dilemma,
		"message": speech
	}

## Risolve la scelta compiuta per il dilemma stradale pendente (1, 2 o 3)
func resolve_road_dilemma_choice(choice_index: int) -> Dictionary:
	if pending_road_dilemma.is_empty():
		return {"success": false, "reason": "no_pending_dilemma", "message": "Nessun dilemma stradale in attesa."}
	if choice_index < 1 or choice_index > 3:
		return {"success": false, "reason": "invalid_choice", "message": "Opzione dilemma non valida (scegliere 1, 2 o 3)."}

	var opts: Dictionary = pending_road_dilemma.get("options", {})
	var opt: Dictionary = opts.get(choice_index, {})
	if opt.is_empty():
		return {"success": false, "reason": "option_not_found", "message": "Dati opzione non trovati."}

	var money_cost: float = float(opt.get("money_cost", 0.0))
	var energy_cost: int = int(opt.get("energy_cost", 0))
	var energy_gain: int = int(opt.get("energy_gain", 0))
	var stress_delta: float = float(opt.get("stress_delta", 0.0))
	var tension_delta: float = float(opt.get("tension_delta", 0.0))
	var affinity_delta: float = float(opt.get("affinity_delta", 0.0))
	var hype_delta: float = float(opt.get("hype_delta", 0.0))

	if player_data:
		if money_cost > 0.0:
			player_data.modify_money(-money_cost)
			EventBus.money_changed.emit(player_data.money, -money_cost, "Dilemma Stradale: %s" % opt.label)
		if energy_cost > 0:
			player_data.consume_energy(energy_cost)
		elif energy_gain > 0:
			player_data.energy = mini(100, player_data.energy + energy_gain)
		if stress_delta > 0.0:
			player_data.add_stress(stress_delta)
		elif stress_delta < 0.0:
			player_data.reduce_stress(absf(stress_delta))
		if tension_delta != 0.0 or affinity_delta != 0.0:
			_apply_band_dynamics(affinity_delta, 0.0, tension_delta)

	if active_tour and hype_delta != 0.0:
		active_tour.accumulated_hype = maxf(0.5, active_tour.accumulated_hype + hype_delta)

	var speech := "Dilemma risolto: '%s'. Esito: %s." % [opt.label, opt.outcome_text]
	AccessibilityManager.announce(speech, true)

	var outcome := {
		"success": true,
		"choice": choice_index,
		"dilemma_type": pending_road_dilemma.get("type", -1),
		"dilemma_title": pending_road_dilemma.get("title", ""),
		"option_label": opt.label,
		"outcome_text": opt.outcome_text,
		"money_cost": money_cost,
		"energy_delta": energy_gain - energy_cost,
		"stress_delta": stress_delta,
		"tension_delta": tension_delta,
		"hype_delta": hype_delta,
		"message": speech
	}

	if EventBus.has_signal("road_dilemma_resolved"):
		EventBus.road_dilemma_resolved.emit(choice_index, outcome)

	pending_road_dilemma = {}
	return outcome

func _get_road_dilemma_definition(dilemma_type: int) -> Dictionary:
	match dilemma_type:
		Enums.RoadDilemmaType.FLAT_TIRE_RAIN:
			return {
				"type": dilemma_type,
				"title": "Gomma a terra sotto la pioggia",
				"description": "Una foratura improvvisa lungo la statale mentre piove a dirotto.",
				"options": {
					1: {
						"label": "Chiama soccorso stradale rapido (-120 euro)",
						"outcome_text": "Soccorso intervenuto rapidamente. Tempo e serenità preservati.",
						"money_cost": 120.0, "energy_cost": 0, "energy_gain": 0,
						"stress_delta": 0.0, "tension_delta": 0.0, "affinity_delta": 0.0, "hype_delta": 0.0
					},
					2: {
						"label": "Cambiala da solo con la band (0 euro, -25 energia, +15 tensione)",
						"outcome_text": "Lavoro faticoso nel fango. La band si stanca e litiga sui dadi della ruota.",
						"money_cost": 0.0, "energy_cost": 25, "energy_gain": 0,
						"stress_delta": 15.0, "tension_delta": 15.0, "affinity_delta": 0.0, "hype_delta": 0.0
					},
					3: {
						"label": "Aspetta l'alba al coperto (-10 energia, +10 stress)",
						"outcome_text": "Notte fredda e scomoda passata ad attendere il mattino.",
						"money_cost": 0.0, "energy_cost": 10, "energy_gain": 0,
						"stress_delta": 10.0, "tension_delta": 5.0, "affinity_delta": 0.0, "hype_delta": 0.0
					}
				}
			}
		Enums.RoadDilemmaType.REST_STOP_NIGHT:
			return {
				"type": dilemma_type,
				"title": "Autogrill deserto alle 03:00",
				"description": "Una sosta notturna in un'area di servizio illuminata dai neon.",
				"options": {
					1: {
						"label": "Caffè bollente e snack per tutta la band (-25 euro, +10 energia)",
						"outcome_text": "Caffeina e cibo ridanno la carica per guidare fino all'alba.",
						"money_cost": 25.0, "energy_cost": 0, "energy_gain": 10,
						"stress_delta": 0.0, "tension_delta": 0.0, "affinity_delta": 5.0, "hype_delta": 0.0
					},
					2: {
						"label": "Fai un'ora di sonno sui sedili (+15 energia, -5 stress)",
						"outcome_text": "Un breve pisolino rigenerante placa i nervi.",
						"money_cost": 0.0, "energy_cost": 0, "energy_gain": 15,
						"stress_delta": -5.0, "tension_delta": -5.0, "affinity_delta": 0.0, "hype_delta": 0.0
					},
					3: {
						"label": "Improvvisa una jam session acustica nel piazzale (+5% hype tour, -15 energia)",
						"outcome_text": "I camionisti e i viaggiatori applaudono e filmano: il video finisce sui social!",
						"money_cost": 0.0, "energy_cost": 15, "energy_gain": 0,
						"stress_delta": 0.0, "tension_delta": 0.0, "affinity_delta": 10.0, "hype_delta": 0.05
					}
				}
			}
		Enums.RoadDilemmaType.BUDGET_MOTEL:
			return {
				"type": dilemma_type,
				"title": "Motel economico lungo la statale",
				"description": "Un'insegna lampeggiante offre camere a basso prezzo per la notte.",
				"options": {
					1: {
						"label": "Camere singole per tutti (-180 euro, +30 energia, -20 stress, -10 tensione)",
						"outcome_text": "Privacy e sonno indisturbato: tutti si risvegliano freschi e distesi.",
						"money_cost": 180.0, "energy_cost": 0, "energy_gain": 30,
						"stress_delta": -20.0, "tension_delta": -10.0, "affinity_delta": 5.0, "hype_delta": 0.0
					},
					2: {
						"label": "Stanza comune condivisa con sacchi a pelo (-50 euro, +15 energia, +5 tensione)",
						"outcome_text": "Si risparmia, ma il russare e gli spazi stretti creano qualche battibecco.",
						"money_cost": 50.0, "energy_cost": 0, "energy_gain": 15,
						"stress_delta": -5.0, "tension_delta": 5.0, "affinity_delta": 0.0, "hype_delta": 0.0
					},
					3: {
						"label": "Dormite nel veicolo (0 euro, -15 energia, +15 stress, +15 tensione)",
						"outcome_text": "Notte tremenda tra freddo e colli doloranti. La band è furiosa.",
						"money_cost": 0.0, "energy_cost": 15, "energy_gain": 0,
						"stress_delta": 15.0, "tension_delta": 15.0, "affinity_delta": -5.0, "hype_delta": 0.0
					}
				}
			}
		Enums.RoadDilemmaType.LOST_ROUTE:
			return {
				"type": dilemma_type,
				"title": "Navigatore in tilt e deviazione panoramica",
				"description": "Il GPS perde il segnale e vi ritrovate a un bivio sconosciuto tra le colline.",
				"options": {
					1: {
						"label": "Prendi la tangenziale rapida a pedaggio (-40 euro)",
						"outcome_text": "Percorso veloce e sicuro, arrivo puntuale a destinazione.",
						"money_cost": 40.0, "energy_cost": 0, "energy_gain": 0,
						"stress_delta": 0.0, "tension_delta": 0.0, "affinity_delta": 0.0, "hype_delta": 0.0
					},
					2: {
						"label": "Segui le strade statali secondarie (+15 stress, -10 energia, 0 euro)",
						"outcome_text": "Curve e tornanti infiniti fanno perdere tempo ed energie.",
						"money_cost": 0.0, "energy_cost": 10, "energy_gain": 0,
						"stress_delta": 15.0, "tension_delta": 5.0, "affinity_delta": 0.0, "hype_delta": 0.0
					},
					3: {
						"label": "Sosta in una trattoria tipica di paese (-60 euro, +15 energia, -10 stress, +10 affinità)",
						"outcome_text": "Pranzo memorabile e atmosfera festosa che unisce la band.",
						"money_cost": 60.0, "energy_cost": 0, "energy_gain": 15,
						"stress_delta": -10.0, "tension_delta": -10.0, "affinity_delta": 10.0, "hype_delta": 0.0
					}
				}
			}
		_:
			return {
				"type": dilemma_type,
				"title": "Imprevisto Stradale",
				"description": "Un contrattempo durante il tragitto.",
				"options": {
					1: {"label": "Risolvi rapidamente (-50 euro)", "outcome_text": "Spesa effettuata.", "money_cost": 50.0, "energy_cost": 0, "energy_gain": 0, "stress_delta": 0.0, "tension_delta": 0.0, "affinity_delta": 0.0, "hype_delta": 0.0},
					2: {"label": "Gestisci sul posto (-10 energia)", "outcome_text": "Risolto sul posto.", "money_cost": 0.0, "energy_cost": 10, "energy_gain": 0, "stress_delta": 5.0, "tension_delta": 0.0, "affinity_delta": 0.0, "hype_delta": 0.0},
					3: {"label": "Ignora e prosegui (+10 stress)", "outcome_text": "Tirato dritto.", "money_cost": 0.0, "energy_cost": 0, "energy_gain": 0, "stress_delta": 10.0, "tension_delta": 5.0, "affinity_delta": 0.0, "hype_delta": 0.0}
				}
			}

# ==============================================================================
# SERIALIZZAZIONE & SALVATAGGIO
# ==============================================================================

func to_dict() -> Dictionary:
	var hist_copy: Array = []
	for t in tour_history:
		hist_copy.append(t.to_dict())

	return {
		"active_tour": active_tour.to_dict() if active_tour else null,
		"tour_history": hist_copy,
		"pending_road_dilemma": pending_road_dilemma.duplicate(true)
	}

func from_dict(dict: Dictionary) -> void:
	if dict.has("active_tour") and dict["active_tour"] is Dictionary:
		active_tour = TourDataScript.new()
		active_tour.from_dict(dict["active_tour"])
	else:
		active_tour = null

	tour_history.clear()
	if dict.has("tour_history") and dict["tour_history"] is Array:
		for t_dict in dict["tour_history"]:
			if t_dict is Dictionary:
				var t = TourDataScript.new()
				t.from_dict(t_dict)
				tour_history.append(t)

	if dict.has("pending_road_dilemma") and dict["pending_road_dilemma"] is Dictionary:
		pending_road_dilemma = dict["pending_road_dilemma"].duplicate(true)
	else:
		pending_road_dilemma = {}

func _apply_band_dynamics(affinity_delta: float, respect_delta: float, tension_delta: float) -> void:
	if not player_data:
		return
	for m in player_data.get_active_band_members():
		m.modify_affinity(affinity_delta)
		m.modify_respect(respect_delta)
		m.modify_tension(tension_delta)
	if band_system:
		band_system._emit_chemistry_changed()

