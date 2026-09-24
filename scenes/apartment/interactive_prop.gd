# res://scenes/apartment/interactive_prop.gd
class_name InteractiveProp
extends Area2D

## Elemento d'Arredo Interattivo nel Loft di New York
## Combina rilevamento prossimità (Area2D), corpo solido invalicabile (StaticBody2D),
## visualizzazione grafica pixel art con Y-Sorting e prompt di interazione per NVDA e Holy Diver.

signal interaction_triggered(prop_id: String)
signal player_entered_zone(prop: InteractiveProp)
signal player_exited_zone(prop: InteractiveProp)
signal prop_clicked(prop: InteractiveProp)

@export var prop_id: String = ""
@export var prop_name: String = ""
@export var prop_description: String = ""
@export var hotkey_hint: String = ""
@export var target_action: String = ""
@export_multiline var inspection_text: String = ""
@export var is_interactable: bool = true
@export var stand_offset: Vector2 = Vector2(0, 40)

var is_player_in_range: bool = false
var _prompt_node: CanvasItem = null
var _sprite_node: Sprite2D = null

func get_stand_position() -> Vector2:
	return global_position + stand_offset


func _ready() -> void:
	y_sort_enabled = true
	_sprite_node = get_node_or_null("Sprite2D")
	_prompt_node = get_node_or_null("Prompt")
	if _prompt_node:
		_prompt_node.visible = false
		
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	input_event.connect(_on_input_event)

func _exit_tree() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func _on_mouse_entered() -> void:
	if not is_interactable:
		return
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	set_highlight(true)

func _on_mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	set_highlight(false)

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if not is_interactable:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		prop_clicked.emit(self)
		get_viewport().set_input_as_handled()


func _on_body_entered(body: Node2D) -> void:
	if not is_interactable:
		return
	if body.is_in_group("player"):
		is_player_in_range = true
		if _prompt_node:
			_prompt_node.visible = true
		if body.has_method("register_nearby_prop"):
			body.call("register_nearby_prop", self)
		player_entered_zone.emit(self)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_player_in_range = false
		if _prompt_node:
			_prompt_node.visible = false
		if body.has_method("unregister_nearby_prop"):
			body.call("unregister_nearby_prop", self)
		player_exited_zone.emit(self)

func trigger_interaction() -> void:
	if not is_interactable:
		return
	interaction_triggered.emit(prop_id)

func set_highlight(enabled: bool) -> void:
	if _prompt_node:
		_prompt_node.visible = enabled or is_player_in_range
	if _sprite_node:
		_sprite_node.modulate = Color(1.2, 1.2, 1.2, 1.0) if enabled else Color(1.0, 1.0, 1.0, 1.0)

func get_accessible_label(index: int = 0, total: int = 0) -> String:
	var prefix: String = ""
	if total > 0:
		prefix = "Oggetto %d di %d: " % [index, total]
	var text: String = prefix + prop_name
	if not hotkey_hint.is_empty():
		text += " (Tasto rapido: " + hotkey_hint + ")"
	if not prop_description.is_empty():
		text += " — " + prop_description
	text += ". Premi Invio o Spazio per interagire."
	return text
