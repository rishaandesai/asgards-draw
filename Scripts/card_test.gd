extends Control

var drag_origin_angle: float
var drag_origin_magnitude: float
@onready var origin_position: Vector2 = position
@onready var target_position: Vector2 = position
@onready var target_angle: float = 0
@onready var animationvar: float = 0

func _ready() -> void:
	connect("gui_input", on_gui_input)

func on_gui_input(event: InputEvent):
	if event.is_class("InputEventMouseButton"):
		event = event as InputEventMouseButton
		if event.pressed:
			animationvar = 0
			drag_origin_angle = Vector2().angle_to_point(get_local_mouse_position())
			drag_origin_magnitude = Vector2().distance_to(get_local_mouse_position())
		else:
			target_position = origin_position
			target_angle = 0
	elif event.is_class("InputEventMouseMotion"):
		animationvar = 0.5
		event = event as InputEventMouseMotion
		if event.pressure == 1:
			target_position = get_global_mouse_position()-Vector2(drag_origin_magnitude*cos(drag_origin_angle+rotation), drag_origin_magnitude*sin(drag_origin_angle+rotation))
			target_angle = (target_position).angle_to(position)

func _process(delta: float) -> void:
	if animationvar < 1:
		animationvar += delta*0.4
		print(animationvar)
	else:
		animationvar = 1
	position = position.lerp(target_position, animationvar)
	rotation = lerp(rotation, target_angle, animationvar)
