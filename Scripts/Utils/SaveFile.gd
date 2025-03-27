extends Resource
class_name SaveFile

## Filename (without the file extension)
var name: StringName
## Player Stats
## {
##	health = 0,
##	maxHealth = 0,
##	shield = 0
## }
var stats: Dictionary = {
	## Health
	health = 0,
	## Max Health
	maxHealth = 0,
	## Shield
	shield = 0
}
## All playing cards within the player's deck
var deck: Array[Card] = []
## All Jokers within the player's deck
var jokers: Array[Card] = []
## List of completed dungeon's UIDs
var completed_dungeons: Array[int] = []
## All dungeons within the world
var dungeons: Array[DungeonSave] = []
## World Data
var world: Dictionary[Vector2i, Chunk] = {}

# Contructor, will create a new save file.
func _init() -> void:
	var save_dir: DirAccess = DirAccess.open("user://Saves/")
	name = StringName("Save_"+str(save_dir.get_files().size()))
	resource_name = name
	if save_dir.get_files().has(name):
		push_error("Save File Already Exists. Uh... What?")
		return
	stats = {
		health = 100,
		maxHealth = 100,
		shield = 100
	}
	deck = []
	jokers = []
	dungeons = load('res://Scripts/Utils/populate_POIs.gd').generate_POI_positions()
	world = load('res://Scripts/World/LandscapeTileMap.gd').generate_island()
	save()

func save() -> void:
	ResourceSaver.save(self, "user://Saves/"+name+".tres")
	
