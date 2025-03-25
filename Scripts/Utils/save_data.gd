extends Node

var save_scene: PackedScene
var enemies: Array[EnemyType]
var playerStats = {
	health = 100,
	maxHealth = 100,
	shield = 0
}
var deck: Array[Card] = []
var jokers: Array[Card] = []
var completed_dungeons: Array[int] = []
var dungeons: Array[DungeonSave] = []
var saveFile: SaveFile

func _ready() -> void:
	for i in range(0, 6):
		for b: Card in (load("res://Resources/all_cards.tscn") as PackedScene).instantiate().AllCards:
			var c: Card = b.duplicate(true)
			c.affect = b.affect
			deck.append(c)
