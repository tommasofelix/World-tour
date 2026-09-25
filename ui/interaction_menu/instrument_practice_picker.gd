# res://ui/interaction_menu/instrument_practice_picker.gd
class_name InstrumentPracticePicker
extends Control

## Selettore a Scelta Singola per la Pratica Strumentale & Vocale nel Loft NYC (World-tour V5.8.0)
## Gestisce gli 8 strumenti/voce del Ramo 2 (instrumental_technique).
## Navigazione 100% Zero Mouse per NVDA (Frecce, Numpad 8/2, numeri 1..8, Invio, Esc).

signal instrument_selected(skill_id: String, skill_name: String)
signal picker_closed()

const FONT_ARCADE = preload("res://assets/img/font_text/press_start_2p/PressStart2P.ttf")

@onready var background_panel: Panel = get_node_or_null("BackgroundPanel")
@onready var content_margin: MarginContainer = get_node_or_null("ContentMargin")
@onready var title_label: Label = get_node_or_null("ContentMargin/VBoxMain/TitleLabel")
@onready var options_container: VBoxContainer = get_node_or_null("ContentMargin/VBoxMain/OptionsContainer")

var player_ref: PlayerData = null
var is_picker_open: bool = false
var buttons: Array[Button] = []
var selected_index: int = 0
var current_instruments: Array[Dictionary] = []

func _ready() -> void:
	visible = false
	is_picker_open = false
	_ensure_structure()

func _ensure_structure() -> void:
	if background_panel != null:
		return

	# Generazione gerarchia se non istanziata da scena
	set_anchors_preset(Control.PRESET_TOP_LEFT)
	custom_minimum_size = Vector2(540.0, 560.0)
	size = custom_minimum_size

	background_panel = Panel.new()
	background_panel.name = "BackgroundPanel"
	background_panel.set_anchors_preset(Control.PRESET_FULL_RECT)
	background_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.07, 0.08, 0.12, 0.95)
	sb.set_border_width_all(2)
	sb.border_color = Color(0.85, 0.65, 0.25, 0.95)
	sb.set_corner_radius_all(6)
	sb.shadow_color = Color(0, 0, 0, 0.6)
	sb.shadow_size = 8
	background_panel.add_theme_stylebox_override("panel", sb)
	add_child(background_panel)

	content_margin = MarginContainer.new()
	content_margin.name = "ContentMargin"
	content_margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	content_margin.add_theme_constant_override("margin_left", 18)
	content_margin.add_theme_constant_override("margin_top", 18)
	content_margin.add_theme_constant_override("margin_right", 18)
	content_margin.add_theme_constant_override("margin_bottom", 18)
	add_child(content_margin)

	var vbox := VBoxContainer.new()
	vbox.name = "VBoxMain"
	vbox.add_theme_constant_override("separation", 10)
	content_margin.add_child(vbox)

	title_label = Label.new()
	title_label.name = "TitleLabel"
	title_label.add_theme_font_override("font", FONT_ARCADE)
	title_label.add_theme_font_size_override("font_size", 14)
	title_label.add_theme_color_override("font_color", Color(1, 0.88, 0.45, 1))
	title_label.text = "PRATICA STRUMENTALE & VOCALE"
	vbox.add_child(title_label)

	var hint := Label.new()
	hint.name = "HintLabel"
	hint.add_theme_font_override("font", FONT_ARCADE)
	hint.add_theme_font_size_override("font_size", 9)
	hint.add_theme_color_override("font_color", Color(0.7, 0.8, 0.9, 1))
	hint.text = "Scegli la disciplina da allenare (+20 XP, 10s, Zero Costo):"
	vbox.add_child(hint)

	options_container = VBoxContainer.new()
	options_container.name = "OptionsContainer"
	options_container.add_theme_constant_override("separation", 6)
	vbox.add_child(options_container)

func open_picker(player: PlayerData, target_screen_pos: Vector2 = Vector2.ZERO) -> void:
	player_ref = player
	_ensure_structure()
	is_picker_open = true
	visible = true

	# Posizionamento centrato con clamping
	var menu_size := Vector2(540.0, 560.0)
	custom_minimum_size = menu_size
	size = menu_size

	var final_pos := target_screen_pos
	if final_pos == Vector2.ZERO:
		final_pos = Vector2((1920.0 - menu_size.x) * 0.5, (1080.0 - menu_size.y) * 0.5)
	else:
		final_pos += Vector2(40.0, -menu_size.y * 0.5)

	final_pos.x = clampf(final_pos.x, 20.0, 1920.0 - menu_size.x - 20.0)
	final_pos.y = clampf(final_pos.y, 60.0, 1080.0 - menu_size.y - 80.0)
	position = final_pos

	_build_instruments_list()

	if not buttons.is_empty():
		buttons[0].grab_focus()

	var count: int = current_instruments.size()
	var speech: String = "Menu Pratica Strumentale e Vocale aperto. %d discipline disponibili. Usa Frecce Su e Giù o numeri da 1 a %d per scegliere, Invio per confermare, Esc per chiudere." % [count, count]
	AccessibilityManager.announce(speech, true)
	AccessibilityManager.play_cue(Enums.AudioCueType.HOTSPOT_PROXIMITY)

func close_picker() -> void:
	if not is_picker_open:
		return
	is_picker_open = false
	visible = false
	buttons.clear()
	current_instruments.clear()
	picker_closed.emit()
	AccessibilityManager.announce("Menu Pratica Strumentale chiuso.", true)
	AccessibilityManager.play_cue(Enums.AudioCueType.AREA_PERSONAL)

func _build_instruments_list() -> void:
	for child in options_container.get_children():
		child.queue_free()
	buttons.clear()
	current_instruments.clear()

	if not player_ref:
		return

	var all_skills: Array[Dictionary] = player_ref.get_branch_skills("instrumental_technique")
	current_instruments = all_skills

	var primary_cat: String = player_ref.get_primary_category()

	for i in range(current_instruments.size()):
		var s: Dictionary = current_instruments[i]
		var s_id: String = str(s.get("id", ""))
		var s_name: String = str(s.get("name", s_id))
		var grade: int = int(s.get("grade", 0))
		var stars_disp: String = player_ref.get_skill_stars_display(s_id)

		var is_primary: bool = false
		if s_id.contains(primary_cat) or (primary_cat == "vocals" and s_id == "skill_vocals"):
			is_primary = true

		var btn := Button.new()
		btn.custom_minimum_size = Vector2(0.0, 44.0)
		btn.focus_mode = Control.FOCUS_ALL
		btn.add_theme_font_override("font", FONT_ARCADE)
		btn.add_theme_font_size_override("font_size", 10)
		btn.alignment = HORIZONTAL_ALIGNMENT_LEFT

		var tag_primary: String = " [PRINCIPALE]" if is_primary else ""
		btn.text = "%d. %s%s - %s" % [i + 1, s_name, tag_primary, stars_disp]

		var normal_sb := StyleBoxFlat.new()
		normal_sb.bg_color = Color(0.12, 0.14, 0.20, 0.95)
		normal_sb.set_border_width_all(1)
		normal_sb.border_color = Color(0.35, 0.40, 0.55, 0.8)
		normal_sb.set_corner_radius_all(4)
		btn.add_theme_stylebox_override("normal", normal_sb)

		var focus_sb := StyleBoxFlat.new()
		focus_sb.bg_color = Color(0.22, 0.26, 0.38, 1.0)
		focus_sb.set_border_width_all(2)
		focus_sb.border_color = Color(0.85, 0.65, 0.25, 1.0)
		focus_sb.set_corner_radius_all(4)
		btn.add_theme_stylebox_override("focus", focus_sb)
		btn.add_theme_stylebox_override("hover", focus_sb)

		var captured_idx: int = i
		var captured_id: String = s_id
		var captured_name: String = s_name
		var captured_speech: String = "Opzione %d: %s%s, %s. Premi Invio per avviare la pratica." % [i + 1, s_name, tag_primary, stars_disp]

		btn.focus_entered.connect(func():
			selected_index = captured_idx
			AccessibilityManager.play_cue(Enums.AudioCueType.HOTSPOT_PROXIMITY)
			AccessibilityManager.announce(captured_speech, true)
		)

		btn.pressed.connect(func():
			select_index(captured_idx)
		)

		options_container.add_child(btn)
		buttons.append(btn)

func select_index(idx: int) -> void:
	if idx >= 0 and idx < current_instruments.size():
		var inst: Dictionary = current_instruments[idx]
		_choose_instrument(inst.get("id", ""), inst.get("name", ""))

func _choose_instrument(skill_id: String, skill_name: String) -> void:
	AccessibilityManager.play_cue(Enums.AudioCueType.AREA_PERSONAL)
	is_picker_open = false
	visible = false
	instrument_selected.emit(skill_id, skill_name)

func _unhandled_input(event: InputEvent) -> void:
	if not is_picker_open or not visible:
		return

	if event.is_action_pressed("ui_cancel") or (event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE):
		get_viewport().set_input_as_handled()
		close_picker()
		return

	if event is InputEventKey and event.pressed:
		var key: int = event.keycode
		var num: int = -1
		if key >= KEY_1 and key <= KEY_8:
			num = key - KEY_1
		elif key >= KEY_KP_1 and key <= KEY_KP_8:
			num = key - KEY_KP_1

		if num >= 0 and num < current_instruments.size():
			get_viewport().set_input_as_handled()
			select_index(num)
			return
