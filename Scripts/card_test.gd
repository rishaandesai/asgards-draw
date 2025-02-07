extends Control

var drag_origin_angle: float
var drag_origin_magnitude: float
@onready var origin_position: Vector2 = position
@onready var target_position: Vector2 = position
@onready var target_angle: float = 0
@onready var animationvar: float = 0

func _ready() -> void:
	set_process_input(true)  # Ensures the node processes input

func _input(event: InputEvent):
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		if mouse_event.pressed:
			animationvar = 0
			drag_origin_angle = Vector2.ZERO.angle_to(get_local_mouse_position())
			drag_origin_magnitude = Vector2.ZERO.distance_to(get_local_mouse_position())
		else:
			target_position = origin_position
			target_angle = 0
	elif event is InputEventMouseMotion:
		animationvar = 0.5
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			target_position = get_local_mouse_position() - Vector2(
				drag_origin_magnitude * cos(drag_origin_angle + rotation),
				drag_origin_magnitude * sin(drag_origin_angle + rotation)
			)
			target_angle = (target_position - position).angle()

func _process(delta: float) -> void:
	animationvar = clamp(animationvar + delta * 0.4, 0.0, 1.0)
	position = position.lerp(target_position, animationvar)
	rotation = lerp(rotation, target_angle, animationvar)
