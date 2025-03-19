extends Node

var save_scene: PackedScene
var enemies: Array[EnemyType]
var playerStats: Dictionary = {
	health = 100,
	maxHealth = 100,
	shield = 0,
}
@export var deck: Array[Card] = []
@export var jokers: Array[Joker] = []

func _ready() -> void:
	_save()
	for i in range(0, 6):
		for b: Card in (load("res://Resources/all_cards.tscn") as PackedScene).instantiate().AllCards:
			var c: Card = b.duplicate(true)
			c.affect = b.affect
			deck.append(c)

func _save() -> void:
	var save_file = FileAccess.open("user://Saves/"+SaveData.save_name, FileAccess.WRITE)
	var json = JSON.new()
	for v in (get_script() as Script).get_script_property_list():
		save_file.store_line(json.stringify(v))
		
