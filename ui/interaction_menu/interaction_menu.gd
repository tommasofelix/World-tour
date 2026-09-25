# res://ui/interaction_menu/interaction_menu.gd
class_name InteractionMenu
extends Control

## Menu Interazioni a Pergamena Pixel Art per gli Arredi del Loft NYC (V5.6.0)
## Adatta dinamicamente lo sfondo (interazione_corta, interazione_media, interazione_lunga)
## e garantisce la perfetta Simmetria Universale (mouse per Holy Diver, NVDA Zero Mouse per Luca).

signal action_chosen(prop_id: String, action_data: Dictionary)
signal menu_closed()

const TEX_CORTA = preload("res://assets/img/gameplay/GUI/Menu_interazione/interazione_corta.png")
const TEX_MEDIA = preload("res://assets/img/gameplay/GUI/Menu_interazione/interazione_media.png")
const TEX_LUNGA = preload("res://assets/img/gameplay/GUI/Menu_interazione/interazione_lunga.png")
const FONT_ARCADE = preload("res://assets/img/font_text/press_start_2p/PressStart2P.ttf")

@onready var background_texture: TextureRect = $BackgroundTexture
@onready var content_margin: MarginContainer = $ContentMargin
@onready var title_label: Label = $ContentMargin/VBoxMain/TitleLabel
@onready var options_container: VBoxContainer = $ContentMargin/VBoxMain/OptionsContainer

var current_prop_id: String = ""
var current_prop_name: String = ""
var current_actions: Array[Dictionary] = []
var selected_index: int = 0
var is_menu_open: bool = false
var buttons: Array[Button] = []

func _ready() -> void:
	visible = false
	is_menu_open = false

func open_menu(prop_id: String, prop_name: String, actions: Array[Dictionary], target_screen_pos: Vector2 = Vector2.ZERO) -> void:
	if actions.is_empty():
		return

	current_prop_id = prop_id
	current_prop_name = prop_name
	current_actions = actions
	selected_index = 0
	is_menu_open = true
	visible = true
	set_anchors_preset(Control.PRESET_TOP_LEFT)

	# Scelta deterministica della texture pergamena in base al numero di azioni
	var chosen_tex: Texture2D = TEX_CORTA
	var menu_size: Vector2 = Vector2(320, 190)

	if actions.size() <= 2:
		chosen_tex = TEX_CORTA
		menu_size = Vector2(320, 190)
	elif actions.size() <= 4:
		chosen_tex = TEX_MEDIA
		menu_size = Vector2(320, 400)
	else:
		chosen_tex = TEX_LUNGA
		menu_size = Vector2(320, mini(680, 110 + actions.size() * 55))

	if background_texture:
		background_texture.texture = chosen_tex

	custom_minimum_size = menu_size
	size = menu_size

	# Posizionamento a schermo con clamping di sicurezza (non esce da 1920x1080)
	var final_pos: Vector2 = target_screen_pos
	if final_pos == Vector2.ZERO:
		# Default centrato o offset standard
		final_pos = Vector2((1920.0 - menu_size.x) * 0.5, (1080.0 - menu_size.y) * 0.5)
	else:
		# Offset per non coprire direttamente l'arredo
		final_pos += Vector2(40.0, -menu_size.y * 0.5)

	# Clamping entro i limiti viewport (lasciando spazio per HUD superiore e inferiore)
	final_pos.x = clampf(final_pos.x, 20.0, 1920.0 - menu_size.x - 20.0)
	final_pos.y = clampf(final_pos.y, 80.0, 1080.0 - menu_size.y - 130.0)
	position = final_pos

	# Titolo dell'arredo
	if title_label:
		title_label.text = prop_name.to_upper()

	# Creazione pulsanti opzioni
	_build_options()

	# Focus immediato sulla prima opzione
	if not buttons.is_empty():
		buttons[0].grab_focus()

	# Annuncio vocale per screen reader NVDA
	var speech: String = "Menu interazione aperto: %s. %d azioni disponibili. Usa Frecce Su e Giù o i numeri da 1 a %d per scegliere, Invio per confermare, Esc per chiudere." % [prop_name, actions.size(), actions.size()]
	AccessibilityManager.announce(speech, true)
	AccessibilityManager.play_cue(Enums.AudioCueType.HOTSPOT_PROXIMITY)

func close_menu() -> void:
	if not is_menu_open:
		return
	is_menu_open = false
	visible = false
	current_actions.clear()
	buttons.clear()
	menu_closed.emit()
	AccessibilityManager.announce("Menu interazione chiuso.", true)
	AccessibilityManager.play_cue(Enums.AudioCueType.AREA_PERSONAL)

func _build_options() -> void:
	for child in options_container.get_children():
		child.queue_free()
	buttons.clear()

	for i in range(current_actions.size()):
		var act: Dictionary = current_actions[i]
		var btn: Button = Button.new()
		
		var dur_hint: String = ""
		if act.get("duration_seconds", 0.0) > 0.0:
			dur_hint = " (%ds)" % int(act["duration_seconds"])

		btn.text = "[%d] %s%s" % [i + 1, act.get("title", "Azione"), dur_hint]
		btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		btn.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		btn.focus_mode = FOCUS_ALL
		btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

		# Stile visivo pulsante retrò con alto contrasto
		_apply_button_style(btn)

		var idx: int = i
		btn.pressed.connect(func(): _on_option_selected(idx))
		btn.mouse_entered.connect(func(): btn.grab_focus())
		btn.focus_entered.connect(func(): _on_button_focus(idx))

		options_container.add_child(btn)
		buttons.append(btn)

func _apply_button_style(btn: Button) -> void:
	if FONT_ARCADE:
		btn.add_theme_font_override("font", FONT_ARCADE)
	btn.add_theme_font_size_override("font_size", 8)

	var sb_normal := StyleBoxFlat.new()
	sb_normal.bg_color = Color(0.18, 0.11, 0.06, 0.75)
	sb_normal.border_width_left = 1
	sb_normal.border_width_top = 1
	sb_normal.border_width_right = 1
	sb_normal.border_width_bottom = 1
	sb_normal.border_color = Color(0.42, 0.28, 0.16, 0.9)
	sb_normal.corner_radius_top_left = 3
	sb_normal.corner_radius_top_right = 3
	sb_normal.corner_radius_bottom_right = 3
	sb_normal.corner_radius_bottom_left = 3
	sb_normal.content_margin_left = 6
	sb_normal.content_margin_top = 5
	sb_normal.content_margin_right = 6
	sb_normal.content_margin_bottom = 5

	var sb_hover := StyleBoxFlat.new()
	sb_hover.bg_color = Color(0.72, 0.45, 0.12, 0.95)
	sb_hover.border_width_left = 2
	sb_hover.border_width_top = 2
	sb_hover.border_width_right = 2
	sb_hover.border_width_bottom = 2
	sb_hover.border_color = Color(0.98, 0.85, 0.40, 1.0)
	sb_hover.corner_radius_top_left = 3
	sb_hover.corner_radius_top_right = 3
	sb_hover.corner_radius_bottom_right = 3
	sb_hover.corner_radius_bottom_left = 3
	sb_hover.content_margin_left = 6
	sb_hover.content_margin_top = 5
	sb_hover.content_margin_right = 6
	sb_hover.content_margin_bottom = 5

	btn.add_theme_stylebox_override("normal", sb_normal)
	btn.add_theme_stylebox_override("hover", sb_hover)
	btn.add_theme_stylebox_override("focus", sb_hover)
	btn.add_theme_stylebox_override("pressed", sb_hover)

	btn.add_theme_color_override("font_color", Color(0.95, 0.92, 0.85, 1.0))
	btn.add_theme_color_override("font_hover_color", Color(1.0, 1.0, 1.0, 1.0))
	btn.add_theme_color_override("font_focus_color", Color(1.0, 1.0, 1.0, 1.0))

func _on_button_focus(index: int) -> void:
	if index < 0 or index >= current_actions.size():
		return
	selected_index = index
	var act: Dictionary = current_actions[index]
	var dur_str: String = ""
	if act.get("duration_seconds", 0.0) > 0.0:
		dur_str = " (Durata: %d secondi)" % int(act["duration_seconds"])

	var desc_str: String = act.get("description", "")
	var speech: String = "Opzione %d di %d: %s%s. %s" % [index + 1, current_actions.size(), act.get("title", ""), dur_str, desc_str]
	AccessibilityManager.announce(speech, false)
	AccessibilityManager.play_cue(Enums.AudioCueType.HOTSPOT_PROXIMITY)

func _on_option_selected(index: int) -> void:
	if index < 0 or index >= current_actions.size():
		return
	var chosen_action: Dictionary = current_actions[index]
	var p_id: String = current_prop_id
	AccessibilityManager.play_cue(Enums.AudioCueType.HOTSPOT_PROXIMITY)
	is_menu_open = false
	visible = false
	menu_closed.emit()
	action_chosen.emit(p_id, chosen_action)

func _unhandled_input(event: InputEvent) -> void:
	if not visible or not is_menu_open:
		return

	if not (event is InputEventKey) or not event.is_pressed() or event.is_echo():
		return

	var key_event := event as InputEventKey

	if key_event.keycode == KEY_ESCAPE:
		close_menu()
		get_viewport().set_input_as_handled()
		return

	# Scorciatoie numeriche dirette 1..9 e Numpad 1..9
	var num_pressed: int = -1
	if key_event.keycode >= KEY_1 and key_event.keycode <= KEY_9:
		num_pressed = key_event.keycode - KEY_1 + 1
	elif key_event.keycode >= KEY_KP_1 and key_event.keycode <= KEY_KP_9:
		num_pressed = key_event.keycode - KEY_KP_1 + 1

	if num_pressed > 0 and num_pressed <= current_actions.size():
		_on_option_selected(num_pressed - 1)
		get_viewport().set_input_as_handled()
		return
