extends Control
class_name CardContainer

var Cards: Array[CanvasCard] = []
@export var allowedTypes: Array[Card.CardType]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func reorder() -> void:
	Cards.sort_custom(func(Card1: Control, Card2: Control): return Card1.position.x+Card1.size.x*Card1.scale.x/2 < Card2.position.x+Card2.size.x*Card2.scale.x/2)
	for card: CanvasCard in Cards: 
		card.z_index = Cards.find(card)
		card.animationvar = 0
		card.origin_position = position + Vector2((Cards.find(card)*size.x*scale.x)/(Cards.size()), size.y*scale.y/2-card.size.y*card.scale.y/2+(10 if Cards.find(card) % 2 == 0 else 0))
		card.target_position = card.origin_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
