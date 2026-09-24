# res://systems/time_system.gd
class_name TimeSystem
extends RefCounted

## Motore di Simulazione Temporale Quotidiano per World-tour (Sezione 1.2)
## Gestisce orologio continuo a 22 ore virtuali (06:00 - 04:00), overtime notturno progressivo,
## avvisi discreti alle 02:00 e 03:00 (zero pop-up a mezzanotte), riposo anticipato e skip time.

var calendar_data: CalendarData
var player_data: PlayerData
var is_paused: bool = false
var time_scale: float = Constants.SPEED_NORMAL

# Tracciamento Overtime Notturno Progressivo (00:00 - 04:00)
var warned_hour_2: bool = false
var warned_hour_3: bool = false
var overtime_hour_1_applied: bool = false
var overtime_hour_2_applied: bool = false
var overtime_hour_3_applied: bool = false
var overtime_hour_4_applied: bool = false

# Tracciamento Riposo Anticipato
var early_sleep_taken: bool = false
var sleep_period: int = Enums.TimePeriod.MORNING
var sleep_hour_offset: int = 0

func _init(p_calendar: CalendarData = null, p_player: PlayerData = null) -> void:
	if p_calendar:
		calendar_data = p_calendar
	else:
		calendar_data = CalendarData.new()
	player_data = p_player

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

func cycle_speed() -> float:
	var current_idx: int = Constants.SUPPORTED_SPEEDS.find(time_scale)
	var next_idx: int = 0
	if current_idx != -1 and current_idx < Constants.SUPPORTED_SPEEDS.size() - 1:
		next_idx = current_idx + 1
	var new_speed: float = Constants.SUPPORTED_SPEEDS[next_idx]
	set_time_scale(new_speed)
	return time_scale

func advance_time(delta_seconds: float) -> void:
	if is_paused or calendar_data.remaining_seconds <= 0.0:
		return
		
	var effective_delta: float = delta_seconds * time_scale
	calendar_data.remaining_seconds = maxf(0.0, calendar_data.remaining_seconds - effective_delta)
	calendar_data.update_period()
	
	_check_overtime_and_notifications()
	
	EventBus.time_ticked.emit(
		calendar_data.remaining_seconds,
		calendar_data.get_formatted_time_string(),
		calendar_data.current_period
	)
	
	if calendar_data.remaining_seconds <= 0.0:
		EventBus.day_ended.emit(calendar_data.day_number)

func _check_overtime_and_notifications() -> void:
	if calendar_data.current_period != Enums.TimePeriod.NIGHT:
		return
		
	var h_offset: int = calendar_data.get_hour_offset()
	
	# Ore 00:00 (offset 18) -> Penalità minima +2 stress progressivo (nessun pop-up)
	if h_offset >= 18 and not overtime_hour_1_applied:
		overtime_hour_1_applied = true
		_apply_stress(Constants.OVERTIME_STRESS_HOUR_1)
		
	# Ore 01:00 (offset 19) -> +3 stress progressivo
	if h_offset >= 19 and not overtime_hour_2_applied:
		overtime_hour_2_applied = true
		_apply_stress(Constants.OVERTIME_STRESS_HOUR_2)
		
	# Ore 02:00 (offset 20) -> Avviso discreto per NVDA e +5 stress
	if h_offset >= 20:
		if not warned_hour_2:
			warned_hour_2 = true
			AccessibilityManager.announce("Ore 02:00 di notte. Puoi andare a dormire (tasto Z) o proseguire le tue attività.", false)
		if not overtime_hour_3_applied:
			overtime_hour_3_applied = true
			_apply_stress(Constants.OVERTIME_STRESS_HOUR_3)
			
	# Ore 03:00 (offset 21) -> Avviso discreto finale e +10 stress
	if h_offset >= 21:
		if not warned_hour_3:
			warned_hour_3 = true
			AccessibilityManager.announce("Attenzione: sono le 03:00. La giornata terminerà alle 04:00.", false)
		if not overtime_hour_4_applied:
			overtime_hour_4_applied = true
			_apply_stress(Constants.OVERTIME_STRESS_HOUR_4)

func _apply_stress(amount: int) -> void:
	var p: PlayerData = player_data
	if p == null and GameManager:
		p = GameManager.player_data
	if p:
		p.add_stress(amount)

## Riposo Anticipato: permette di andare a dormire prima delle 04:00
func sleep_early() -> void:
	if calendar_data.remaining_seconds <= 0.0:
		return
		
	early_sleep_taken = true
	sleep_period = calendar_data.current_period
	sleep_hour_offset = calendar_data.get_hour_offset()
	
	calendar_data.remaining_seconds = 0.0
	calendar_data.update_period()
	
	AccessibilityManager.announce("Hai deciso di andare a dormire. Buonanotte!", true)
	EventBus.time_ticked.emit(0.0, calendar_data.get_formatted_time_string(), calendar_data.current_period)
	EventBus.day_ended.emit(calendar_data.day_number)

## Skip Time: avanza il tempo virtuale fino all'inizio della fascia successiva.
## Restituisce true se ha avanzato il tempo, false se la giornata è al termine o se siamo in Notte.
func skip_to_next_period() -> bool:
	if calendar_data.remaining_seconds <= 0.0:
		return false
		
	var cur_period: int = calendar_data.current_period
	var target_seconds: float = 0.0
	
	match cur_period:
		Enums.TimePeriod.MORNING:
			# Passaggio al Pomeriggio (ore 12:00)
			target_seconds = calendar_data.day_duration * (16.0 / Constants.VIRTUAL_HOURS_PER_DAY) - 0.1
		Enums.TimePeriod.AFTERNOON:
			# Passaggio alla Sera (ore 18:00)
			target_seconds = calendar_data.day_duration * (10.0 / Constants.VIRTUAL_HOURS_PER_DAY) - 0.1
		Enums.TimePeriod.EVENING:
			# Passaggio alla Notte (ore 00:00)
			target_seconds = calendar_data.day_duration * (4.0 / Constants.VIRTUAL_HOURS_PER_DAY) - 0.1
		Enums.TimePeriod.NIGHT:
			# Nella fascia Notte, non si salta oltre: l'utente deve scegliere se dormire con Dormi (Z)
			return false
			
	calendar_data.remaining_seconds = maxf(0.0, target_seconds)
	calendar_data.update_period()
	
	_check_overtime_and_notifications()
	
	EventBus.time_ticked.emit(
		calendar_data.remaining_seconds,
		calendar_data.get_formatted_time_string(),
		calendar_data.current_period
	)
	
	AccessibilityManager.announce("Tempo trascorso fino a %s: ore %s." % [
		calendar_data.get_period_name(),
		calendar_data.get_formatted_time_string()
	], true)
	
	return true

## Wrapper ufficiale per compatibilità HUD/Input: avanza alla fascia successiva
func advance_to_next_period() -> bool:
	return skip_to_next_period()

## Wrapper ufficiale per compatibilità HUD/Input: conclude la giornata e va a dormire
func trigger_sleep_now() -> void:
	sleep_early()

func reset_daily_overtime() -> void:
	warned_hour_2 = false
	warned_hour_3 = false
	overtime_hour_1_applied = false
	overtime_hour_2_applied = false
	overtime_hour_3_applied = false
	overtime_hour_4_applied = false
	early_sleep_taken = false
	sleep_period = Enums.TimePeriod.MORNING
	sleep_hour_offset = 0
