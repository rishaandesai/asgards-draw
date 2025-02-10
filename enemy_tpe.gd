extends Resource
class_name EnemyType

@export var health: int = 0
@export var max_health: int = 0
@export var shield: int = 0
@export var deck: Array[Card] = []
@export var used: Array[Card] = []
@export var jokers: Array[Joker] = []
@export var hand_size: int = 5
@export var sprite: Texture = PlaceholderTexture2D.new()
