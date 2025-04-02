extends Node2D
class_name CanvasCard

var card: Card
var drag_origin_angle: float
var drag_origin_magnitude: float
@onready var parent_array: NodePath
static var packed_scene = preload("res://Scenes/CombatScenes/Util/card.tscn")



static func init(icard: Card) -> CanvasCard:
	var c: CanvasCard = packed_scene.instantiate()
	c.card = icard
	if c.card.texture != null:
		print_debug(c.get_children(false))
		c.get_child(1).texture = c.card.texture	
	return c

func _ready() -> void:
	$Area2D.input_event.connect(on_mouse_input)

func on_mouse_input(node: Object, event: InputEvent, shape_idx: int):
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		if mouse_event.pressed:
			drag_origin_angle = Vector2.ZERO.angle_to(get_local_mouse_position())
			drag_origin_magnitude = Vector2.ZERO.distance_to(get_local_mouse_position())
		else:
			if !$Area2D.get_overlapping_areas().is_empty():
				var container: Control = $Area2D.get_overlapping_areas()[0].get_parent()
				if container.allowedTypes.has(card.type):
					get_node(parent_array).Cards = get_node(parent_array).Cards.filter(func(c: CanvasCard): return c != self)
					get_node(parent_array).reorder()
					parent_array = container.get_path()
					print(parent_array)
					container.Cards.append(self)
					container.reorder()
			drag_origin_angle = 0
			drag_origin_magnitude = 0
	elif event is InputEventMouseMotion:
		event = event as InputEventMouseMotion
		if event.pressure == 1:
			position = get_global_mouse_position()-Vector2(drag_origin_magnitude*cos(drag_origin_angle+rotation), drag_origin_magnitude*sin(drag_origin_angle+rotation))
