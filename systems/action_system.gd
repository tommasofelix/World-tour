# res://systems/action_system.gd
class_name ActionSystem
extends RefCounted

## Motore di Convalida ed Esecuzione delle Azioni Quotidiane per World-tour

var player_data: PlayerData
var calendar_data: CalendarData

var current_action: ActionData = null
var action_elapsed: float = 0.0
var is_running: bool = false

func _init(p_player: PlayerData = null, p_calendar: CalendarData = null) -> void:
	player_data = p_player
	calendar_data = p_calendar

func can_start_action(action: ActionData) -> Dictionary:
	if not action:
		return {"can_start": false, "reason": "Azione non valida."}
	if is_running:
		return {"can_start": false, "reason": "Un'altra azione è attualmente in corso."}
	if player_data and player_data.energy < action.energy_cost:
		return {"can_start": false, "reason": "Energia insufficiente per avviare questa azione."}
	if calendar_data and calendar_data.remaining_seconds < action.duration_seconds:
		return {"can_start": false, "reason": "Il tempo residuo nella giornata non è sufficiente."}
		
	return {"can_start": true, "reason": ""}

func start_action(action: ActionData) -> bool:
	var check: Dictionary = can_start_action(action)
	if not check["can_start"]:
		AccessibilityManager.announce(check["reason"], true)
		return false
		
	current_action = action
	action_elapsed = 0.0
	is_running = true
	
	GameManager.change_state(Enums.GameState.GAMEPLAY_BUSY)
	EventBus.action_started.emit(action.action_id, action.duration_seconds)
	AccessibilityManager.announce("Avviata azione: %s" % action.action_name, true)
	return true

func update_action(delta_seconds: float) -> void:
	if not is_running or not current_action:
		return
		
	action_elapsed += delta_seconds
	EventBus.action_progress.emit(current_action.action_id, action_elapsed, current_action.duration_seconds)
	
	if action_elapsed >= current_action.duration_seconds:
		_complete_action()

func _complete_action() -> void:
	var completed_id: String = current_action.action_id
	var action_name_ref: String = current_action.action_name
	is_running = false
	
	# Applicazione consumi fisiologici
	if player_data:
		player_data.consume_energy(current_action.energy_cost)
		player_data.add_stress(current_action.stress_gain)
		
	# Aggiornamento contatore saturazione
	if calendar_data:
		calendar_data.increment_action_count(completed_id)
		
	# Calcolo matematico XP
	var day_reps: int = 1
	if calendar_data:
		day_reps = calendar_data.get_action_count(completed_id)
		
	var stress_val: float = float(player_data.stress) if player_data else 0.0
	var morale_val: float = float(player_data.morale) if player_data else 100.0
	
	var gained_xp: float = Formulas.calculate_training_xp(
		current_action.base_xp,
		current_action.duration_seconds,
		day_reps,
		stress_val,
		morale_val
	)
	
	var leveled_up: bool = false
	var new_lvl: int = 10
	if player_data:
		leveled_up = player_data.add_xp_to_skill(current_action.target_skill, gained_xp)
		new_lvl = player_data.get_skill_level(current_action.target_skill)
		
	var rewards: Dictionary = {
		"xp_gained": gained_xp,
		"leveled_up": leveled_up,
		"target_skill": current_action.target_skill,
		"new_level": new_lvl
	}
	
	EventBus.action_completed.emit(completed_id, rewards)
	
	var announcement_text: String = "Completato: %s. Guadagnati %.1f XP." % [action_name_ref, gained_xp]
	if leveled_up:
		announcement_text += " Nuova abilità sbloccata: livello %d!" % new_lvl
	AccessibilityManager.announce(announcement_text, true)
	
	current_action = null
	GameManager.change_state(Enums.GameState.GAMEPLAY_IDLE)

func cancel_action() -> void:
	if not is_running:
		return
	var canceled_id: String = current_action.action_id
	is_running = false
	current_action = null
	EventBus.action_canceled.emit(canceled_id)
	AccessibilityManager.announce("Azione interrotta.", true)
	GameManager.change_state(Enums.GameState.GAMEPLAY_IDLE)
