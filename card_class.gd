class_name Card extends Resource

enum CardType {
	DAMAGE,
	HEALER,
	MULT,
	UTILITY,
	JOKER
}

enum PlayCardType {
	MELEE,
	RANGED,
	SUMMON
}

static var affect_dict: Dictionary = {
	damage_base = 0,
	shield_base = 0,
	heal_base = 0,
	max_heal_base = 0,
	mult_base = 0,
	mult_multiplier = 0
}

@export var texture: Texture
@export var type: CardType
@export var played_card_type: PlayCardType
@export var level: int
@export var affect: Dictionary = {
	damage_base = 0,
	shield_base = 0,
	heal_base = 0,
	max_heal_base = 0,
	mult_base = 0,
	mult_multiplier = 0
}
