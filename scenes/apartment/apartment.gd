# res://scenes/apartment/apartment.gd
class_name ApartmentScene
extends Node2D

## Scena Principale del Loft di New York — Gameplay Grafico 2.5D (V5.4.0)
## Gestisce lo spazio esplorabile isometrico, il movimento del personaggio Alex,
## gli arredi interattivi, il doppio canale di accessibilità (Luca NVDA Zero Mouse & Holy Diver a monitor),
## il ciclo di navigazione logica con Tab/Numpad e il collegamento alle 19 modali del simulatore.

@onready var y_sort_root: Node2D = $YSortRoot
@onready var player: CharacterBody2D = $YSortRoot/PlayerAlex
@onready var camera: Camera2D = $Camera2D
@onready var hud: Control = $CanvasLayer/ApartmentHud

var props: Array[Area2D] = []
var selected_prop_index: int = -1

func _ready() -> void:
	if GameManager:
		GameManager.change_state(Enums.GameState.GAMEPLAY_IDLE)

	_collect_and_setup_props()

	if player and player.has_signal("interaction_requested"):
		player.interaction_requested.connect(_on_player_interaction_requested)

	if hud:
		hud.modal_opened.connect(_on_modal_opened)
		hud.modal_closed.connect(_on_modal_closed)

	EventBus.action_started.connect(_on_action_started)
	EventBus.action_completed.connect(_on_action_ended)
	EventBus.action_canceled.connect(_on_action_ended)

	# Annuncio iniziale di benvenuto per NVDA
	AccessibilityManager.announce("Benvenuto nel loft di New York. Usa le Frecce o il Numpad per muoverti, Tab per scorrere gli arredi, Spazio per interagire, Esc per il menu di sistema.", true)

func _collect_and_setup_props() -> void:
	props.clear()
	for child in y_sort_root.get_children():
		if child is Area2D and child.has_signal("interaction_triggered"):
			props.append(child)
			child.interaction_triggered.connect(_on_prop_interaction)
			if child.has_signal("player_entered_zone"):
				child.player_entered_zone.connect(_on_player_entered_prop)
			if child.has_signal("player_exited_zone"):
				child.player_exited_zone.connect(_on_player_exited_prop)
			if child.has_signal("prop_clicked"):
				child.prop_clicked.connect(_on_prop_clicked)

func _on_prop_clicked(prop: Area2D) -> void:
	if not hud or hud.is_any_modal_open() or (GameManager and GameManager.current_state == Enums.GameState.GAMEPLAY_BUSY) or (hud and hud.action_system and hud.action_system.is_running):
		return
	AccessibilityManager.play_cue(Enums.AudioCueType.HOTSPOT_PROXIMITY)
	if ("is_player_in_range" in prop and prop.is_player_in_range) or (player and player.global_position.distance_to(prop.global_position) < 55.0):
		_open_prop_interaction_menu(prop)
		return
	
	var target_pos: Vector2 = prop.get_stand_position() if prop.has_method("get_stand_position") else (prop.global_position + Vector2(0, 30))
	if player and player.has_method("walk_to_target"):
		player.walk_to_target(target_pos, func():
			_open_prop_interaction_menu(prop)
		, prop)
	else:
		_open_prop_interaction_menu(prop)

func _open_prop_interaction_menu(prop: Area2D) -> void:
	if not hud or not prop:
		return
	var p_id: String = prop.prop_id if "prop_id" in prop else ""
	var p_name: String = prop.prop_name if "prop_name" in prop else "Arredo"
	var acts: Array[Dictionary] = ApartmentInteractions.get_actions_for_prop(p_id)
	
	if not acts.is_empty():
		var screen_pos: Vector2 = Vector2.ZERO
		if camera:
			screen_pos = camera.get_viewport_transform() * prop.global_position
		else:
			screen_pos = prop.global_position
		hud.open_interaction_menu_for_prop(p_id, p_name, acts, screen_pos)
	else:
		prop.trigger_interaction()

func _on_player_entered_prop(prop: Area2D) -> void:
	if not hud or hud.is_any_modal_open():
		return
	AccessibilityManager.play_cue(Enums.AudioCueType.HOTSPOT_PROXIMITY)
	var txt: String = prop.inspection_text if ("inspection_text" in prop and not prop.inspection_text.is_empty()) else prop.get_accessible_label()
	hud.show_inspection(txt, "ALEX", "[Spazio] Interagisci   [Tab] Altri arredi   [Esc] Menu")
	var p_name: String = prop.prop_name if "prop_name" in prop else "Arredo"
	AccessibilityManager.announce("Vicino a: " + p_name, true)

func _on_player_exited_prop(_prop: Area2D) -> void:
	if not hud or hud.is_any_modal_open():
		return
	if selected_prop_index < 0:
		hud.reset_inspection()

func _on_player_interaction_requested(prop: Area2D) -> void:
	if not prop or (hud and hud.is_any_modal_open()) or (GameManager and GameManager.current_state == Enums.GameState.GAMEPLAY_BUSY) or (hud and hud.action_system and hud.action_system.is_running):
		return
	_open_prop_interaction_menu(prop)

func _on_prop_interaction(prop_id: String) -> void:
	if not hud:
		return
	hud.open_modal_by_prop_id(prop_id)

func _on_action_started(_action_id: String, _duration: float) -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	if player:
		player.is_movement_locked = true
		player.velocity = Vector2.ZERO
		player.cancel_auto_walk()

func _on_action_ended(_arg1 = null, _arg2 = null) -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	if player and not (hud and hud.is_any_modal_open()):
		player.is_movement_locked = false

func _on_modal_opened(_modal_name: String) -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	if player:
		player.is_movement_locked = true
		player.velocity = Vector2.ZERO
		player.cancel_auto_walk()

func _on_modal_closed(_modal_name: String) -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	if player and not (GameManager and GameManager.current_state == Enums.GameState.GAMEPLAY_BUSY):
		player.is_movement_locked = false
	if hud and not hud.is_any_modal_open():
		hud.reset_inspection()

func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventKey) or not event.is_pressed() or event.is_echo():
		return

	var key_event := event as InputEventKey

	# Se un'azione a durata temporale è in corso (GAMEPLAY_BUSY), blocca comandi e intercetta Esc per annullare
	if (GameManager and GameManager.current_state == Enums.GameState.GAMEPLAY_BUSY) or (hud and hud.action_system and hud.action_system.is_running):
		if key_event.keycode == KEY_ESCAPE:
			if hud and hud.action_system and hud.action_system.is_running:
				hud.action_system.cancel_action()
				hud.reset_inspection()
			get_viewport().set_input_as_handled()
		return

	# Se una modale è aperta, l'input viene gestito dalla modale
	if hud and hud.is_any_modal_open():
		if key_event.keycode == KEY_ESCAPE:
			hud.hide_all_modals()
			if GameManager:
				GameManager.close_menu()
			if player:
				player.is_movement_locked = false
			hud.reset_inspection()
			get_viewport().set_input_as_handled()
		return

	# --- Canale Logico Assistito: Navigazione Ciclica Arredi (Tab / Shift+Tab / Numpad 7/9) ---
	if key_event.keycode == KEY_TAB:
		var dir: int = -1 if key_event.shift_pressed else 1
		_cycle_prop_selection(dir)
		get_viewport().set_input_as_handled()
		return
	elif key_event.keycode == KEY_KP_7:
		_cycle_prop_selection(-1)
		get_viewport().set_input_as_handled()
		return
	elif key_event.keycode == KEY_KP_9:
		_cycle_prop_selection(1)
		get_viewport().set_input_as_handled()
		return
	elif key_event.keycode == KEY_KP_5:
		if selected_prop_index >= 0:
			_announce_current_prop()
			get_viewport().set_input_as_handled()
			return

	# Interazione su arredo selezionato da ciclo Tab
	if (key_event.keycode == KEY_SPACE or key_event.keycode == KEY_ENTER or key_event.keycode == KEY_KP_ENTER or key_event.keycode == KEY_KP_0) and selected_prop_index >= 0:
		_interact_with_selected_prop()
		get_viewport().set_input_as_handled()
		return

	# Tasto Escape: cancella selezione Tab oppure apre SystemMenu
	if key_event.keycode == KEY_ESCAPE:
		if selected_prop_index >= 0:
			_clear_prop_selection()
			AccessibilityManager.announce("Navigazione libera ripristinata.", true)
			hud.reset_inspection()
		else:
			hud.open_modal(hud.system_menu_modal)
		get_viewport().set_input_as_handled()
		return

	# --- Conservazione dei 15 Tasti Rapidi HUD Storici ---
	match key_event.keycode:
		KEY_P:
			# Pratica / Nuovo brano
			hud.open_modal(hud.song_creator_modal)
			get_viewport().set_input_as_handled()
		KEY_N:
			hud.open_modal(hud.song_creator_modal)
			get_viewport().set_input_as_handled()
		KEY_K:
			hud.open_modal(hud.song_catalog_modal)
			get_viewport().set_input_as_handled()
		KEY_L:
			hud.open_modal(hud.live_concert_modal)
			get_viewport().set_input_as_handled()
		KEY_B:
			hud.open_modal(hud.band_hub_modal)
			get_viewport().set_input_as_handled()
		KEY_I:
			hud.open_modal(hud.industry_hub_modal)
			get_viewport().set_input_as_handled()
		KEY_V:
			hud.open_modal(hud.travel_modal)
			get_viewport().set_input_as_handled()
		KEY_O:
			hud.open_modal(hud.tour_modal)
			get_viewport().set_input_as_handled()
		KEY_F:
			hud.open_modal(hud.festival_modal)
			get_viewport().set_input_as_handled()
		KEY_Y:
			hud.open_modal(hud.social_modal)
			get_viewport().set_input_as_handled()
		KEY_H:
			hud.open_modal(hud.chart_modal)
			get_viewport().set_input_as_handled()
		KEY_U:
			hud.open_modal(hud.upgrades_modal)
			get_viewport().set_input_as_handled()
		KEY_R:
			hud.open_modal(hud.relax_modal)
			get_viewport().set_input_as_handled()
		KEY_C:
			hud.open_modal(hud.character_sheet_modal)
			get_viewport().set_input_as_handled()
		KEY_W:
			hud.open_modal(hud.legacy_modal)
			get_viewport().set_input_as_handled()
		KEY_1, KEY_KP_1:
			# Macro-Categoria 1: Personale
			hud.open_modal(hud.character_sheet_modal)
			get_viewport().set_input_as_handled()
		KEY_2, KEY_KP_2:
			# Macro-Categoria 2: Creazione / Musiche
			hud.open_modal(hud.song_catalog_modal)
			get_viewport().set_input_as_handled()
		KEY_3, KEY_KP_3:
			# Macro-Categoria 3: Carriera / Live
			hud.open_modal(hud.live_concert_modal)
			get_viewport().set_input_as_handled()
		KEY_4, KEY_KP_4:
			# Macro-Categoria 4: Social / Upgrade
			hud.open_modal(hud.social_modal)
			get_viewport().set_input_as_handled()
		KEY_5, KEY_KP_5:
			# Macro-Categoria 5: Band
			hud.open_modal(hud.band_hub_modal)
			get_viewport().set_input_as_handled()
		KEY_Z:
			# Dormi subito / Concludi giornata
			if GameManager and GameManager.time_system:
				AccessibilityManager.announce("Vai a dormire in anticipo.", true)
				GameManager.time_system.trigger_sleep_now()
			get_viewport().set_input_as_handled()
		KEY_X:
			# Salta orario / Riposo veloce
			if GameManager and GameManager.time_system:
				AccessibilityManager.announce("Avanzamento fascia oraria.", true)
				GameManager.time_system.advance_to_next_period()
			get_viewport().set_input_as_handled()

func _cycle_prop_selection(direction: int) -> void:
	if props.is_empty():
		return
	if selected_prop_index < 0:
		selected_prop_index = 0 if direction > 0 else (props.size() - 1)
	else:
		selected_prop_index = (selected_prop_index + direction + props.size()) % props.size()

	_highlight_selected_prop()
	_announce_current_prop()

func _highlight_selected_prop() -> void:
	for i in range(props.size()):
		props[i].set_highlight(i == selected_prop_index)

	if selected_prop_index >= 0 and selected_prop_index < props.size():
		var p: Area2D = props[selected_prop_index]
		var txt: String = p.inspection_text if ("inspection_text" in p and not p.inspection_text.is_empty()) else p.get_accessible_label(selected_prop_index + 1, props.size())
		if hud:
			hud.show_inspection(txt, "ALEX", "[Invio / Spazio] Interagisci   [Tab] Successivo   [Esc] Annulla")

func _clear_prop_selection() -> void:
	selected_prop_index = -1
	for p in props:
		if p.has_method("set_highlight"):
			p.set_highlight(false)

func _announce_current_prop() -> void:
	if selected_prop_index >= 0 and selected_prop_index < props.size():
		var p: Area2D = props[selected_prop_index]
		var speech: String = p.get_accessible_label(selected_prop_index + 1, props.size())
		AccessibilityManager.announce(speech, true)

func _interact_with_selected_prop() -> void:
	if selected_prop_index < 0 or selected_prop_index >= props.size():
		return
	var p: Area2D = props[selected_prop_index]
	var target_pos: Vector2 = p.get_stand_position() if p.has_method("get_stand_position") else (p.global_position + Vector2(0, 30))
	
	if player and player.has_method("walk_to_target"):
		player.walk_to_target(target_pos, func():
			_open_prop_interaction_menu(p)
			_clear_prop_selection()
		, p)
	else:
		_open_prop_interaction_menu(p)
		_clear_prop_selection()
