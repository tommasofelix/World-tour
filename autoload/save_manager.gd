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
		"calendar": GameManager.calendar_data.to_dict() if GameManager.calendar_data else {}
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
			
	GameManager.change_state(Enums.GameState.GAMEPLAY_IDLE)
	AccessibilityManager.announce("Partita caricata. Giorno %d, Saldo %.2f euro." % [
		GameManager.calendar_data.day_number,
		GameManager.player_data.money
	], true)
	
	load_completed.emit(true)
	return true
