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

var noise = FastNoiseLite.new()
var moisture_noise = FastNoiseLite.new()

var world_size = 4096
var chunk_size: int = 16
var terrain_layer = 0

var deep_water_tile = Vector2i(3, 0)
var shallow_water_tile = Vector2i(3, 2)
var wet_grass_tile = Vector2i(1, 1)
var normal_grass_tile = Vector2i(2, 3)
var dry_grass_tile = Vector2i(2, 2)
var snow_tile = Vector2i(0, 0)

var land_positions = []
var water_positions = []

var global_seed = 87885

func _init(new_file: bool = false) -> void:
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
	if new_file:
		worldgen_node = load("res://Scripts/LandscapeTileMap.gd").new()
		worldgen_node.name = "LandscapeTilemap"
		var gradient = worldgen_node.load_square_gradient("res://Resources/square_gradient.png")
		var raw_noise = worldgen_node.generate_raw_noise()
		world = worldgen_node.generate_island(raw_noise, gradient)
		var struct_map = load("res://Scripts/StructuresTileMap.gd").new()
		dungeons = struct_map.generate_dungeons(worldgen_node.land_positions)
		save()


func generate_raw_noise():
	var raw_noise = []
	raw_noise.resize(world_size)
	for x in range(world_size):
		raw_noise[x] = []
		for y in range(world_size):
			var noise_val = noise.get_noise_2d(float(x), float(y)) * 0.5 + 0.5
			raw_noise[x].append(noise_val)
	return raw_noise

func generate_island(raw_noise, gradient) -> Dictionary[Vector2i, Chunk]:
	var chunks: Dictionary
	for c in range((world_size/chunk_size)**2):
		var curr_chunk: Array[Tile] = []
		var chunk_pos: Vector2i = Vector2i(c % (world_size/chunk_size), c/(world_size/chunk_size))
		for x in range(chunk_size):
			for y in range(chunk_size):
				var noise_val = raw_noise[x][y]
				var final_val = clamp(noise_val - (gradient[x][y] * 0.8), 0.0, 1.0)
				var pos: Vector2i = Vector2i()
	
				if final_val < 0.2:
					water_positions.append(Vector2i(x, y))
					curr_chunk.append(Tile.new(Vector2i(c*chunk_size+x, c*chunk_size+y), Tile.TileTypes.deep_water_tile))
				elif final_val < 0.25:
					water_positions.append(Vector2i(x, y))
					curr_chunk.append(Tile.new(Vector2i(c*chunk_size+x, c*chunk_size+y), Tile.TileTypes.shallow_water_tile))
				elif final_val > 0.7:
					land_positions.append(Vector2i(x, y))
					curr_chunk.append(Tile.new(Vector2i(c*chunk_size+x, c*chunk_size+y), Tile.TileTypes.snow_tile))
				else:
					var moisture_val = 0.5 #moisture_noise.get_noise_2d(float(x), float(y)) * 0.5 + 0.5
					if moisture_val > 0.7:
						curr_chunk.append(Tile.new(Vector2i(c*chunk_size+x, c*chunk_size+y), Tile.TileTypes.wet_grass_tile))
					elif moisture_val < 0.3:
						curr_chunk.append(Tile.new(Vector2i(c*chunk_size+x, c*chunk_size+y), Tile.TileTypes.dry_grass_tile))
					else:
						curr_chunk.append(Tile.new(Vector2i(c*chunk_size+x, c*chunk_size+y), Tile.TileTypes.normal_grass_tile))
					land_positions.append(Vector2i(x, y))
		chunks[chunk_pos] = Chunk.new(chunk_pos, curr_chunk)
	return chunks

func load_square_gradient(path):
	var img: Image = Image.new()
	if img.load(path) == OK:
		print("loaded %s" % path)
		var gradient = []
		gradient.resize(world_size)
		var img_size = img.get_size()
		var img_width = img_size.x
		var img_height = img_size.y

		for x in range(world_size):
			gradient[x] = []
			for y in range(world_size):
				var scaled_x = int(float(x) / world_size * img_width)
				var scaled_y = int(float(y) / world_size * img_height)
				scaled_x = clamp(scaled_x, 0, img_width - 1)
				scaled_y = clamp(scaled_y, 0, img_height - 1)
				var color = img.get_pixel(scaled_x, scaled_y)
				gradient[x].append(color.r)

		return gradient
	else:
		printerr("square gradient not loaded from %s" % path)
		return null

func save() -> void:
	ResourceSaver.save(self, "user://Saves/" + name + ".tres")
