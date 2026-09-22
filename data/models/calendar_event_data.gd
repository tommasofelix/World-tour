# res://data/models/calendar_event_data.gd
class_name CalendarEventData
extends RefCounted

## Modello Dati per gli Impegni e gli Eventi a Calendario in World-tour (SP-09)
## Rappresenta concerti, prove, sessioni di studio, scadenze contrattuali,
## affitto, tappe di tour e festival futuri nell'Agenda della Band.

var id: String = ""
var title: String = ""
var description: String = ""
var event_type: int = Enums.CalendarEventType.CONCERT
var day_number: int = 1
var period: int = Enums.TimePeriod.EVENING
var location_id: String = ""
var location_name: String = ""
var city_id: int = Enums.CityId.MILANO
var details: Dictionary = {}
var is_completed: bool = false
var is_critical: bool = false

func _init(
	p_id: String = "",
	p_title: String = "",
	p_type: int = Enums.CalendarEventType.CONCERT,
	p_day: int = 1,
	p_period: int = Enums.TimePeriod.EVENING,
	p_loc_id: String = "",
	p_loc_name: String = "",
	p_critical: bool = false
) -> void:
	id = p_id if not p_id.is_empty() else ("event_%d_%d" % [Time.get_ticks_msec(), randi() % 10000])
	title = p_title
	event_type = p_type
	day_number = p_day
	period = p_period
	location_id = p_loc_id
	location_name = p_loc_name
	is_critical = p_critical

func get_event_type_name() -> String:
	match event_type:
		Enums.CalendarEventType.CONCERT:
			return "Concerto Live"
		Enums.CalendarEventType.REHEARSAL:
			return "Prove della Band"
		Enums.CalendarEventType.STUDIO_BOOKING:
			return "Sessione di Registrazione"
		Enums.CalendarEventType.CONTRACT_DEADLINE:
			return "Scadenza Discografica"
		Enums.CalendarEventType.RENT_DUE:
			return "Pagamento Alloggio"
		Enums.CalendarEventType.FESTIVAL:
			return "Festival Estivo"
		Enums.CalendarEventType.TOUR_STOP:
			return "Tappa di Tour"
		_:
			return "Impegno Generico"

func get_period_name() -> String:
	match period:
		Enums.TimePeriod.MORNING:
			return "Mattina"
		Enums.TimePeriod.AFTERNOON:
			return "Pomeriggio"
		Enums.TimePeriod.EVENING:
			return "Sera"
		Enums.TimePeriod.NIGHT:
			return "Notte"
		_:
			return "Tutto il giorno"

func get_summary_string() -> String:
	var loc_info: String = (" presso %s" % location_name) if not location_name.is_empty() else ""
	var crit_info: String = " [Critico]" if is_critical else ""
	var status_info: String = " (Completato)" if is_completed else ""
	return "%s: %s%s - Fascia %s%s%s" % [
		get_event_type_name(),
		title,
		loc_info,
		get_period_name(),
		crit_info,
		status_info
	]

func to_dict() -> Dictionary:
	return {
		"id": id,
		"title": title,
		"description": description,
		"event_type": event_type,
		"day_number": day_number,
		"period": period,
		"location_id": location_id,
		"location_name": location_name,
		"city_id": city_id,
		"details": details.duplicate(true),
		"is_completed": is_completed,
		"is_critical": is_critical
	}

func from_dict(dict: Dictionary) -> void:
	id = str(dict.get("id", id))
	title = str(dict.get("title", title))
	description = str(dict.get("description", description))
	event_type = int(dict.get("event_type", event_type))
	day_number = int(dict.get("day_number", day_number))
	period = int(dict.get("period", period))
	location_id = str(dict.get("location_id", location_id))
	location_name = str(dict.get("location_name", location_name))
	city_id = int(dict.get("city_id", city_id))
	if dict.has("details") and dict["details"] is Dictionary:
		details = dict["details"].duplicate(true)
	is_completed = bool(dict.get("is_completed", is_completed))
	is_critical = bool(dict.get("is_critical", is_critical))
