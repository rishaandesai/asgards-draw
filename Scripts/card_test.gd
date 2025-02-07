extends Control

@onready var original_position: Vector2 = position - Vector2(0, 20)
@onready var drag_origin: Vector2 = Vector2(0, 0)
@onready var animationvar: float = 0
@onready var target_angle: float = 0
@onready var target_position: Vector2 = original_position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("ready")
	connect('mouse_entered', on_mouse_enter)
	connect('mouse_exited', on_mouse_exit)
	connect('gui_input', on_mouse_click)

func on_mouse_enter() -> void:
	position.y -= 20

func on_mouse_exit() -> void:
	position.y += 20

func on_mouse_click(event: InputEvent) -> void:
	if event.is_class("InputEventMouseButton"):
		event = event as InputEventMouseButton
		if event.pressed:
			animationvar = 0
			drag_origin = get_local_mouse_position()
		else:
			animationvar = 0
			drag_origin = Vector2(0,0)
			target_angle = 0
			target_position = original_position
		print(event)
	elif event.is_class("InputEventMouseMotion"):
		event = event as InputEventMouseMotion
		if event.pressure == 1.00:
			target_position = get_global_mouse_position()
			target_angle = (position-drag_origin).angle_to(get_global_mouse_position())
			print(target_angle)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if animationvar < 1:
		if target_position != original_position:
			animationvar += delta*0.2
		else:
			animationvar += delta*0.6
		position = position.lerp(target_position-drag_origin, animationvar)
	rotation = lerp(rotation, target_angle, animationvar)
	pass
