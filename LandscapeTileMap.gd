extends TileMap

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

@onready var player = get_parent().get_child(1)
var land_positions = []
var water_positions = []

var global_seed = 87885

func _ready():
	print("world generation started")
	var start_time = Time.get_ticks_msec()

	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.seed = global_seed
	noise.frequency = 0.001
	noise.fractal_octaves = log(world_size)/log(2)
	noise.fractal_gain = 0.5

	moisture_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	moisture_noise.seed = global_seed + 9999
	moisture_noise.frequency = 0.0007
	moisture_noise.fractal_octaves = 5
	moisture_noise.fractal_gain = 0.4

	var gradient = load_square_gradient("res://square_gradient.png")
	var raw_noise_map = generate_raw_noise()
	generate_island(raw_noise_map, gradient)


	call_deferred("_place_player_and_dungeons")
	var total_time = (Time.get_ticks_msec() - start_time) / 1000.0
	print("world generation complete. (%.2f seconds total)" % total_time)

func _place_player_and_dungeons():
	place_player_on_land()
	$"../StructuresTilemap".generate_dungeons(land_positions)

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

func generate_raw_noise():
	var raw_noise = []
	raw_noise.resize(world_size)
	for x in range(world_size):
		raw_noise[x] = []
		for y in range(world_size):
			var noise_val = noise.get_noise_2d(float(x), float(y)) * 0.5 + 0.5
			raw_noise[x].append(noise_val)
	return raw_noise

func generate_island(raw_noise, gradient):
	for c in range((world_size/chunk_size)**2):
		var curr_chunk: Array[Tile] = []
		for x in range(chunk_size):
			for y in range(chunk_size):
				var noise_val = raw_noise[x][y]
				var final_val = clamp(noise_val - (gradient[x][y] * 0.8), 0.0, 1.0)
	
				if final_val < 0.2:
					set_cell(terrain_layer, Vector2i(x, y), 0, deep_water_tile)
					water_positions.append(Vector2i(x, y))
					curr_chunk.append(Tile.new(Vector2i(c*chunk_size+x, c*chunk_size+y), Tile.TileTypes.deep_water_tile))
				elif final_val < 0.25:
					set_cell(terrain_layer, Vector2i(x, y), 0, shallow_water_tile)
					curr_chunk.append(Tile.new(Vector2i(c*chunk_size+x, c*chunk_size+y), Tile.TileTypes.deep_water_tile))
				elif final_val > 0.7:
					set_cell(terrain_layer, Vector2i(x, y), 0, snow_tile)
					land_positions.append(Vector2i(x, y))
				else:
					var moisture_val = moisture_noise.get_noise_2d(float(x), float(y)) * 0.5 + 0.5
					if moisture_val > 0.7:
						set_cell(terrain_layer, Vector2i(x, y), 0, wet_grass_tile)
					elif moisture_val < 0.3:
						set_cell(terrain_layer, Vector2i(x, y), 0, dry_grass_tile)
					else:
						set_cell(terrain_layer, Vector2i(x, y), 0, normal_grass_tile)
					land_positions.append(Vector2i(x, y))

func place_player_on_land():
	if land_positions.size() > 0:
		var spawn_position = land_positions.pick_random()
		player.global_position = to_global(map_to_local(spawn_position)) + Vector2(12.5, 12.5)
		print("player spawned at %s (on land)" % spawn_position)
	else:
		print("no valid land positions found. placing player at center of map")
		player.global_position = to_global(map_to_local(Vector2i(world_size / 2, world_size / 2))) + Vector2(12.5, 12.5)
