extends Node2D
class_name CombatEntity


@export var health: int = 0
@export var max_health: int = 0
@export var shield: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func on_death() -> void:
	get_parent().remove_child(self)

func damage(i: int) -> void:
	shield -= i
	if shield < 0:
		health += shield
		shield = 0
		if health <= 0:
			on_death()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
