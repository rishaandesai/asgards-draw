extends Node

var save_scene: PackedScene
var enemies: Array[EnemyType]
var saveFile: SaveFile

func _ready() -> void:
	for i in range(0, 6):
		for b: Card in (load("res://Resources/all_cards.tscn") as PackedScene).instantiate().AllCards:
			var c: Card = b.duplicate(true)
			c.affect = b.affect
			saveFile.deck.append(c)
