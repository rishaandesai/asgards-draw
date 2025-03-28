extends CharacterBody2D
class_name Player

const SPEED = 150.0
const PUSH_FORCE = 10.0
const ZOOM_FACTOR = 5.0
const MIN_ZOOM = 0.1
const MAX_ZOOM = 5.0
const TILE_SIZE = 16

@onready var camera = $Camera2D
@onready var animation_player = $AnimationPlayer
@onready var ray = $RayCast2D

var terrain
var last_direction = "front"

var last_position = Vector2.ZERO
var target_position = Vector2.ZERO
var movedir = Vector2.ZERO

func _ready() -> void:
	terrain = $"../LandscapeTilemap"
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

	if Input.is_physical_key_pressed(KEY_EQUAL) or Input.is_physical_key_pressed(KEY_KP_ADD):
		camera.zoom *= ZOOM_FACTOR
		camera.zoom = camera.zoom.clamp(Vector2(MIN_ZOOM, MIN_ZOOM), Vector2(MAX_ZOOM, MAX_ZOOM))

	if Input.is_physical_key_pressed(KEY_MINUS) or Input.is_physical_key_pressed(KEY_KP_SUBTRACT):
		camera.zoom /= ZOOM_FACTOR
		camera.zoom = camera.zoom.clamp(Vector2(MIN_ZOOM, MIN_ZOOM), Vector2(MAX_ZOOM, MAX_ZOOM))
		await get_tree().create_timer(0.25).timeout

	_handle_pushing()
	z_index = clamp(int(position.y), 0, 4096)

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

	movedir.x = -int(LEFT) + int(RIGHT)
	movedir.y = -int(UP) + int(DOWN)

	if movedir != Vector2.ZERO and terrain != null:
		var target_tile_pos = terrain.local_to_map(position + movedir * TILE_SIZE)
		var tile_id = terrain.get_cell_source_id(0, target_tile_pos)
		var tile_name = "None"
		if tile_id != -1:
			tile_name = terrain.tile_set.get_source(tile_id).resource_name
		if !tile_name.begins_with("Walkable"):
			movedir = Vector2.ZERO
		else:
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
