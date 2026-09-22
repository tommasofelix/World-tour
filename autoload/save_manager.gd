# res://autoload/save_manager.gd
extends Node

## Gestore della Persistenza Dati Atomica e Sicura per World-tour

const SAVE_PATH: String = "user://savegame.json"
const TEMP_PATH: String = "user://savegame.tmp"
const CURRENT_SCHEMA_VERSION: int = 1

signal save_completed(success: bool)
signal load_completed(success: bool)

func is_save_allowed() -> bool:
	# Salvataggio consentito unicamente in stato IDLE o DAILY_SUMMARY
	return GameManager.current_state != Enums.GameState.GAMEPLAY_BUSY

func save_game() -> bool:
	if not is_save_allowed():
		AccessibilityManager.announce("Impossibile salvare durante un'azione in corso.", true)
		save_completed.emit(false)
		return false
		
	var save_dict: Dictionary = {
		"schema_version": CURRENT_SCHEMA_VERSION,
		"timestamp": Time.get_datetime_string_from_system(),
		"player": GameManager.player_data.to_dict() if GameManager.player_data else {},
		"calendar": GameManager.calendar_data.to_dict() if GameManager.calendar_data else {},
		"schedule": GameManager.schedule_system.to_dict() if GameManager.schedule_system else [],
		"travel": GameManager.travel_system.to_dict() if GameManager.travel_system else {},
		"tour": GameManager.tour_system.to_dict() if GameManager.tour_system else {},
		"festivals": GameManager.festival_system.to_dict() if GameManager.festival_system else {}
	}
	
	var json_string: String = JSON.stringify(save_dict, "\t")
	
	# 1. Scrittura su file temporaneo
	var file: FileAccess = FileAccess.open(TEMP_PATH, FileAccess.WRITE)
	if not file:
		AccessibilityManager.announce("Errore nell'apertura del file temporaneo di salvataggio.", true)
		save_completed.emit(false)
		return false
		
	file.store_string(json_string)
	file.close()
	
	# 2. Sostituzione atomica del file definitivo
	var dir: DirAccess = DirAccess.open("user://")
	if not dir:
		AccessibilityManager.announce("Errore di accesso alla cartella utente.", true)
		save_completed.emit(false)
		return false
		
	if dir.file_exists("savegame.json"):
		dir.remove("savegame.json")
		
	var err: Error = dir.rename("savegame.tmp", "savegame.json")
	if err != OK:
		AccessibilityManager.announce("Errore nella ridenominazione atomica del salvataggio.", true)
		save_completed.emit(false)
		return false
		
	AccessibilityManager.announce("Partita salvata con successo.", true)
	save_completed.emit(true)
	return true

func has_savegame() -> bool:
	return FileAccess.file_exists(SAVE_PATH)

func load_game() -> bool:
	if not has_savegame():
		AccessibilityManager.announce("Nessun salvataggio trovato.", true)
		load_completed.emit(false)
		return false
		
	var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		AccessibilityManager.announce("Impossibile leggere il file di salvataggio.", true)
		load_completed.emit(false)
		return false
		
	var content: String = file.get_as_text()
	file.close()
	
	var json: JSON = JSON.new()
	var parse_err: Error = json.parse(content)
	if parse_err != OK:
		AccessibilityManager.announce("File di salvataggio corrotto o non leggibile.", true)
		load_completed.emit(false)
		return false
		
	var data: Variant = json.data
	if not (data is Dictionary):
		AccessibilityManager.announce("Formato dati di salvataggio non valido.", true)
		load_completed.emit(false)
		return false
		
	var save_dict: Dictionary = data as Dictionary
	if save_dict.has("player") and save_dict["player"] is Dictionary:
		if not GameManager.player_data:
			GameManager.player_data = PlayerData.new()
		GameManager.player_data.from_dict(save_dict["player"])
		
	if save_dict.has("calendar") and save_dict["calendar"] is Dictionary:
		if not GameManager.calendar_data:
			GameManager.calendar_data = CalendarData.new()
		GameManager.calendar_data.from_dict(save_dict["calendar"])
		if not GameManager.time_system:
			GameManager.time_system = TimeSystem.new(GameManager.calendar_data)
		else:
			GameManager.time_system.calendar_data = GameManager.calendar_data
			
	if not GameManager.skill_system:
		GameManager.skill_system = SkillSystem.new(GameManager.player_data)
	else:
		GameManager.skill_system.player_data = GameManager.player_data
		
	if not GameManager.music_system:
		GameManager.music_system = MusicSystem.new(GameManager.player_data, GameManager.calendar_data, GameManager.skill_system)
	else:
		GameManager.music_system.player_data = GameManager.player_data
		GameManager.music_system.calendar_data = GameManager.calendar_data
		GameManager.music_system.skill_system = GameManager.skill_system

	if not GameManager.band_system:
		GameManager.band_system = BandSystem.new(GameManager.player_data, GameManager.calendar_data)
	else:
		GameManager.band_system.player_data = GameManager.player_data
		GameManager.band_system.calendar_data = GameManager.calendar_data
		
	if not GameManager.album_system:
		GameManager.album_system = AlbumSystem.new(GameManager.player_data, GameManager.calendar_data)
	else:
		GameManager.album_system.player_data = GameManager.player_data
		GameManager.album_system.calendar_data = GameManager.calendar_data
		
	if not GameManager.industry_system:
		GameManager.industry_system = IndustrySystem.new(GameManager.player_data, GameManager.calendar_data)
	else:
		GameManager.industry_system.player_data = GameManager.player_data
		GameManager.industry_system.calendar_data = GameManager.calendar_data
		
	if not GameManager.dilemma_system:
		GameManager.dilemma_system = DilemmaSystem.new(GameManager.player_data, GameManager.calendar_data)
	else:
		GameManager.dilemma_system.player_data = GameManager.player_data
		GameManager.dilemma_system.calendar_data = GameManager.calendar_data

	if not GameManager.schedule_system:
		GameManager.schedule_system = ScheduleSystem.new(GameManager.player_data, GameManager.calendar_data)
	else:
		GameManager.schedule_system.player_data = GameManager.player_data
		GameManager.schedule_system.calendar_data = GameManager.calendar_data

	if save_dict.has("schedule") and save_dict["schedule"] is Array:
		GameManager.schedule_system.from_dict(save_dict["schedule"] as Array)
	else:
		GameManager.schedule_system.ensure_monthly_rent_scheduled()

	if not GameManager.travel_system:
		GameManager.travel_system = TravelSystem.new(GameManager.player_data, GameManager.calendar_data)
	else:
		GameManager.travel_system.player_data = GameManager.player_data
		GameManager.travel_system.calendar_data = GameManager.calendar_data

	if save_dict.has("travel") and save_dict["travel"] is Dictionary:
		GameManager.travel_system.from_dict(save_dict["travel"] as Dictionary)

	if not GameManager.tour_system:
		GameManager.tour_system = TourSystem.new(GameManager.player_data, GameManager.calendar_data, GameManager.travel_system, GameManager.schedule_system, GameManager.band_system)
	else:
		GameManager.tour_system.player_data = GameManager.player_data
		GameManager.tour_system.calendar_data = GameManager.calendar_data
		GameManager.tour_system.travel_system = GameManager.travel_system
		GameManager.tour_system.schedule_system = GameManager.schedule_system
		GameManager.tour_system.band_system = GameManager.band_system

	if save_dict.has("tour") and save_dict["tour"] is Dictionary:
		GameManager.tour_system.from_dict(save_dict["tour"] as Dictionary)

	if not GameManager.festival_system:
		GameManager.festival_system = FestivalSystem.new(GameManager.player_data, GameManager.calendar_data, GameManager.travel_system, GameManager.schedule_system, GameManager.band_system)
	else:
		GameManager.festival_system.player_data = GameManager.player_data
		GameManager.festival_system.calendar_data = GameManager.calendar_data
		GameManager.festival_system.travel_system = GameManager.travel_system
		GameManager.festival_system.schedule_system = GameManager.schedule_system
		GameManager.festival_system.band_system = GameManager.band_system

	if save_dict.has("festivals") and save_dict["festivals"] is Dictionary:
		GameManager.festival_system.from_dict(save_dict["festivals"] as Dictionary)

	GameManager.change_state(Enums.GameState.GAMEPLAY_IDLE)
	
	# Allineamento della lingua salvata nella scheda giocatore se presente
	if GameManager.player_data and not GameManager.player_data.language.is_empty():
		if LocalizationManager:
			LocalizationManager.set_language(GameManager.player_data.language, false)

	AccessibilityManager.announce("Partita caricata. Giorno %d, Saldo %.2f euro." % [
		GameManager.calendar_data.day_number,
		GameManager.player_data.money
	], true)
	
	load_completed.emit(true)
	return true

func save_settings(settings_dict: Dictionary) -> bool:
	var current: Dictionary = load_settings()
	for k in settings_dict:
		current[k] = settings_dict[k]
	var f := FileAccess.open("user://settings.json", FileAccess.WRITE)
	if not f:
		return false
	f.store_string(JSON.stringify(current, "\t"))
	f.close()
	return true

func load_settings() -> Dictionary:
	if not FileAccess.file_exists("user://settings.json"):
		return {}
	var f := FileAccess.open("user://settings.json", FileAccess.READ)
	if not f:
		return {}
	var content := f.get_as_text()
	f.close()
	var json := JSON.new()
	if json.parse(content) == OK and json.data is Dictionary:
		return json.data as Dictionary
	return {}

func get_day_duration() -> float:
	var s: Dictionary = load_settings()
	return float(s.get("day_duration", Constants.DEFAULT_DAY_DURATION_SECONDS))

func set_day_duration(p_duration: float) -> void:
	save_settings({"day_duration": p_duration})
