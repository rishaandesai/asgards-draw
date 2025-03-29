extends Resource
class_name SaveFile

var name: StringName
var stats: Dictionary = {
	health = 0,
	maxHealth = 0,
	shield = 0
}
var deck: Array[Card] = []
var jokers: Array[Card] = []
var completed_dungeons: Array[int] = []
var dungeons: Array[DungeonSave] = []
var world: Dictionary[Vector2i, Chunk] = {}
var worldgen_node: Node = null

func _init() -> void:
	var save_dir: DirAccess = DirAccess.open("user://Saves/")
	name = StringName("Save_" + str(save_dir.get_files().size()))
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
	worldgen_node = load("res://Scripts/LandscapeTileMap.gd").new()
	worldgen_node.name = "LandscapeTilemap"
	var gradient = worldgen_node.load_square_gradient("res://Resources/square_gradient.png")
	var raw_noise = worldgen_node.generate_raw_noise()
	world = worldgen_node.generate_island(raw_noise, gradient)
	var struct_map = load("res://Scripts/StructuresTileMap.gd").new()
	dungeons = struct_map.generate_dungeons(worldgen_node.land_positions)
	save()

func save() -> void:
	ResourceSaver.save(self, "user://Saves/" + name + ".tres")
