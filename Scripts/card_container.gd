extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func reorder() -> void:
	get_meta("Cards").sort_custom(func(Card1: Control, Card2: Control): return Card1.position.x < Card2.position.x)
	for card: Control in get_meta("Cards"): 
		card.z_index = get_meta("Cards").bsearch(card)
		card.origin_position = position + Vector2(size.x*scale.x/(get_meta("Cards").size()+1), size.y*scale.y-card.size.y*card.scale.y/2)
		print(size.y*scale.y)
		print(size.y*scale.y-card.size.y*card.scale.y/2)
		print(card.size.y*card.scale.y/2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
