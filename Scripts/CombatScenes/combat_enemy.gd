extends CombatEntity
class_name CombatEnemy

@export var deck: Array[Card] = []
@export var used: Array[Card] = []
@export var jokers: Array[Joker] = []
@export var hand_size: int = 5
@onready var hand: Array[Card] = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(0, 6):
		for b: Card in (load("res://Resources/all_cards.tscn") as PackedScene).instantiate().AllCards:
			var c: Card = b.duplicate(true)
			c.affect = b.affect
			deck.append(c)
	for i in range(0, hand_size):
		draw_card()
	pass # Replace with function body.

func draw_card() -> Card:
	if deck.filter(func(c: Card): return !used.has(c)).is_empty(): used = hand
	var card = deck.filter(func(c: Card): return !used.has(c)).pick_random()
	used.append(card)
	hand.append(card)
	return card

func take_turn() -> void:
	$"../PlayHand".play_hand($"../CombatPlayer", self, hand, jokers)
	hand = []
	for i in range(0, hand_size):
		draw_card()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
