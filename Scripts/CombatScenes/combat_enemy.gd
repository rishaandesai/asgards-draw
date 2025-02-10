extends CombatEntity
class_name CombatEnemy

@export var deck: Array[Card] = []
@export var used: Array[Card] = []
@export var jokers: Array[Joker] = []
@export var hand_size: int = 5
@export var sprite: Texture = PlaceholderTexture2D.new()
@onready var hand: Array[Card] = []
static var packed_scene = preload("res://Scenes/CombatScenes/combat_enemy.tscn")



static func init(i: EnemyType) -> CombatEnemy:
	var c: CombatEnemy = packed_scene.instantiate()
	c.sprite = i.sprite
	c.health = i.health
	c.max_health = i.health
	c.shield = i.shield
	return c

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
	print(get_path())
	$"../PlayHand".play_hand($"../CombatPlayer", self, hand, jokers)
	hand = []
	for i in range(0, hand_size):
		draw_card()
	pass

func on_death() -> void:
	remove_from_group("enemies")
	super.on_death()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
