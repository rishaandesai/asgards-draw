extends CharacterBody2D
class_name Player

const SPEED = 150.0
const PUSH_FORCE = 10.0
const ZOOM_FACTOR = 10.0
const MIN_ZOOM = 0.05
const MAX_ZOOM = 3.0
const TILE_SIZE = 16

@onready var camera = $Camera2D
@onready var animation_player = $AnimationPlayer
@onready var ray = $RayCast2D

var terrain
var last_direction = "front"

var last_position = Vector2.ZERO
var target_position = Vector2.ZERO
var movedir = Vector2.ZERO

var zoom_hold_add = false
var zoom_hold_sub = false
var zoom_hold_timer_add = 0.0
var zoom_hold_timer_sub = 0.0

func _ready() -> void:
	terrain = get_tree().get_root().find_child("LandscapeTilemap", true, false)
	if terrain == null:
		push_error("LandscapeTilemap not found — terrain is null and movement will crash.")
	var tweener = create_tween()
	tweener.tween_property($PointLight2D, "energy", 1.0, 2)

func _physics_process(delta: float) -> void:
	if last_position == Vector2.ZERO:
		last_position = position
		target_position = position

	if position == target_position:
		get_movedir()
		last_position = position
		target_position += movedir * TILE_SIZE

	position += SPEED * movedir * delta

	if position.distance_to(last_position) >= TILE_SIZE - SPEED * delta:
		position = target_position

	if movedir.x:
		last_direction = "left" if movedir.x < 0 else "right"
	elif movedir.y:
		last_direction = "back" if movedir.y < 0 else "front"

	if position != last_position:
		animation_player.play("run_" + last_direction)
	else:
		animation_player.play("idle_" + last_direction)

	if zoom_hold_add:
		zoom_hold_timer_add += delta
		if zoom_hold_timer_add >= 0.5:
			camera.zoom *= ZOOM_FACTOR
			camera.zoom = camera.zoom.clamp(Vector2(MIN_ZOOM, MIN_ZOOM), Vector2(MAX_ZOOM, MAX_ZOOM))
			zoom_hold_timer_add = 0.0

	if zoom_hold_sub:
		zoom_hold_timer_sub += delta
		if zoom_hold_timer_sub >= 0.5:
			camera.zoom /= ZOOM_FACTOR
			camera.zoom = camera.zoom.clamp(Vector2(MIN_ZOOM, MIN_ZOOM), Vector2(MAX_ZOOM, MAX_ZOOM))
			zoom_hold_timer_sub = 0.0

	_handle_pushing()
	z_index = clamp(int(position.y), 0, 4096)

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.physical_keycode == KEY_EQUAL or event.physical_keycode == KEY_KP_ADD:
			camera.zoom *= ZOOM_FACTOR
			camera.zoom = camera.zoom.clamp(Vector2(MIN_ZOOM, MIN_ZOOM), Vector2(MAX_ZOOM, MAX_ZOOM))
			zoom_hold_add = true
			zoom_hold_timer_add = 0.0
		elif event.physical_keycode == KEY_MINUS or event.physical_keycode == KEY_KP_SUBTRACT:
			camera.zoom /= ZOOM_FACTOR
			camera.zoom = camera.zoom.clamp(Vector2(MIN_ZOOM, MIN_ZOOM), Vector2(MAX_ZOOM, MAX_ZOOM))
			zoom_hold_sub = true
			zoom_hold_timer_sub = 0.0
	elif event is InputEventKey and not event.pressed:
		if event.physical_keycode == KEY_EQUAL or event.physical_keycode == KEY_KP_ADD:
			zoom_hold_add = false
		elif event.physical_keycode == KEY_MINUS or event.physical_keycode == KEY_KP_SUBTRACT:
			zoom_hold_sub = false

func _handle_pushing():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is RigidBody2D:
			var push_direction = collision.get_normal() * -1
			collider.apply_central_impulse(push_direction * PUSH_FORCE)

func get_movedir():
	var LEFT = Input.is_action_pressed("move_left")
	var RIGHT = Input.is_action_pressed("move_right")
	var UP = Input.is_action_pressed("move_up")
	var DOWN = Input.is_action_pressed("move_down")

	var dir_x = -int(LEFT) + int(RIGHT)
	var dir_y = -int(UP) + int(DOWN)

	var test_dir = Vector2.ZERO

	if dir_x != 0:
		var check_pos = terrain.local_to_map(position + Vector2(dir_x, 0) * TILE_SIZE)
		var tile_coords = terrain.get_cell_atlas_coords(0, check_pos)
		if tile_coords != Vector2i(3, 0) and tile_coords != Vector2i(3, 2):
			test_dir.x = dir_x

	if dir_y != 0:
		var check_pos = terrain.local_to_map(position + Vector2(0, dir_y) * TILE_SIZE)
		var tile_coords = terrain.get_cell_atlas_coords(0, check_pos)
		if tile_coords != Vector2i(3, 0) and tile_coords != Vector2i(3, 2):
			test_dir.y = dir_y

	movedir = test_dir.normalized()

	if movedir != Vector2.ZERO:
		ray.target_position = movedir * TILE_SIZE / 2

func get_tile(tile_map):
	if tile_map is TileMap:
		var v = Vector2(TILE_SIZE / 2, TILE_SIZE / 2)
		var tile_pos = tile_map.local_to_map(position + v + ray.target_position)
		var tile_id = tile_map.get_cell_source_id(0, tile_pos)
		if tile_id == -1:
			return "None"
		else:
			return tile_map.tile_set.get_source(tile_id).resource_name
