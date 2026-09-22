# res://data/models/calendar_data.gd
class_name CalendarData
extends RefCounted

## Modello Dati Runtime del Calendario e Tempo Quotidiano per World-tour

var day_number: int = 1
var day_duration: float = Constants.DEFAULT_DAY_DURATION_SECONDS
var remaining_seconds: float = Constants.DEFAULT_DAY_DURATION_SECONDS
var current_period: int = Enums.TimePeriod.MORNING
var action_counts_today: Dictionary = {}

func _init(p_duration: float = Constants.DEFAULT_DAY_DURATION_SECONDS) -> void:
	day_duration = p_duration
	remaining_seconds = day_duration

func get_period_name() -> String:
	match current_period:
		Enums.TimePeriod.MORNING:
			return "Mattina"
		Enums.TimePeriod.AFTERNOON:
			return "Pomeriggio"
		Enums.TimePeriod.EVENING:
			return "Sera"
		Enums.TimePeriod.NIGHT:
			return "Notte"
		_:
			return "Mattina"

func get_formatted_time_string() -> String:
	# La durata del giorno corrisponde a 18 ore attive (dalle 06:00 alle 24:00)
	var elapsed_ratio: float = 1.0 - clampf(remaining_seconds / day_duration, 0.0, 1.0)
	var total_virtual_minutes: float = elapsed_ratio * (18.0 * 60.0)
	var virtual_hour: int = 6 + int(floor(total_virtual_minutes / 60.0))
	var virtual_minute: int = int(floor(fmod(total_virtual_minutes, 60.0)))
	
	if virtual_hour >= 24:
		virtual_hour = 0
		
	return "%02d:%02d" % [virtual_hour, virtual_minute]

func update_period() -> int:
	# Fasce proporzionali alla durata della giornata:
	# Mattina: > 75% del tempo rimanente (06:00 - 10:30)
	# Pomeriggio: > 41.6% del tempo rimanente (10:30 - 16:30)
	# Sera: > 8.3% del tempo rimanente (16:30 - 22:30)
	# Notte: <= 8.3% del tempo rimanente (22:30 - 24:00)
	if remaining_seconds > day_duration * 0.75:
		current_period = Enums.TimePeriod.MORNING
	elif remaining_seconds > day_duration * 0.416:
		current_period = Enums.TimePeriod.AFTERNOON
	elif remaining_seconds > day_duration * 0.083:
		current_period = Enums.TimePeriod.EVENING
	else:
		current_period = Enums.TimePeriod.NIGHT
		
	return current_period

func increment_action_count(action_id: String) -> void:
	if action_counts_today.has(action_id):
		action_counts_today[action_id] += 1
	else:
		action_counts_today[action_id] = 1

func get_action_count(action_id: String) -> int:
	return action_counts_today.get(action_id, 0)

func reset_daily_saturation() -> void:
	action_counts_today.clear()
	remaining_seconds = day_duration
	update_period()

func to_dict() -> Dictionary:
	return {
		"day_number": day_number,
		"day_duration": day_duration,
		"remaining_seconds": remaining_seconds,
		"current_period": current_period,
		"action_counts_today": action_counts_today.duplicate(true)
	}

func from_dict(dict: Dictionary) -> void:
	day_number = int(dict.get("day_number", day_number))
	day_duration = float(dict.get("day_duration", day_duration))
	remaining_seconds = float(dict.get("remaining_seconds", remaining_seconds))
	current_period = int(dict.get("current_period", current_period))
	if dict.has("action_counts_today") and dict["action_counts_today"] is Dictionary:
		action_counts_today = dict["action_counts_today"].duplicate(true)
	update_period()
