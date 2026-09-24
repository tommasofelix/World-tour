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
var tour_system: TourSystem
var festival_system: FestivalSystem
var social_media_system: SocialMediaSystem
var rival_system: RivalSystem
const AwardSystemScript = preload("res://systems/award_system.gd")
const LegacySystemScript = preload("res://systems/legacy_system.gd")

var chart_system: ChartSystem
var media_system: MediaSystem
var award_system: RefCounted
var legacy_system: RefCounted

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
	tour_system = TourSystem.new(player_data, calendar_data, travel_system, schedule_system, band_system)
	festival_system = FestivalSystem.new(player_data, calendar_data, travel_system, schedule_system, band_system)
	social_media_system = SocialMediaSystem.new(player_data, calendar_data, band_system, music_system)
	rival_system = RivalSystem.new()
	chart_system = ChartSystem.new(player_data, calendar_data, rival_system, social_media_system, album_system)
	media_system = MediaSystem.new(player_data, calendar_data)
	award_system = AwardSystemScript.new(player_data, calendar_data)
	legacy_system = LegacySystemScript.new(player_data, calendar_data)


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

func is_paused() -> bool:
	return current_state == Enums.GameState.GAMEPLAY_PAUSED or (time_system != null and time_system.is_paused)

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

func start_new_game(p_name: String = "Alex", p_instrument: String = "Chitarra Elettrica", p_background: String = "self_taught", p_test_mode: bool = false, p_stage_name: String = "", p_age: int = 20, p_trait: String = "charismatic") -> void:
	var day_duration: float = Constants.DEFAULT_DAY_DURATION_SECONDS
	if SaveManager:
		day_duration = SaveManager.get_day_duration()

	player_data = PlayerData.new()
	player_data.player_name = p_name
	player_data.stage_name = p_stage_name
	player_data.age = p_age
	player_data.primary_instrument = p_instrument
	player_data.background_id = p_background
	player_data.trait_id = p_trait
	
	if p_test_mode:
		player_data.money = 500.0
		player_data.populate_starter_test_songs()
	else:
		player_data.apply_starting_background_and_trait()
		player_data.songs.clear()
	
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
	tour_system = TourSystem.new(player_data, calendar_data, travel_system, schedule_system, band_system)
	festival_system = FestivalSystem.new(player_data, calendar_data, travel_system, schedule_system, band_system)
	social_media_system = SocialMediaSystem.new(player_data, calendar_data, band_system, music_system)
	rival_system = RivalSystem.new()
	chart_system = ChartSystem.new(player_data, calendar_data, rival_system, social_media_system, album_system)
	media_system = MediaSystem.new(player_data, calendar_data)
	award_system = AwardSystemScript.new(player_data, calendar_data)
	legacy_system = LegacySystemScript.new(player_data, calendar_data)
	
	change_state(Enums.GameState.GAMEPLAY_IDLE)

