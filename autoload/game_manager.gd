# res://autoload/game_manager.gd
extends Node

## Macchina a Stati Globale e Coordinatore del Ciclo di Vita di World-tour

signal state_changed(old_state: int, new_state: int)

var current_state: int = Enums.GameState.BOOT
var previous_state: int = Enums.GameState.BOOT

var player_data: PlayerData
var calendar_data: CalendarData
var time_system: TimeSystem

func _ready() -> void:
	# Inizializzazione dati di default
	player_data = PlayerData.new()
	calendar_data = CalendarData.new()
	time_system = TimeSystem.new(calendar_data)

func change_state(new_state: int) -> bool:
	if current_state == new_state:
		return false
		
	var old_state: int = current_state
	previous_state = old_state
	current_state = new_state
	
	state_changed.emit(old_state, new_state)
	return true

func is_action_allowed() -> bool:
	return current_state == Enums.GameState.GAMEPLAY_IDLE

func open_menu() -> void:
	if current_state != Enums.GameState.GAMEPLAY_PAUSED:
		change_state(Enums.GameState.GAMEPLAY_PAUSED)
		if time_system:
			time_system.set_paused(true)

func close_menu() -> void:
	if current_state == Enums.GameState.GAMEPLAY_PAUSED:
		change_state(previous_state)
		if time_system:
			time_system.set_paused(false)

func start_new_game(p_name: String = "Alex", p_instrument: String = "Chitarra Elettrica", p_background: String = "self_taught") -> void:
	player_data = PlayerData.new()
	player_data.player_name = p_name
	player_data.primary_instrument = p_instrument
	player_data.background_id = p_background
	
	calendar_data = CalendarData.new()
	time_system = TimeSystem.new(calendar_data)
	
	change_state(Enums.GameState.GAMEPLAY_IDLE)
