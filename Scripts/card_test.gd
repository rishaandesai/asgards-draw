extends Control

var drag_origin_angle: float
var drag_origin_magnitude: float
@onready var parent_array: NodePath
@onready var origin_position: Vector2 = position
@onready var target_position: Vector2 = position
@onready var target_angle: float = 0
@onready var animationvar: float = 0

func _ready() -> void:
	connect("gui_input", on_gui_input)
	$Area2D.connect("area_entered", on_area_entered)

func on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent.get_path().get_name(parent.get_path().get_name_count()-1) == "CardContainer":
		var Cards = parent.get_meta("Cards") as Array
		Cards.append(self)
		print(parent_array)
		if (parent_array != NodePath()):
			get_node(parent_array).set_meta("Cards", get_node(parent_array).get_meta("Cards").filter(func(card: Control): return card != self))
		parent_array = parent.get_path()
		parent.reorder()
		
	pass

func _input(event: InputEvent):
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		if mouse_event.pressed:
			animationvar = 0
			drag_origin_angle = Vector2.ZERO.angle_to(get_local_mouse_position())
			drag_origin_magnitude = Vector2.ZERO.distance_to(get_local_mouse_position())
		else:
			animationvar = 0
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
