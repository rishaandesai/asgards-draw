extends Node

var save_scene: PackedScene
var enemies: Array[EnemyType]
@export var serialize: Dictionary = {
	playerStats = {
		health = 100,
		maxHealth = 100,
		shield = 0
	},
	deck = [],
	jokers = []
}
func _ready() -> void:
	(load('res://Scripts/Utils/populate_POIs.gd') as Script).generate_POI_positions()
	for i in range(0, 6):
		for b: Card in (load("res://Resources/all_cards.tscn") as PackedScene).instantiate().AllCards:
			var c: Card = b.duplicate(true)
			c.affect = b.affect
			serialize.deck.append(c)

func _as_resource() -> Resource:
	var temp: Resource = Resource.new()
	for key: StringName in serialize.keys():
		temp[key] = serialize[key]
	return temp

func _get(property: StringName) -> Variant:
	return serialize.get(property)

func _save() -> void:
	ResourceSaver.save(self._as_resource(), "user://Saves/"+SaveData.save_name)
