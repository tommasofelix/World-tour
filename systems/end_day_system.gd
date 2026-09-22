# res://systems/end_day_system.gd
class_name EndDaySystem
extends RefCounted

## Sistema di Risoluzione della Fine Giornata, Spese di Sussistenza e Sonno

signal summary_ready(summary_data: Dictionary)

var player_data: PlayerData
var calendar_data: CalendarData

func _init(p_player: PlayerData = null, p_calendar: CalendarData = null) -> void:
	player_data = p_player
	calendar_data = p_calendar
	EventBus.day_ended.connect(_on_day_ended)

func _on_day_ended(day_num: int) -> void:
	GameManager.change_state(Enums.GameState.DAILY_SUMMARY)
	
	var total_expenses: float = Constants.DAILY_FOOD_EXPENSE + Constants.DAILY_ROOM_RENT
	if player_data:
		player_data.modify_money(-total_expenses)
		EventBus.money_changed.emit(player_data.money, -total_expenses, "Spese vive (vitto e alloggio)")
		if GameManager and GameManager.economy_system:
			GameManager.economy_system.log_transaction(-total_expenses, "rent", "Spese vive (vitto e alloggio)", day_num)
		
		# Rigenerazione del sonno
		player_data.add_energy(Constants.SLEEP_STANDARD_ENERGY)
		player_data.reduce_stress(Constants.SLEEP_STANDARD_STRESS_RELIEF)
		
	var summary: Dictionary = {
		"completed_day": day_num,
		"expenses": total_expenses,
		"new_balance": player_data.money if player_data else 0.0,
		"current_energy": player_data.energy if player_data else 100,
		"current_stress": player_data.stress if player_data else 0
	}
	
	summary_ready.emit(summary)
	
	var speech: String = "Fine della giornata %d. Addebitate spese vive per %.2f euro. Nuovo saldo: %.2f euro. Sonno ristoratore: energia al %d%%." % [
		day_num,
		total_expenses,
		player_data.money if player_data else 0.0,
		player_data.energy if player_data else 100
	]
	AccessibilityManager.announce(speech, true)

func advance_to_next_day() -> void:
	if calendar_data:
		calendar_data.day_number += 1
		calendar_data.reset_daily_saturation()
		
	GameManager.change_state(Enums.GameState.GAMEPLAY_IDLE)
	
	var new_day: int = calendar_data.day_number if calendar_data else 1
	EventBus.day_started.emit(new_day)
	AccessibilityManager.announce("Inizia il Giorno %d. Buongiorno!" % new_day, true)
