# res://systems/action_system.gd
class_name ActionSystem
extends RefCounted

## Motore di Convalida ed Esecuzione delle Azioni Quotidiane per World-tour
## Gestisce allenamento competenze, attività di recupero attivo (Sezione 1.3),
## rilevamento delle soglie fisiologiche di Burnout (<15%) e Panico (>=80%).

var player_data: PlayerData
var calendar_data: CalendarData

var current_action: ActionData = null
var current_action_duration: float = 10.0
var action_elapsed: float = 0.0
var is_running: bool = false

func _init(p_player: PlayerData = null, p_calendar: CalendarData = null) -> void:
	player_data = p_player
	calendar_data = p_calendar

func get_player_data() -> PlayerData:
	if player_data:
		return player_data
	if GameManager and GameManager.player_data:
		return GameManager.player_data
	return null

func get_calendar_data() -> CalendarData:
	if calendar_data:
		return calendar_data
	if GameManager and GameManager.calendar_data:
		return GameManager.calendar_data
	return null

func can_start_action(action: ActionData) -> Dictionary:
	var p: PlayerData = get_player_data()
	var c: CalendarData = get_calendar_data()
	if not action:
		return {"can_start": false, "reason": "Azione non valida."}
	if is_running:
		return {"can_start": false, "reason": "Un'altra azione è attualmente in corso."}
	if p and action.money_cost > 0.0 and p.money < action.money_cost:
		return {"can_start": false, "reason": "Denaro insufficiente (richiesti %.2f €)." % action.money_cost}
		
	# Per azioni ordinarie o azioni con costo energetico esplicito
	var required_energy: int = action.energy_cost
	if action.is_recovery:
		required_energy = maxi(0, -action.energy_delta)
	if p and required_energy > 0 and p.energy < required_energy:
		return {"can_start": false, "reason": "Energia insufficiente per avviare questa azione."}
		
	var effective_duration: float = action.duration_seconds
	if p and p.energy < Constants.ENERGY_BURNOUT_THRESHOLD and not action.is_recovery:
		effective_duration *= 2.0
		
	if c and c.remaining_seconds < effective_duration:
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
	var p: PlayerData = get_player_data()
	var c: CalendarData = get_calendar_data()
	
	# Controllo Burnout (< 15% energia) per azioni ordinarie
	if p and p.energy < Constants.ENERGY_BURNOUT_THRESHOLD and not action.is_recovery:
		current_action_duration = action.duration_seconds * 2.0
		AccessibilityManager.announce("Attenzione: Burnout fisico! Livello di energia critico, l'azione richiederà il doppio del tempo.", false)
	else:
		current_action_duration = action.duration_seconds
		
	# Controllo Panico (>= 80% stress)
	if p and p.stress >= Constants.STRESS_PANIC_THRESHOLD:
		AccessibilityManager.announce("Attenzione: Stato di Panico! Livello di stress critico.", false)
		
	GameManager.change_state(Enums.GameState.GAMEPLAY_BUSY)
	EventBus.action_started.emit(action.action_id, current_action_duration)
	AccessibilityManager.announce("Avviata azione: %s" % action.action_name, true)
	return true

func update_action(delta_seconds: float) -> void:
	if not is_running or not current_action:
		return
		
	action_elapsed += delta_seconds
	EventBus.action_progress.emit(current_action.action_id, action_elapsed, current_action_duration)
	
	if action_elapsed >= current_action_duration:
		_complete_action()

func _complete_action() -> void:
	var completed_id: String = current_action.action_id
	var action_name_ref: String = current_action.action_name
	var is_rec: bool = current_action.is_recovery
	is_running = false
	var p: PlayerData = get_player_data()
	var c: CalendarData = get_calendar_data()
	
	# Applicazione costi monetari
	if p and current_action.money_cost > 0.0:
		p.modify_money(-current_action.money_cost)
		EventBus.money_changed.emit(p.money, -current_action.money_cost, action_name_ref)
		
	# Applicazione delta fisiologici (Energia, Stress, Morale)
	if p:
		if is_rec:
			if current_action.energy_delta != 0:
				if current_action.energy_delta > 0:
					p.add_energy(current_action.energy_delta)
				else:
					p.consume_energy(abs(current_action.energy_delta))
			if current_action.stress_delta != 0:
				if current_action.stress_delta > 0:
					p.add_stress(current_action.stress_delta)
				else:
					p.reduce_stress(abs(current_action.stress_delta))
			if current_action.morale_delta != 0:
				p.modify_morale(current_action.morale_delta)
		else:
			p.consume_energy(current_action.energy_cost)
			p.add_stress(current_action.stress_gain)
			
	# Aggiornamento contatore saturazione
	if c:
		c.increment_action_count(completed_id)
		
	# Calcolo XP o benefici speciali
	var gained_xp: float = 0.0
	var leveled_up: bool = false
	var new_lvl: int = 10
	var spark_triggered: bool = false
	
	if current_action.base_xp > 0.0:
		# Calcolo matematico XP standard per allenamenti
		var day_reps: int = 1
		if c:
			day_reps = c.get_action_count(completed_id)
			
		var stress_val: float = float(p.stress) if p else 0.0
		var morale_val: float = float(p.morale) if p else 100.0
		
		gained_xp = Formulas.calculate_training_xp(
			current_action.base_xp,
			current_action.duration_seconds,
			day_reps,
			stress_val,
			morale_val
		)
		
		if p:
			leveled_up = p.add_xp_to_skill(current_action.target_skill, gained_xp)
			new_lvl = p.get_skill_level(current_action.target_skill)
	elif is_rec:
		# Gestione chance ispirazione / Scintilla Creativa per ascolto musica
		if current_action.inspiration_chance > 0.0:
			var roll: float = randf()
			if roll < current_action.inspiration_chance:
				spark_triggered = true
				gained_xp = Constants.RECOVERY_MUSIC_SPARK_XP
				if p:
					leveled_up = p.add_xp_to_skill("songwriting", gained_xp)
					new_lvl = p.get_skill_level("songwriting")
			
	var rewards: Dictionary = {
		"xp_gained": gained_xp,
		"leveled_up": leveled_up,
		"target_skill": current_action.target_skill if current_action.base_xp > 0.0 else ("songwriting" if is_rec else current_action.target_skill),
		"new_level": new_lvl,
		"is_recovery": is_rec,
		"spark_triggered": spark_triggered
	}
	
	EventBus.action_completed.emit(completed_id, rewards)
	
	var announcement_text: String = ""
	if is_rec and current_action.base_xp <= 0.0:
		announcement_text = "Completato: %s." % action_name_ref
		if spark_triggered:
			announcement_text += " Ispirazione musicale! Hai colto un'idea brillante per un nuovo brano (+%.0f XP Scrittura testi)!" % gained_xp
	else:
		announcement_text = "Completato: %s. Guadagnati %.1f XP." % [action_name_ref, gained_xp]
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
