extends Control

@export var deck: Array[Card] = []
@export var used: Array[Card] = []
@onready var hand: Array[Card] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(0, 6):
		for b: Card in (load("res://Resources/all_cards.tscn") as PackedScene).instantiate().AllCards:
			var c: Card = b.duplicate(true)
			c.affect = b.affect
			deck.append(c)
	
	gui_input.connect(on_input)
	pass # Replace with function body.

func on_input(event: InputEvent):
	if event is InputEventMouseButton:
		event = event as InputEventMouseButton
		if event.button_index == 1 && event.pressed == true && !deck.filter(func(c: Card): return !used.has(c)).is_empty():
			var c = CanvasCard.init(draw_card())
			get_parent().add_child(c)
			var container = get_node("../Hand")
			c.parent_array = container.get_path()
			print(c.parent_array)
			c.position = position
			container.Cards.append(c)
			container.reorder()
			c.z_index = z_index+1

func draw_card() -> Card:
	if deck.filter(func(c: Card): return !used.has(c)).is_empty(): used == hand
	var card = deck.filter(func(c: Card): return !used.has(c)).pick_random()
	used.append(card)
	return card

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
