# res://data/models/tour_data.gd
class_name TourData
extends RefCounted

## Modello Dati del Tour Musicale per World-tour (Fase 8.2 / SP-10)
## Rappresenta una tournée organizzata a tappe consecutive (3-8 date),
## il veicolo di trasporto scelto, le date a calendario, l'hype cumulativo,
## l'economia complessiva e il bilancio di fine tour.

enum TourStatus {
	PLANNED = 0,
	IN_PROGRESS = 1,
	COMPLETED = 2,
	CANCELLED = 3
}

var id: String = ""
var title: String = "Tour Nazionale"
var vehicle_type: int = Enums.TourVehicleType.RUSTY_VAN
var status: int = TourStatus.PLANNED

# Array di tappe: ogni elemento è un Dictionary con la configurazione della data
# {
#   "stop_index": int,
#   "city_id": int,
#   "city_name": String,
#   "venue_id": String,
#   "venue_name": String,
#   "day_number": int,
#   "completed": bool,
#   "concert_result": Dictionary
# }
var stops: Array[Dictionary] = []
var current_stop_index: int = 0

# Dinamiche di hype ed economia cumulativa
var accumulated_hype: float = 1.0
var total_gross_revenue: float = 0.0
var total_expenses: float = 0.0
var total_net_profit: float = 0.0
var total_fans_gained: int = 0
var created_day: int = 1
var radio_interviews_count: int = 0

func _init(
	p_id: String = "",
	p_title: String = "Tour Nazionale",
	p_vehicle: int = Enums.TourVehicleType.RUSTY_VAN,
	p_day: int = 1
) -> void:
	id = p_id if not p_id.is_empty() else ("tour_%d_%d" % [p_day, randi() % 10000])
	title = p_title
	vehicle_type = p_vehicle
	created_day = p_day
	status = TourStatus.PLANNED
	current_stop_index = 0
	radio_interviews_count = 0
	
	# Il Luxury Bus conferisce un bonus hype di partenza (+15%)
	if vehicle_type == Enums.TourVehicleType.LUXURY_BUS:
		accumulated_hype = 1.15
	else:
		accumulated_hype = 1.0

## Aggiunge una tappa all'itinerario del tour
func add_stop(city_id: int, city_name: String, venue_id: String, venue_name: String, day_number: int, is_day_off: bool = false) -> void:
	var stop_dict := {
		"stop_index": stops.size(),
		"city_id": city_id,
		"city_name": city_name,
		"venue_id": venue_id,
		"venue_name": venue_name,
		"day_number": day_number,
		"is_day_off": is_day_off,
		"radio_interview_done": false,
		"completed": false,
		"concert_result": {}
	}
	stops.append(stop_dict)

## Aggiunge una giornata di riposo (Day Off) tra due date della tournée
func add_day_off(city_id: int, city_name: String, day_number: int) -> void:
	add_stop(city_id, city_name, "day_off", "Giorno di Riposo (Day Off)", day_number, true)

## Restituisce la tappa attualmente attiva
func get_current_stop() -> Dictionary:
	if current_stop_index >= 0 and current_stop_index < stops.size():
		return stops[current_stop_index]
	return {}

## Restituisce la prossima tappa se presente
func get_next_stop() -> Dictionary:
	var next_idx: int = current_stop_index + 1
	if next_idx < stops.size():
		return stops[next_idx]
	return {}

## Verifica se tutte le tappe sono state completate
func is_tour_finished() -> bool:
	if stops.is_empty():
		return false
	for s in stops:
		if not s.get("completed", false):
			return false
	return true

## Restituisce il nome descrittivo del veicolo di trasporto
func get_vehicle_name() -> String:
	match vehicle_type:
		Enums.TourVehicleType.RUSTY_VAN:
			return "Furgone Scassato"
		Enums.TourVehicleType.PRO_VAN:
			return "Van Professionale"
		Enums.TourVehicleType.LUXURY_BUS:
			return "Tour Bus di Lusso"
		_:
			return "Veicolo Sconosciuto"

## Restituisce una descrizione lineare per lo screen reader NVDA
func get_summary_speech() -> String:
	var status_text: String = "Pianificato"
	match status:
		TourStatus.PLANNED: status_text = "Pianificato"
		TourStatus.IN_PROGRESS: status_text = "In Corso"
		TourStatus.COMPLETED: status_text = "Completato"
		TourStatus.CANCELLED: status_text = "Annullato"
		
	var completed_count: int = 0
	for s in stops:
		if s.get("completed", false):
			completed_count += 1
			
	var speech := "Tour: %s. Stato: %s. Veicolo: %s. Tappe completate: %d su %d. Hype attuale: +%d%%. Incasso netto finora: %.2f euro. Fan conquistati: %d." % [
		title,
		status_text,
		get_vehicle_name(),
		completed_count,
		stops.size(),
		int(round((accumulated_hype - 1.0) * 100.0)),
		total_net_profit,
		total_fans_gained
	]
	
	var cur_stop := get_current_stop()
	if not cur_stop.is_empty() and status == TourStatus.IN_PROGRESS:
		var is_do: bool = bool(cur_stop.get("is_day_off", false))
		if is_do:
			speech += " Prossimo impegno: Tappa %d a %s — Giorno di Riposo (Day Off per la Band, Giorno %d)." % [
				int(cur_stop.get("stop_index", 0)) + 1,
				cur_stop.get("city_name", ""),
				int(cur_stop.get("day_number", 0))
			]
		else:
			speech += " Prossima esibizione: Tappa %d a %s presso %s (Giorno %d)." % [
				int(cur_stop.get("stop_index", 0)) + 1,
				cur_stop.get("city_name", ""),
				cur_stop.get("venue_name", ""),
				int(cur_stop.get("day_number", 0))
			]
		
	return speech

func to_dict() -> Dictionary:
	var stops_copy: Array = []
	for s in stops:
		stops_copy.append(s.duplicate(true))
		
	return {
		"id": id,
		"title": title,
		"vehicle_type": vehicle_type,
		"status": status,
		"stops": stops_copy,
		"current_stop_index": current_stop_index,
		"accumulated_hype": accumulated_hype,
		"total_gross_revenue": total_gross_revenue,
		"total_expenses": total_expenses,
		"total_net_profit": total_net_profit,
		"total_fans_gained": total_fans_gained,
		"created_day": created_day,
		"radio_interviews_count": radio_interviews_count
	}

func from_dict(dict: Dictionary) -> void:
	id = str(dict.get("id", id))
	title = str(dict.get("title", title))
	vehicle_type = int(dict.get("vehicle_type", vehicle_type))
	status = int(dict.get("status", status))
	current_stop_index = int(dict.get("current_stop_index", current_stop_index))
	accumulated_hype = float(dict.get("accumulated_hype", accumulated_hype))
	total_gross_revenue = float(dict.get("total_gross_revenue", total_gross_revenue))
	total_expenses = float(dict.get("total_expenses", total_expenses))
	total_net_profit = float(dict.get("total_net_profit", total_net_profit))
	total_fans_gained = int(dict.get("total_fans_gained", total_fans_gained))
	created_day = int(dict.get("created_day", created_day))
	radio_interviews_count = int(dict.get("radio_interviews_count", radio_interviews_count))
	
	stops.clear()
	if dict.has("stops") and dict["stops"] is Array:
		for s_data in dict["stops"]:
			if s_data is Dictionary:
				stops.append(s_data.duplicate(true))
