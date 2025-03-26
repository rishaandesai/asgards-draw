class_name Card extends Resource

enum CardType {
	DAMAGE,
	HEALER,
	MULT,
	JOKER
}

enum PlayCardType {
	MELEE,
	RANGED,
	SUMMON
}

static var affect_dict: Dictionary = {
	damage = 0,
	shield = 0,
	heal = 0,
	max_heal = 0,
	mult = 0,
}

@export var texture: Texture
@export var type: CardType
@export var played_card_type: PlayCardType
@export var level: int
@export var affect: Dictionary = {
	damage = 0,
	shield = 0,
	heal = 0,
	max_heal = 0,
	mult = 0,
}
