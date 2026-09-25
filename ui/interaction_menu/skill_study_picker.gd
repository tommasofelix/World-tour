# res://ui/interaction_menu/skill_study_picker.gd
class_name SkillStudyPicker
extends Control

## Selettore a Scelta Singola per lo Studio Approfondito nel Loft NYC (World-tour V5.8.0)
## Gestisce le 31 competenze canoniche dell'Albero delle Abilità per:
## - Studio su Manuale (Metodo 1 - sblocco basi Grado 1 o avanzamento a Grado 2);
## - Corso in Accademia Musicale (Metodo 2 - avanzamento fino a Grado 3);
## - Lezione Privata col Maestro (Metodo 3 - avanzamento fino a Grado 5).
## Supporta navigazione rapida per Ramo con tasti G, S, A, P, T, B e 100% NVDA Zero Mouse.

signal skill_selected(skill_id: String, skill_name: String, method_type: int)
signal study_picker_closed()

const FONT_ARCADE = preload("res://assets/img/font_text/press_start_2p/PressStart2P.ttf")

@onready var background_panel: Panel = get_node_or_null("BackgroundPanel")
@onready var content_margin: MarginContainer = get_node_or_null("ContentMargin")
@onready var title_label: Label = get_node_or_null("ContentMargin/VBoxMain/TitleLabel")
@onready var method_hint_label: Label = get_node_or_null("ContentMargin/VBoxMain/MethodHintLabel")
@onready var branch_filter_label: Label = get_node_or_null("ContentMargin/VBoxMain/BranchFilterLabel")
@onready var scroll_container: ScrollContainer = get_node_or_null("ContentMargin/VBoxMain/ScrollContainer")
@onready var options_container: VBoxContainer = get_node_or_null("ContentMargin/VBoxMain/ScrollContainer/OptionsContainer")

var player_ref: PlayerData = null
var current_method: int = 0 # 0=MANUAL, 1=ACADEMY, 2=MENTOR
var is_picker_open: bool = false
var active_branch_filter: String = "" # vuoto = tutte le 31 skill
var filtered_skills: Array[Dictionary] = []
var buttons: Array[Button] = []
var selected_index: int = 0

func _ready() -> void:
	visible = false
	is_picker_open = false
	_ensure_structure()

func _ensure_structure() -> void:
	if background_panel != null:
		return

	set_anchors_preset(Control.PRESET_TOP_LEFT)
	custom_minimum_size = Vector2(720.0, 720.0)
	size = custom_minimum_size

	background_panel = Panel.new()
	background_panel.name = "BackgroundPanel"
	background_panel.set_anchors_preset(Control.PRESET_FULL_RECT)
	background_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.06, 0.07, 0.11, 0.96)
	sb.set_border_width_all(2)
	sb.border_color = Color(0.35, 0.75, 0.95, 0.95)
	sb.set_corner_radius_all(6)
	sb.shadow_color = Color(0, 0, 0, 0.7)
	sb.shadow_size = 10
	background_panel.add_theme_stylebox_override("panel", sb)
	add_child(background_panel)

	content_margin = MarginContainer.new()
	content_margin.name = "ContentMargin"
	content_margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	content_margin.add_theme_constant_override("margin_left", 18)
	content_margin.add_theme_constant_override("margin_top", 16)
	content_margin.add_theme_constant_override("margin_right", 18)
	content_margin.add_theme_constant_override("margin_bottom", 16)
	add_child(content_margin)

	var vbox := VBoxContainer.new()
	vbox.name = "VBoxMain"
	vbox.add_theme_constant_override("separation", 8)
	content_margin.add_child(vbox)

	title_label = Label.new()
	title_label.name = "TitleLabel"
	title_label.add_theme_font_override("font", FONT_ARCADE)
	title_label.add_theme_font_size_override("font_size", 13)
	title_label.add_theme_color_override("font_color", Color(0.4, 0.85, 1.0, 1))
	title_label.text = "STUDIO SELETTIVO COMPETENZE"
	vbox.add_child(title_label)

	method_hint_label = Label.new()
	method_hint_label.name = "MethodHintLabel"
	method_hint_label.add_theme_font_override("font", FONT_ARCADE)
	method_hint_label.add_theme_font_size_override("font_size", 9)
	method_hint_label.add_theme_color_override("font_color", Color(0.9, 0.8, 0.4, 1))
	vbox.add_child(method_hint_label)

	branch_filter_label = Label.new()
	branch_filter_label.name = "BranchFilterLabel"
	branch_filter_label.add_theme_font_override("font", FONT_ARCADE)
	branch_filter_label.add_theme_font_size_override("font_size", 8)
	branch_filter_label.add_theme_color_override("font_color", Color(0.7, 0.75, 0.85, 1))
	branch_filter_label.text = "Filtri rapidi Ramo: [G] Generi | [S] Strumenti | [A] Armonia | [P] Palco | [T] Studio | [B] Business | [0] Tutto"
	vbox.add_child(branch_filter_label)

	scroll_container = ScrollContainer.new()
	scroll_container.name = "ScrollContainer"
	scroll_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll_container.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	vbox.add_child(scroll_container)

	options_container = VBoxContainer.new()
	options_container.name = "OptionsContainer"
	options_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	options_container.add_theme_constant_override("separation", 6)
	scroll_container.add_child(options_container)

func open_study_picker(player: PlayerData, method_type: int, target_screen_pos: Vector2 = Vector2.ZERO) -> void:
	player_ref = player
	current_method = method_type
	active_branch_filter = ""
	_ensure_structure()
	is_picker_open = true
	visible = true

	var menu_size := Vector2(720.0, 720.0)
	custom_minimum_size = menu_size
	size = menu_size

	var final_pos := target_screen_pos
	if final_pos == Vector2.ZERO:
		final_pos = Vector2((1920.0 - menu_size.x) * 0.5, (1080.0 - menu_size.y) * 0.5)
	else:
		final_pos += Vector2(40.0, -menu_size.y * 0.5)

	final_pos.x = clampf(final_pos.x, 20.0, 1920.0 - menu_size.x - 20.0)
	final_pos.y = clampf(final_pos.y, 40.0, 1080.0 - menu_size.y - 60.0)
	position = final_pos

	var method_desc: String = ""
	match current_method:
		PlayerData.StudyMethodType.MANUAL:
			title_label.text = "STUDIO SU MANUALE TEORICO (DIVANO)"
			method_desc = "Metodo 1: Lettura teorica (+35 XP, 10s, 0 €). Sblocca Grado 1 o allena fino a Grado 2."
		PlayerData.StudyMethodType.ACADEMY:
			title_label.text = "CORSO IN ACCADEMIA MUSICALE (CONSERVATORIO)"
			method_desc = "Metodo 2: Masterclass istituzionale (+50 XP, 12s, Costo 30.00 €). Allena fino a Grado 3."
		PlayerData.StudyMethodType.MENTOR:
			title_label.text = "LEZIONE PRIVATA COL MAESTRO (MENTORE)"
			method_desc = "Metodo 3: Lezione d'élite a domicilio (+80 XP, 12s, Costo 50.00 €). Allena fino a Grado 5."
		_:
			title_label.text = "STUDIO SELETTIVO"
			method_desc = "Scegli l'abilità da allenare:"
	method_hint_label.text = method_desc

	_build_skills_list()

	if not buttons.is_empty():
		buttons[0].grab_focus()

	var speech: String = "Menu Studio Selettivo aperto: %s. %d competenze mostrate. Usa Frecce Su e Giù per scorrere, Invio per confermare, G, S, A, P, T, B per filtrare i rami, Esc per chiudere." % [title_label.text, filtered_skills.size()]
	AccessibilityManager.announce(speech, true)
	AccessibilityManager.play_cue(Enums.AudioCueType.HOTSPOT_PROXIMITY)

func close_study_picker() -> void:
	if not is_picker_open:
		return
	is_picker_open = false
	visible = false
	buttons.clear()
	filtered_skills.clear()
	study_picker_closed.emit()
	AccessibilityManager.announce("Menu Studio Selettivo chiuso.", true)
	AccessibilityManager.play_cue(Enums.AudioCueType.AREA_PERSONAL)

func _build_skills_list() -> void:
	for child in options_container.get_children():
		child.queue_free()
	buttons.clear()
	filtered_skills.clear()

	if not player_ref:
		return

	var all_skills: Array[Dictionary] = player_ref.get_all_skill_tree_summary()
	for s in all_skills:
		if active_branch_filter.is_empty() or s.get("branch", "") == active_branch_filter:
			filtered_skills.append(s)

	for i in range(filtered_skills.size()):
		var s: Dictionary = filtered_skills[i]
		var s_id: String = str(s.get("id", ""))
		var s_name: String = str(s.get("name", s_id))
		var branch: String = str(s.get("branch", ""))
		var branch_name: String = str(PlayerData.SKILL_BRANCH_NAMES.get(branch, branch))
		var stars_disp: String = player_ref.get_skill_stars_display(s_id)

		var elig: Dictionary = player_ref.validate_study_eligibility(s_id, current_method)
		var is_eligible: bool = elig.get("is_eligible", false)
		var tag_status: String = "[IDONEA]" if is_eligible else "[%s]" % elig.get("code", "BLOCCATA")

		var btn := Button.new()
		btn.custom_minimum_size = Vector2(0.0, 42.0)
		btn.focus_mode = Control.FOCUS_ALL
		btn.add_theme_font_override("font", FONT_ARCADE)
		btn.add_theme_font_size_override("font_size", 9)
		btn.alignment = HORIZONTAL_ALIGNMENT_LEFT

		btn.text = "%d. %s - %s - %s" % [i + 1, s_name, stars_disp, tag_status]

		var normal_sb := StyleBoxFlat.new()
		normal_sb.bg_color = Color(0.10, 0.12, 0.18, 0.95) if is_eligible else Color(0.12, 0.08, 0.08, 0.85)
		normal_sb.set_border_width_all(1)
		normal_sb.border_color = Color(0.25, 0.55, 0.75, 0.8) if is_eligible else Color(0.5, 0.2, 0.2, 0.6)
		normal_sb.set_corner_radius_all(4)
		btn.add_theme_stylebox_override("normal", normal_sb)

		var focus_sb := StyleBoxFlat.new()
		focus_sb.bg_color = Color(0.20, 0.30, 0.45, 1.0) if is_eligible else Color(0.35, 0.18, 0.18, 1.0)
		focus_sb.set_border_width_all(2)
		focus_sb.border_color = Color(0.40, 0.85, 1.0, 1.0) if is_eligible else Color(0.9, 0.3, 0.3, 1.0)
		focus_sb.set_corner_radius_all(4)
		btn.add_theme_stylebox_override("focus", focus_sb)
		btn.add_theme_stylebox_override("hover", focus_sb)

		var captured_idx: int = i
		var captured_id: String = s_id
		var captured_name: String = s_name
		var captured_elig: Dictionary = elig
		var captured_speech: String = "Voce %d: %s, ramo %s. %s. Stato: %s. %s" % [
			i + 1, s_name, branch_name, stars_disp,
			"Idonea allo studio" if is_eligible else "Non idonea",
			"Premi Invio per confermare." if is_eligible else elig.get("reason", "")
		]

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
	if idx >= 0 and idx < filtered_skills.size():
		var s: Dictionary = filtered_skills[idx]
		var s_id: String = str(s.get("id", ""))
		var s_name: String = str(s.get("name", s_id))
		var elig: Dictionary = player_ref.validate_study_eligibility(s_id, current_method) if player_ref else {"is_eligible": true}
		_attempt_study_selection(s_id, s_name, elig)

func _attempt_study_selection(skill_id: String, skill_name: String, elig: Dictionary) -> void:
	if not elig.get("is_eligible", false):
		AccessibilityManager.play_cue(Enums.AudioCueType.AREA_PERSONAL)
		var reject_msg: String = "Impossibile avviare lo studio: %s" % elig.get("reason", "Requisiti non soddisfatti.")
		AccessibilityManager.announce(reject_msg, true)
		return

	AccessibilityManager.play_cue(Enums.AudioCueType.AREA_CREATION)
	is_picker_open = false
	visible = false
	skill_selected.emit(skill_id, skill_name, current_method)

func set_branch_filter(branch_id: String) -> void:
	active_branch_filter = branch_id
	var filter_name: String = "Tutti i Rami (31 Competenze)"
	if not branch_id.is_empty():
		filter_name = str(PlayerData.SKILL_BRANCH_NAMES.get(branch_id, branch_id))
	_build_skills_list()
	if not buttons.is_empty():
		buttons[0].grab_focus()
	AccessibilityManager.announce("Filtro ramo applicato: %s. %d competenze visualizzate." % [filter_name, filtered_skills.size()], true)

func _unhandled_input(event: InputEvent) -> void:
	if not is_picker_open or not visible:
		return

	if event.is_action_pressed("ui_cancel") or (event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE):
		get_viewport().set_input_as_handled()
		close_study_picker()
		return

	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_G:
				get_viewport().set_input_as_handled()
				set_branch_filter("genre_mastery")
				return
			KEY_S:
				get_viewport().set_input_as_handled()
				set_branch_filter("instrumental_technique")
				return
			KEY_A:
				get_viewport().set_input_as_handled()
				set_branch_filter("songwriting_harmony")
				return
			KEY_P:
				get_viewport().set_input_as_handled()
				set_branch_filter("stage_showmanship")
				return
			KEY_T:
				get_viewport().set_input_as_handled()
				set_branch_filter("engineering_hardware")
				return
			KEY_B:
				get_viewport().set_input_as_handled()
				set_branch_filter("industry_business")
				return
			KEY_0, KEY_KP_0:
				get_viewport().set_input_as_handled()
				set_branch_filter("")
				return
