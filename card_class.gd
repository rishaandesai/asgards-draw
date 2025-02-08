class_name Card extends Resource

enum CardType {
	DAMAGE,
	SHIELD,
	MULT,
	UTILITY,
	JOKER
}

@export var texture: StringName
@export var type: CardType
@export var level: int
@export var affect: Callable

func _init(itexture: StringName, itype: CardType, iaffect: Callable, ilevel: int = 0) -> void:
	self.texture = itexture
	self.type = itype
	self.affect = iaffect
	self.level = ilevel
