extends Card
class_name Joker

@export var conditions: GDScript

enum affected {
	ALL,
	HEALER,
	DAMAGE,
	MULT
}
