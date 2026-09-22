# res://autoload/game_manager.gd
extends Node

## Macchina a Stati Globale e Coordinatore del Ciclo di Vita di World-tour

signal state_changed(old_state: int, new_state: int)

var current_state: int = Enums.GameState.BOOT
var previous_state: int = Enums.GameState.BOOT

var player_data: PlayerData
var calendar_data: CalendarData
var time_system: TimeSystem
var skill_system: SkillSystem
var music_system: MusicSystem
var concert_system: ConcertSystem
var career_system: CareerSystem
var economy_system: EconomySystem
var end_day_system: EndDaySystem
var band_system: BandSystem
var album_system: AlbumSystem
var industry_system: IndustrySystem
var dilemma_system: DilemmaSystem
var schedule_system: ScheduleSystem
var travel_system: TravelSystem

func _ready() -> void:
	# Inizializzazione dati di default
	var default_day_duration: float = Constants.DEFAULT_DAY_DURATION_SECONDS
	if SaveManager:
		default_day_duration = SaveManager.get_day_duration()
		
	player_data = PlayerData.new()
	player_data.populate_starter_test_songs()
	
	calendar_data = CalendarData.new(default_day_duration)
	time_system = TimeSystem.new(calendar_data)
	skill_system = SkillSystem.new(player_data)
	music_system = MusicSystem.new(player_data, calendar_data, skill_system)
	concert_system = ConcertSystem.new(player_data, calendar_data, skill_system)
	career_system = CareerSystem.new(player_data)
	economy_system = EconomySystem.new(player_data, calendar_data)
	end_day_system = EndDaySystem.new(player_data, calendar_data)
	band_system = BandSystem.new(player_data, calendar_data)
	album_system = AlbumSystem.new(player_data, calendar_data)
	industry_system = IndustrySystem.new(player_data, calendar_data)
	dilemma_system = DilemmaSystem.new(player_data, calendar_data)
	schedule_system = ScheduleSystem.new(player_data, calendar_data)
	schedule_system.ensure_monthly_rent_scheduled()
	travel_system = TravelSystem.new(player_data, calendar_data)

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
	var day_duration: float = Constants.DEFAULT_DAY_DURATION_SECONDS
	if SaveManager:
		day_duration = SaveManager.get_day_duration()

	player_data = PlayerData.new()
	player_data.player_name = p_name
	player_data.primary_instrument = p_instrument
	player_data.background_id = p_background
	player_data.populate_starter_test_songs()
	
	calendar_data = CalendarData.new(day_duration)
	time_system = TimeSystem.new(calendar_data)
	skill_system = SkillSystem.new(player_data)
	music_system = MusicSystem.new(player_data, calendar_data, skill_system)
	concert_system = ConcertSystem.new(player_data, calendar_data, skill_system)
	career_system = CareerSystem.new(player_data)
	economy_system = EconomySystem.new(player_data, calendar_data)
	end_day_system = EndDaySystem.new(player_data, calendar_data)
	band_system = BandSystem.new(player_data, calendar_data)
	album_system = AlbumSystem.new(player_data, calendar_data)
	industry_system = IndustrySystem.new(player_data, calendar_data)
	dilemma_system = DilemmaSystem.new(player_data, calendar_data)
	schedule_system = ScheduleSystem.new(player_data, calendar_data)
	schedule_system.ensure_monthly_rent_scheduled()
	travel_system = TravelSystem.new(player_data, calendar_data)
	
	change_state(Enums.GameState.GAMEPLAY_IDLE)
