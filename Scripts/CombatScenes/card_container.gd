extends Control
class_name CardContainer

var Cards: Array[CanvasCard] = []
@export var allowedTypes: Array[Card.CardType]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func reorder() -> void:
	$HBoxContainer.queue_sort()
	for card: CanvasCard in Cards: 
		card.z_index = Cards.find(card)
		card.animationvar = 0
		card.origin_position.x = position.x + (Cards.find(card)*size.x*scale.x)/(Cards.size())
		card.origin_position.y=0
		card.target_position = card.origin_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
