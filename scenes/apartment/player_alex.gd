# res://scenes/apartment/player_alex.gd
class_name PlayerAlex
extends CharacterBody2D

## Controller del protagonista Alex nel Loft di New York (V5.4.0)
## Supporta movimento 4/8 direzioni (Frecce, WASD, Numpad), animazioni direzionali,
## collisione fisica alla base dei piedi per clearance isometrica fluida,
## bump audio protetto su impatti e interazione con gli arredi del loft.

signal interaction_requested(prop: Area2D)
signal bumped_into_obstacle(collision: KinematicCollision2D)
signal position_updated(new_pos: Vector2)

@export var move_speed: float = 210.0
@export var is_movement_locked: bool = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var current_facing: String = "down" # down, up, left, right
var active_nearby_props: Array[Area2D] = []
var _last_bump_time: float = 0.0
const BUMP_DEBOUNCE_DELAY: float = 0.32

# Movimento assistito (Auto-walk per selezione logica Tab/Numpad)
var is_auto_walking: bool = false
var _auto_walk_target: Vector2 = Vector2.ZERO
var _auto_walk_callback: Callable
var _auto_walk_timer: float = 0.0
var _last_auto_walk_pos: Vector2 = Vector2.ZERO
var _stuck_timer: float = 0.0
const AUTO_WALK_MAX_DURATION: float = 2.0

func _ready() -> void:
	add_to_group("player")
	y_sort_enabled = true
	_update_animation("idle")

func _physics_process(delta: float) -> void:
	var input_vector := _get_input_vector()

	# Interruzione immediata di auto-walk se il giocatore tocca la tastiera (Priorità Zero Mouse)
	if input_vector != Vector2.ZERO and is_auto_walking:
		cancel_auto_walk()

	if is_auto_walking:
		_process_auto_walk(delta)
		return

	if is_movement_locked or (GameManager and GameManager.is_paused()):
		_update_animation("idle")
		velocity = Vector2.ZERO
		return
	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()
		_update_facing(input_vector)
		velocity = input_vector * move_speed
		_update_animation("walk")
	else:
		velocity = Vector2.ZERO
		_update_animation("idle")

	move_and_slide()

	# Rilevamento collisioni per bump audio NVDA
	if input_vector != Vector2.ZERO and get_slide_collision_count() > 0:
		_check_collision_bump()

	if input_vector != Vector2.ZERO:
		position_updated.emit(global_position)

func _get_input_vector() -> Vector2:
	var v := Vector2.ZERO
	# Controlli Frecce direzionali e WASD
	if Input.is_action_pressed("ui_up") or Input.is_key_pressed(KEY_W):
		v.y -= 1.0
	if Input.is_action_pressed("ui_down") or Input.is_key_pressed(KEY_S):
		v.y += 1.0
	if Input.is_action_pressed("ui_left") or Input.is_key_pressed(KEY_A):
		v.x -= 1.0
	if Input.is_action_pressed("ui_right") or Input.is_key_pressed(KEY_D):
		v.x += 1.0

	# Controlli Numpad (8=su, 2=giù, 4=sinistra, 6=destra, 7/9/1/3 diagonali)
	if Input.is_key_pressed(KEY_KP_8):
		v.y -= 1.0
	if Input.is_key_pressed(KEY_KP_2):
		v.y += 1.0
	if Input.is_key_pressed(KEY_KP_4):
		v.x -= 1.0
	if Input.is_key_pressed(KEY_KP_6):
		v.x += 1.0
	if Input.is_key_pressed(KEY_KP_7):
		v.x -= 1.0
		v.y -= 1.0
	if Input.is_key_pressed(KEY_KP_9):
		v.x += 1.0
		v.y -= 1.0
	if Input.is_key_pressed(KEY_KP_1):
		v.x -= 1.0
		v.y += 1.0
	if Input.is_key_pressed(KEY_KP_3):
		v.x += 1.0
		v.y += 1.0

	return v

func _update_facing(dir: Vector2) -> void:
	if abs(dir.x) > abs(dir.y):
		current_facing = "right" if dir.x > 0 else "left"
	else:
		current_facing = "down" if dir.y > 0 else "up"

func _update_animation(anim_type: String) -> void:
	if not animated_sprite:
		return
	var anim_name: String = anim_type + "_" + current_facing
	if animated_sprite.sprite_frames and animated_sprite.sprite_frames.has_animation(anim_name):
		if animated_sprite.animation != anim_name or not animated_sprite.is_playing():
			animated_sprite.play(anim_name)

func _check_collision_bump() -> void:
	var now: float = Time.get_ticks_msec() / 1000.0
	if now - _last_bump_time >= BUMP_DEBOUNCE_DELAY:
		_last_bump_time = now
		var col := get_slide_collision(0)
		bumped_into_obstacle.emit(col)
		if AccessibilityManager:
			AccessibilityManager.play_cue(Enums.AudioCueType.COLLISION_BUMP)

func _unhandled_input(event: InputEvent) -> void:
	if is_movement_locked:
		return
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		if event.keycode == KEY_SPACE or event.keycode == KEY_ENTER or event.keycode == KEY_E or event.keycode == KEY_KP_ENTER or event.keycode == KEY_KP_0:
			if not active_nearby_props.is_empty():
				var nearest_prop: Area2D = active_nearby_props[0]
				interaction_requested.emit(nearest_prop)
				get_viewport().set_input_as_handled()

func register_nearby_prop(prop: Area2D) -> void:
	if not active_nearby_props.has(prop):
		active_nearby_props.append(prop)

func unregister_nearby_prop(prop: Area2D) -> void:
	active_nearby_props.erase(prop)

func get_nearest_active_prop() -> Area2D:
	if active_nearby_props.is_empty():
		return null
	return active_nearby_props[0]

func walk_to_target(target_pos: Vector2, on_reached: Callable = Callable()) -> void:
	is_auto_walking = true
	_auto_walk_target = target_pos
	_auto_walk_callback = on_reached
	_auto_walk_timer = 0.0
	_stuck_timer = 0.0
	_last_auto_walk_pos = global_position
	var diff: Vector2 = _auto_walk_target - global_position
	if diff != Vector2.ZERO:
		_update_facing(diff)
		_update_animation("walk")

func cancel_auto_walk() -> void:
	is_auto_walking = false
	_auto_walk_callback = Callable()
	_auto_walk_timer = 0.0
	_stuck_timer = 0.0
	velocity = Vector2.ZERO
	_update_animation("idle")

func _process_auto_walk(delta: float) -> void:
	_auto_walk_timer += delta
	if global_position.distance_to(_last_auto_walk_pos) < 1.0:
		_stuck_timer += delta
	else:
		_stuck_timer = 0.0
	_last_auto_walk_pos = global_position

	var diff: Vector2 = _auto_walk_target - global_position
	var dist: float = diff.length()

	# Condizione di completamento (arrivo a destinazione, oppure arresto per stallo o timeout di sicurezza)
	if dist <= 12.0 or _stuck_timer > 0.35 or _auto_walk_timer >= AUTO_WALK_MAX_DURATION:
		is_auto_walking = false
		velocity = Vector2.ZERO
		_update_animation("idle")
		if _auto_walk_callback.is_valid():
			var cb: Callable = _auto_walk_callback
			_auto_walk_callback = Callable()
			cb.call()
		return

	var dir: Vector2 = diff.normalized()
	_update_facing(dir)
	velocity = dir * move_speed
	_update_animation("walk")
	move_and_slide()
