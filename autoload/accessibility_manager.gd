# res://autoload/accessibility_manager.gd
extends Node

## Gestore Globale di Accessibilità, Navigazione Tastiera, Tasti Rapidi e Sonificazione

signal announcement_spoken(message: String)

const AudioCueSystemScript = preload("res://systems/audio_cue_system.gd")

var is_tts_enabled: bool = true
var is_ducking: bool = false
var default_tts_voice_id: String = ""
var audio_cue_system: Node = null

# Debounce e protezione anti-deadlock per TTS Windows OneCore / SAPI
var _last_announced_text: String = ""
var _last_announced_time: float = 0.0
var _ducking_restore_time: float = 0.0
const ANNOUNCE_DUPLICATE_DEBOUNCE_MS: float = 350.0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_setup_audio_system()
	_setup_tts()
	EventBus.ui_focus_changed.connect(_on_ui_focus_changed)
	EventBus.language_changed.connect(_on_language_changed)

func _setup_audio_system() -> void:
	if not audio_cue_system:
		audio_cue_system = AudioCueSystemScript.new()
		add_child(audio_cue_system)
		EventBus.audio_cue_requested.connect(play_cue)

func play_cue(cue_type: int) -> bool:
	if audio_cue_system:
		return audio_cue_system.play_cue(cue_type)
	return false

func silence() -> void:
	if DisplayServer.has_feature(DisplayServer.FEATURE_TEXT_TO_SPEECH):
		DisplayServer.tts_stop()
	if audio_cue_system:
		audio_cue_system.stop()
		audio_cue_system.set_ducking(false)
	is_ducking = false

func _process(_delta: float) -> void:
	# Ripristino del ducking basato su stima temporale senza polling continuo del thread COM Windows
	if is_ducking and audio_cue_system:
		var now_sec: float = Time.get_ticks_msec() / 1000.0
		if now_sec >= _ducking_restore_time:
			audio_cue_system.set_ducking(false)
			is_ducking = false

func _setup_tts(target_lang: String = "it") -> void:
	# Verifica e selezione voce TTS se disponibile a livello di DisplayServer
	if DisplayServer.has_feature(DisplayServer.FEATURE_TEXT_TO_SPEECH):
		var voices: Array = DisplayServer.tts_get_voices()
		if voices.size() > 0:
			default_tts_voice_id = voices[0].id
			for v in voices:
				var lang: String = v.get("language", "").to_lower()
				if target_lang in lang:
					default_tts_voice_id = v.id
					break

func _on_language_changed(new_lang: String) -> void:
	_setup_tts(new_lang)

func announce(text: String, is_interrupt: bool = true) -> void:
	if text.strip_edges().is_empty():
		return

	# Guardia anti-spam per frasi duplicate a frequenza ravvicinata
	var now_ms: float = Time.get_ticks_msec()
	if text == _last_announced_text and (now_ms - _last_announced_time) < ANNOUNCE_DUPLICATE_DEBOUNCE_MS:
		return
	_last_announced_text = text
	_last_announced_time = now_ms

	EventBus.accessibility_announced.emit(text, is_interrupt)
	announcement_spoken.emit(text)

	# Stima durata vocale per ripristinare il ducking senza stressare il thread audio nativo
	var est_sec: float = clampf(float(text.length()) * 0.065, 0.6, 4.0)
	_ducking_restore_time = (now_ms / 1000.0) + est_sec

	if audio_cue_system:
		audio_cue_system.set_ducking(true)
		is_ducking = true

	if is_tts_enabled and not default_tts_voice_id.is_empty():
		if is_interrupt and DisplayServer.has_feature(DisplayServer.FEATURE_TEXT_TO_SPEECH):
			DisplayServer.tts_stop()
		DisplayServer.tts_speak(text, default_tts_voice_id, int(Constants.AUDIO_SAFE_VOLUME_LINEAR * 100.0))

## Alias per announce: sintesi vocale immediata di messaggi per NVDA
func speak(text: String, is_interrupt: bool = true) -> void:
	announce(text, is_interrupt)

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

	# Non intercettare se un LineEdit ha il focus attivo o se siamo nei menu/modali
	var focused_node: Control = get_viewport().gui_get_focus_owner()
	if focused_node is LineEdit or focused_node is TextEdit:
		return
	if GameManager and GameManager.current_state != Enums.GameState.GAMEPLAY_IDLE and GameManager.current_state != Enums.GameState.GAMEPLAY_BUSY:
		return

	match key_event.keycode:
		# --- Controlli Tastierino Numerico (Numpad Navigation - Sezione 12) ---
		KEY_KP_PERIOD:
			silence()
			get_viewport().set_input_as_handled()
		KEY_KP_5:
			announce_current_focus_info()
			get_viewport().set_input_as_handled()
		KEY_KP_8:
			_simulate_ui_action("ui_up")
			get_viewport().set_input_as_handled()
		KEY_KP_2:
			_simulate_ui_action("ui_down")
			get_viewport().set_input_as_handled()
		KEY_KP_4:
			_simulate_ui_action("ui_left")
			get_viewport().set_input_as_handled()
		KEY_KP_6:
			_simulate_ui_action("ui_right")
			get_viewport().set_input_as_handled()
		KEY_KP_ENTER, KEY_KP_0:
			_simulate_ui_action("ui_accept")
			get_viewport().set_input_as_handled()
		KEY_KP_ADD:
			if GameManager and GameManager.time_system:
				var new_spd: float = GameManager.time_system.cycle_speed()
				announce("Velocità tempo: %.1fx" % new_spd, true)
				get_viewport().set_input_as_handled()
		KEY_KP_SUBTRACT:
			if GameManager and GameManager.time_system:
				var paused: bool = GameManager.time_system.toggle_pause()
				announce("Pausa attiva" if paused else "Simulazione ripresa", true)
				get_viewport().set_input_as_handled()

func _simulate_ui_action(action_name: String) -> void:
	var ev_press := InputEventAction.new()
	ev_press.action = action_name
	ev_press.pressed = true
	Input.parse_input_event(ev_press)

	var ev_release := InputEventAction.new()
	ev_release.action = action_name
	ev_release.pressed = false
	Input.parse_input_event(ev_release)

func announce_current_focus_info() -> void:
	var focused: Control = get_viewport().gui_get_focus_owner()
	if not focused:
		announce("Nessun controllo attualmente selezionato nell'interfaccia.", true)
		return

	var name_str: String = focused.get_accessibility_name()
	if name_str.is_empty() and focused is Button:
		name_str = focused.text
	if name_str.is_empty():
		name_str = focused.name

	var role_str: String = "Controllo"
	var val_str: String = ""
	if focused is Button:
		role_str = "Pulsante"
	elif focused is Slider:
		role_str = "Cursore"
		val_str = str(round(focused.value))
	elif focused is CheckBox:
		role_str = "Casella"
		val_str = "Selezionato" if focused.button_pressed else "Non selezionato"

	var desc_str: String = focused.get_accessibility_description()
	var msg: String = "Focus su %s, %s" % [name_str, role_str]
	if not val_str.is_empty():
		msg += ", valore " + val_str
	if not desc_str.is_empty():
		msg += ". " + desc_str
	announce(msg, true)

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
