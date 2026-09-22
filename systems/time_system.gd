# res://systems/time_system.gd
class_name TimeSystem
extends RefCounted

## Motore di Simulazione Temporale Quotidiano per World-tour

var calendar_data: CalendarData
var is_paused: bool = false
var time_scale: float = Constants.SPEED_NORMAL

func _init(p_calendar: CalendarData = null) -> void:
	if p_calendar:
		calendar_data = p_calendar
	else:
		calendar_data = CalendarData.new()

func set_paused(paused: bool) -> void:
	if is_paused != paused:
		is_paused = paused
		EventBus.pause_toggled.emit(is_paused)

func toggle_pause() -> bool:
	set_paused(not is_paused)
	return is_paused

func set_time_scale(new_scale: float) -> void:
	var clamped_scale: float = clampf(new_scale, Constants.SPEED_NORMAL, Constants.SPEED_ULTRA)
	if time_scale != clamped_scale:
		time_scale = clamped_scale
		EventBus.speed_changed.emit(time_scale)

func advance_time(delta_seconds: float) -> void:
	if is_paused or calendar_data.remaining_seconds <= 0.0:
		return
		
	var effective_delta: float = delta_seconds * time_scale
	calendar_data.remaining_seconds = maxf(0.0, calendar_data.remaining_seconds - effective_delta)
	calendar_data.update_period()
	
	EventBus.time_ticked.emit(
		calendar_data.remaining_seconds,
		calendar_data.get_formatted_time_string(),
		calendar_data.current_period
	)
	
	if calendar_data.remaining_seconds <= 0.0:
		EventBus.day_ended.emit(calendar_data.day_number)
