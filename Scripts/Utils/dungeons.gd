@tool
extends Resource
class_name Dungeon

## Dungeon Resource for Dungeon Creation
## Add a new Dungeon under res://Resources/Dungeons/
## The Program is recursive so put it in as many folders as you want.

enum DungeonTypes { ## Dungeon Type enum.
	TREASURE, ## Treasure Dungeons, only contain loot.
	PUZZLE, ## Puzzle Dungeons, Contain a puzzle to be solved, may contain enemies.
	RAID, ## Very heavy combat dungeon
	BOSS ## Boss Dungeon, Usually has a seperate room for the boss room, usually following a dungeon that could be classified as a raid dungeon
}

## ID is assigned in generation
@export var name: StringName
## The type of the dungeon.
@export var type: DungeonTypes
## Dungeon Rarity
@export var rarity: Rarity.Rarity
## Difficulty will be calculated based off of type and rarity.
## Difficulty influences enemy health scaling, enemy cards, and loot.
## It is displayed as "stars". It is an int, however it will be divided by 10
## to produce difficulties such as 2.3, which would have difficulty = 23. This
## is for readability.
@export var difficulty: float:
	get: return difficulty/10.0
	set(val): difficulty = 5*(rarity+3)*type
## The scene to load from
@export var scene: PackedScene

func _init(NAME: StringName = "") -> void:
	name = NAME
