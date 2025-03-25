extends CharacterBody2D

const SPEED = 4000
const ZOOM_FACTOR = 5.0
const MIN_ZOOM = 0.01
const MAX_ZOOM = 5.0

@onready var camera = $Camera2D

func _physics_process(delta):
	velocity.x = Input.get_axis("ui_left", "ui_right")
	velocity.y = Input.get_axis("ui_up", "ui_down")
	velocity = velocity.normalized() * SPEED
	move_and_slide()

	if Input.is_physical_key_pressed(KEY_EQUAL) or Input.is_physical_key_pressed(KEY_KP_ADD):
		camera.zoom *= ZOOM_FACTOR
		camera.zoom = camera.zoom.clamp(Vector2(MIN_ZOOM, MIN_ZOOM), Vector2(MAX_ZOOM, MAX_ZOOM))

	if Input.is_physical_key_pressed(KEY_MINUS) or Input.is_physical_key_pressed(KEY_KP_SUBTRACT):
		camera.zoom /= ZOOM_FACTOR
		camera.zoom = camera.zoom.clamp(Vector2(MIN_ZOOM, MIN_ZOOM), Vector2(MAX_ZOOM, MAX_ZOOM))
