extends Control

@export var deck: Array[Card] = []
@export var used: Array[Card] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	deck.append(Card.new("res://Asgard's Draw.png", Card.CardType.DAMAGE, func(): print("boop")))
	connect("gui_input", on_input)
	pass # Replace with function body.

func on_input(event: InputEvent):
	if event is InputEventMouseButton:
		event = event as InputEventMouseButton
		print(event)
		if event.button_index == 1 && event.pressed == true:
			var c = CanvasCard.init(draw_card())
			get_parent().add_child(c)
			var container = get_node("../Hand")
			c.parent_array = container.get_path()
			c.position = position
			container.Cards.append(c)
			container.reorder()
			c.z_index = z_index+1

func draw_card() -> Card:
	return deck.filter(func(c: Card): return !used.has(c)).pick_random()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
