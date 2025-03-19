@tool
extends Resource
class_name Dungeon

enum DungeonTypes {
	TREASURE,
	PUZZLE,
	RAID,
	BOSS
}

@export_category("Identification")
# ID is assigned in generation
var ID: int
@export var type: DungeonTypes
@export var rarity: Rarity.Rarity
# Difficulty will be calculated based off of type and rarity.
# Difficulty influences enemy health scaling, enemy cards, and loot.
# It is displayed as "stars". It is an int, however it will be divided by 10
# to produce difficulties such as 2.3, which would have difficulty = 23. This
# is for readability.
@export var difficulty: float:
	get: return difficulty/10.0
	set(val): difficulty = 5*(rarity+2)*type
@export_category("Data")
@export var scene: PackedScene
