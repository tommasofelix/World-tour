# res://autoload/localization_manager.gd
extends Node

## Gestore Centralizzato della Localizzazione (i18n) per World-tour
## Carica i dizionari JSON, popola il TranslationServer nativo di Godot e gestisce la persistenza della lingua.

const SUPPORTED_LOCALES: Array[String] = ["it", "en"]
const DEFAULT_LOCALE: String = "it"

var current_language: String = DEFAULT_LOCALE
var translations_data: Dictionary = {}

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_load_translations()
	_init_language_from_system_or_settings()

func _load_translations() -> void:
	for locale in SUPPORTED_LOCALES:
		var file_path := "res://localization/%s.json" % locale
		var file := FileAccess.open(file_path, FileAccess.READ)
		if not file:
			push_warning("Impossibile aprire il file di traduzione: " + file_path)
			continue
			
		var content := file.get_as_text()
		file.close()
		
		var json := JSON.new()
		var parse_result := json.parse(content)
		if parse_result != OK:
			push_error("Errore nel parsing JSON per %s: %s" % [file_path, json.get_error_message()])
			continue
			
		var dict: Dictionary = json.data if json.data is Dictionary else {}
		translations_data[locale] = dict
		
		# Registrazione in TranslationServer di Godot
		var godot_translation := Translation.new()
		godot_translation.locale = locale
		for key in dict:
			godot_translation.add_message(key, str(dict[key]))
		
		TranslationServer.add_translation(godot_translation)

func _init_language_from_system_or_settings() -> void:
	var chosen_lang := ""
	
	# 1. Verifica se esiste già un'impostazione salvata valida
	if FileAccess.file_exists("user://settings.json"):
		var s_file := FileAccess.open("user://settings.json", FileAccess.READ)
		if s_file:
			var s_json := JSON.new()
			if s_json.parse(s_file.get_as_text()) == OK and s_json.data is Dictionary:
				chosen_lang = str(s_json.data.get("language", "")).strip_edges()
			s_file.close()
	
	# 2. Se non c'è impostazione salvata valida, rileva la lingua dell'OS con fallback rigoroso su 'it'
	if chosen_lang.is_empty() or not (chosen_lang in SUPPORTED_LOCALES):
		var os_lang := OS.get_locale_language().to_lower()
		if os_lang.is_empty():
			os_lang = OS.get_locale().to_lower()
			
		if os_lang.begins_with("en"):
			chosen_lang = "en"
		else:
			chosen_lang = DEFAULT_LOCALE # Rigorosamente "it" come default di progetto
			
		_persist_settings_language(chosen_lang)
	
	set_language(chosen_lang, false)

func set_language(lang_code: String, save_to_disk: bool = true) -> void:
	if not (lang_code in SUPPORTED_LOCALES):
		push_warning("Lingua non supportata: " + lang_code + ". Impostazione fallback su: " + DEFAULT_LOCALE)
		lang_code = DEFAULT_LOCALE
		
	current_language = lang_code
	TranslationServer.set_locale(lang_code)
	
	if save_to_disk:
		_persist_settings_language(lang_code)
		if GameManager and GameManager.player_data:
			GameManager.player_data.language = lang_code
			
	EventBus.language_changed.emit(lang_code)

func get_current_language() -> String:
	return current_language

func get_available_languages() -> Array[Dictionary]:
	return [
		{"code": "it", "name": tr("LANG_IT") if not tr("LANG_IT").is_empty() else "Italiano"},
		{"code": "en", "name": tr("LANG_EN") if not tr("LANG_EN").is_empty() else "English"}
	]

func get_text(key: String, default_value: String = "") -> String:
	var val := tr(key)
	if val == key and not default_value.is_empty():
		return default_value
	return val

func _persist_settings_language(lang_code: String) -> void:
	var settings: Dictionary = {}
	if FileAccess.file_exists("user://settings.json"):
		var f := FileAccess.open("user://settings.json", FileAccess.READ)
		if f:
			var j := JSON.new()
			if j.parse(f.get_as_text()) == OK and j.data is Dictionary:
				settings = j.data
			f.close()
			
	settings["language"] = lang_code
	var out_f := FileAccess.open("user://settings.json", FileAccess.WRITE)
	if out_f:
		out_f.store_string(JSON.stringify(settings, "\t"))
		out_f.close()
