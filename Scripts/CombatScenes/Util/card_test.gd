extends Control
class_name CanvasCard

var card: Card
@onready var parent_array: NodePath
@onready var origin_position: Vector2 = position
@onready var target_position: Vector2 = position
@onready var target_angle: float = 0
@onready var animationvar: float = 0
var owned_by: Control
static var packed_scene = preload("res://Scenes/CombatScenes/Util/card.tscn")

static func init(icard: Card) -> CanvasCard:
	var c: CanvasCard = packed_scene.instantiate()
	c.card = icard
	return c

func _ready() -> void:
	gui_input.connect(on_mouse_input)
	if card.texture != null:
		$TextureRect.texture = card.texture

func on_mouse_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.pressed:
			# When pressed, store original parent and setup dragging
			animationvar = 0
			pivot_offset = get_local_mouse_position()
			reparent(get_tree().root, true)
		else:
			# When released
			if !$Area2D.get_overlapping_areas().is_empty():
				var container: Control = $Area2D.get_overlapping_areas()[0].get_parent()
				if container.allowedTypes.has(card.type):
					# Update card lists
					get_node(parent_array).Cards = get_node(parent_array).Cards.filter(func(c: CanvasCard): return c != self)
					get_node(parent_array).reorder()
					parent_array = container.get_path()
					container.Cards.append(self)
					container.reorder()
				owned_by = container
			if owned_by:
				reparent(owned_by, true)
				print("exists")
			animationvar = 0
			target_position = origin_position
			target_angle = 0
			
	elif event is InputEventMouseMotion:
		if event.pressure == 1:
			animationvar = .5
			target_position = get_global_mouse_position()-pivot_offset
			target_angle = (position).angle_to(origin_position)

func _process(delta: float) -> void:
	if animationvar < 1:
		animationvar += delta*0.4
	else:
		animationvar = 1
	position = position.lerp(target_position, animationvar)
	rotation = lerp(rotation, target_angle, animationvar)
