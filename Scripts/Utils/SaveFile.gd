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
@export var world: StringName ## Folder Position of the WorldFile
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

var raw_noise
var gradient

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
		global_seed = RandomNumberGenerator.new().randi()
		gradient = load_square_gradient("res://Resources/square_gradient.png")
		raw_noise = generate_raw_noise()
		var struct_map = load("res://Scripts/StructuresTileMap.gd").new()

func place_player_on_land() -> Vector2:
	if land_positions.size() > 0:
		var spawn_position = land_positions.pick_random()
		return spawn_position + Vector2(12.5, 12.5)
		print("player spawned at %s (on land)" % spawn_position)
	else:
		print("no valid land positions found. placing player at center of map")
		return Vector2(world_size / 2, world_size / 2) + Vector2(12.5, 12.5)

func generate_raw_noise():
	var raw_noise = []
	raw_noise.resize(world_size)
	for x in range(world_size):
		raw_noise[x] = []
		for y in range(world_size):
			var noise_val = noise.get_noise_2d(float(x), float(y)) * 0.5 + 0.5
			raw_noise[x].append(noise_val)
	return raw_noise
func get_tile(global_x: int, global_y: int) -> int:
	var noise_val = raw_noise[global_x][global_y]
	var final_val = clamp(noise_val - (gradient[global_x][global_y] * 0.8), 0.0, 1.0)
	var global_pos = Vector2i(global_x, global_y)
		
	# Determine tile type based on noise value
	if final_val < 0.2:
		return Tile.TileTypes.deep_water_tile
	elif final_val < 0.25:
		return Tile.TileTypes.shallow_water_tile
	elif final_val > 0.7:
		return Tile.TileTypes.snow_tile
	else:
		var moisture_val = 0.5
		if moisture_val > 0.7:
			return Tile.TileTypes.wet_grass_tile
		elif moisture_val < 0.3:
			return Tile.TileTypes.dry_grass_tile
		else:
			return Tile.TileTypes.normal_grass_tile

func is_dungeon_on_tile(tile: Vector2i):
	pass

func generate_island(raw_noise, gradient) -> Dictionary[Vector2i, Chunk]:
	var chunks: Dictionary[Vector2i, Chunk]
	for chunk_x in range(world_size/chunk_size):
		for chunk_y in range(world_size/chunk_size):
			var curr_chunk: Array[Tile] = []
			var chunk_pos = Vector2i(chunk_x, chunk_y)
			
			for local_x in range(chunk_size):
				for local_y in range(chunk_size):
					var global_x = chunk_x * chunk_size + local_x
					var global_y = chunk_y * chunk_size + local_y
					
					# Get noise value for this position
					var noise_val = raw_noise[global_x][global_y]
					var final_val = clamp(noise_val - (gradient[global_x][global_y] * 0.8), 0.0, 1.0)
					var local_pos = Vector2i(local_x, local_y)
					var global_pos = Vector2i(global_x, global_y)
		
					# Determine tile type based on noise value
					if final_val < 0.2:
						water_positions.append(global_pos)
						curr_chunk.append(Tile.new(local_pos, Tile.TileTypes.deep_water_tile))
					elif final_val < 0.25:
						water_positions.append(global_pos)
						curr_chunk.append(Tile.new(local_pos, Tile.TileTypes.shallow_water_tile))
					elif final_val > 0.7:
						land_positions.append(global_pos)
						curr_chunk.append(Tile.new(local_pos, Tile.TileTypes.snow_tile))
					else:
						var moisture_val = 0.5
						if moisture_val > 0.7:
							curr_chunk.append(Tile.new(local_pos, Tile.TileTypes.wet_grass_tile))
						elif moisture_val < 0.3:
							curr_chunk.append(Tile.new(local_pos, Tile.TileTypes.dry_grass_tile))
						else:
							curr_chunk.append(Tile.new(local_pos, Tile.TileTypes.normal_grass_tile))
						land_positions.append(global_pos)
			
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
