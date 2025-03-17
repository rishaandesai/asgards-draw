extends Control

var b: PackedScene = preload("res://Scenes/CombatScenes/combat_enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("ready")
	configure_jokers()
	pass # Replace with function body.

func configure_jokers() -> void:
	var jokers: Array[Joker] = SaveData.jokers
	for j: Joker in jokers:
		var c: CanvasCard = (load("res://Scenes/CombatScenes/Util/card.tscn") as PackedScene).instantiate()
		c.parent_array = $Jokers.get_path()
		$Jokers.Cards.append(c)
	$Jokers.reorder()
