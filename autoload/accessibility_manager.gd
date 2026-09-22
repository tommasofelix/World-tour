# res://autoload/accessibility_manager.gd
extends Node

## Gestore Globale di Accessibilità, Navigazione Tastiera, Tasti Rapidi e Sonificazione

signal announcement_spoken(message: String)

var is_tts_enabled: bool = true
var is_ducking: bool = false
var default_tts_voice_id: String = ""

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_setup_tts()
	EventBus.ui_focus_changed.connect(_on_ui_focus_changed)

func _setup_tts() -> void:
	# Verifica e selezione voce TTS se disponibile a livello di DisplayServer
	if DisplayServer.tts_is_speaking() != null:
		var voices: Array = DisplayServer.tts_get_voices()
		if voices.size() > 0:
			default_tts_voice_id = voices[0].id
			# Cerca preferibilmente una voce italiana se presente
			for v in voices:
				var lang: String = v.get("language", "").to_lower()
				if "it" in lang:
					default_tts_voice_id = v.id
					break

func announce(text: String, is_interrupt: bool = true) -> void:
	if text.strip_edges().is_empty():
		return
		
	EventBus.accessibility_announced.emit(text, is_interrupt)
	announcement_spoken.emit(text)
	
	if is_tts_enabled and not default_tts_voice_id.is_empty():
		if is_interrupt:
			DisplayServer.tts_stop()
		DisplayServer.tts_speak(text, default_tts_voice_id, int(Constants.AUDIO_SAFE_VOLUME_LINEAR * 100.0))

func _on_ui_focus_changed(control_name: String, control_role: String, control_value: String) -> void:
	var msg: String = control_name
	if not control_value.is_empty():
		msg += ", " + control_value
	if not control_role.is_empty():
		msg += " (" + control_role + ")"
	# Quando il focus si sposta, annunciamo vocalmente se desiderato
	announce(msg, true)

func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventKey) or not event.is_pressed() or event.is_echo():
		return
		
	var key_event: InputEventKey = event as InputEventKey
	
	# Non intercettare se un LineEdit ha il focus attivo
	var focused_node: Control = get_viewport().gui_get_focus_owner()
	if focused_node is LineEdit or focused_node is TextEdit:
		return
		
	match key_event.keycode:
		KEY_SPACE, KEY_P:
			if GameManager.time_system:
				var paused: bool = GameManager.time_system.toggle_pause()
				announce("Pausa attiva" if paused else "Simulazione ripresa", true)
				get_viewport().set_input_as_handled()
				
		KEY_1:
			if key_event.alt_pressed or key_event.ctrl_pressed:
				return
			if GameManager.time_system:
				GameManager.time_system.set_time_scale(Constants.SPEED_NORMAL)
				announce("Velocità normale 1x", true)
				get_viewport().set_input_as_handled()
				
		KEY_2:
			if GameManager.time_system:
				GameManager.time_system.set_time_scale(Constants.SPEED_FAST)
				announce("Velocità rapida 2x", true)
				get_viewport().set_input_as_handled()
				
		KEY_3:
			if GameManager.time_system:
				GameManager.time_system.set_time_scale(Constants.SPEED_ULTRA)
				announce("Velocità ultra 5x", true)
				get_viewport().set_input_as_handled()
				
		KEY_T:
			if GameManager.calendar_data:
				var time_str: String = GameManager.calendar_data.get_formatted_time_string()
				var period_str: String = GameManager.calendar_data.get_period_name()
				var sec_left: int = int(round(GameManager.calendar_data.remaining_seconds))
				announce("Ore %s, %s. Rimangono %d secondi alla fine della giornata." % [time_str, period_str, sec_left], true)
				get_viewport().set_input_as_handled()
				
		KEY_R:
			if GameManager.player_data:
				var p: PlayerData = GameManager.player_data
				announce("Risorse: Energia %d%%, Stress %d%%, Morale %d%%, Saldo %.2f euro." % [p.energy, p.stress, p.morale, p.money], true)
				get_viewport().set_input_as_handled()
				
		KEY_K:
			if GameManager.player_data:
				var p: PlayerData = GameManager.player_data
				announce("Status: Livello carriera %d, Fan stabili %d, Reputazione %.1f." % [p.career_tier, p.fans, p.reputation], true)
				get_viewport().set_input_as_handled()

func hook_control_accessibility(node: Control, control_name: String, control_description: String = "") -> void:
	if not node:
		return
	node.set_accessibility_name(control_name)
	if not control_description.is_empty():
		node.set_accessibility_description(control_description)
	
	if not node.focus_entered.is_connected(_on_control_focus_entered):
		node.focus_entered.connect(_on_control_focus_entered.bind(node, control_name))

func _on_control_focus_entered(node: Control, c_name: String) -> void:
	var c_role: String = node.get_class()
	var c_val: String = ""
	if node is Button:
		c_role = "Pulsante"
	elif node is Slider:
		c_role = "Cursore"
		c_val = str(round(node.value))
	elif node is CheckBox:
		c_role = "Casella"
		c_val = "Selezionato" if node.button_pressed else "Non selezionato"
		
	EventBus.ui_focus_changed.emit(c_name, c_role, c_val)
