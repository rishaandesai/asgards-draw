extends Control

@export var deck: Array = SaveData.saveFile.deck
@export var used: Array[Card] = []
@onready var hand: Array[Card] = []

# Called when the node enters the scene tree for the first time.
func draw_card() -> Card:
	if deck.filter(func(c: Card): return !used.has(c)).is_empty():
		used = hand
	var card = deck.filter(func(c: Card): return !used.has(c)).pick_random()
	used.append(card)
	hand.append(card)
	return card

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
