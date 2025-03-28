extends TileMap

# noise maps
var noise = FastNoiseLite.new()
var moisture_noise = FastNoiseLite.new()

# world parameters
var world_size = 4096
var chunk_size: int = 4096
var terrain_layer = 0

# tile atlas positions
var deep_water_tile = Vector2i(3, 0)
var shallow_water_tile = Vector2i(3, 2)
var wet_grass_tile = Vector2i(1, 1)
var normal_grass_tile = Vector2i(2, 3)
var dry_grass_tile = Vector2i(2, 2)
var snow_tile = Vector2i(0, 0)

# player reference
@onready var player = get_parent().get_node("Player")
@onready var props_tilemap = $"../PropsTilemap"

# track terrain type for other systems
var land_positions = []
var water_positions = []

# consistent seed for generation
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

	var gradient = load_square_gradient("res://Resources/square_gradient.png")
	var raw_noise_map = generate_raw_noise()
	generate_island(raw_noise_map, gradient)
	apply_water_shader()
	call_deferred("_place_player_and_dungeons")
	var total_time = (Time.get_ticks_msec() - start_time) / 1000.0
	print("world generation complete. (%.2f seconds total)" % total_time)

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
	var normal_grass_tiles = [Vector2i(1, 10), Vector2i(2, 10), Vector2i(3, 10)]
	var wet_grass_tiles = [Vector2i(1, 11), Vector2i(2, 11), Vector2i(3, 11)]
	var dry_grass_tiles = [Vector2i(6, 14), Vector2i(7, 14), Vector2i(8, 14)]
	var snow_tiles = [Vector2i(1, 14), Vector2i(2, 14), Vector2i(3, 14)]
	var ice_tiles = [Vector2i(0, 24), Vector2i(0, 25), Vector2i(1, 24), Vector2i(1, 25)]

	var rng = RandomNumberGenerator.new()
	rng.seed = global_seed

	var ice_mask = []
	for x in range(world_size):
		ice_mask.append([])
		for y in range(world_size):
			ice_mask[x].append(false)

	for i in range(world_size / 50):
		var w = rng.randi_range(1, 6)
		var h = rng.randi_range(1, 6)
		var start_x = rng.randi_range(0, world_size - w - 1)
		var start_y = rng.randi_range(0, world_size - h - 1)
		for dx in range(w):
			for dy in range(h):
				ice_mask[start_x + dx][start_y + dy] = true

	for c in range((world_size / chunk_size) ** 2):
		for x in range(chunk_size):
			for y in range(chunk_size):
				var tile_pos = Vector2i(x, y)
				var noise_val = raw_noise[x][y]
				var final_val = smoothstep(0.0, 1.0, clamp(noise_val - (gradient[x][y] * 0.8), 0.0, 1.0))

				if final_val < 0.2:
					water_positions.append(tile_pos)
					continue
				elif final_val > 0.7:
					if ice_mask[x][y]:
						set_cell(terrain_layer, tile_pos, 0, ice_tiles.pick_random())
					else:
						set_cell(terrain_layer, tile_pos, 0, snow_tiles.pick_random())
					land_positions.append(tile_pos)
				else:
					var m = moisture_noise.get_noise_2d(float(x), float(y)) * 0.5 + 0.5
					if m > 0.7:
						set_cell(terrain_layer, tile_pos, 0, wet_grass_tiles.pick_random())
					elif m < 0.3:
						set_cell(terrain_layer, tile_pos, 0, dry_grass_tiles.pick_random())
					else:
						set_cell(terrain_layer, tile_pos, 0, normal_grass_tiles.pick_random())
					land_positions.append(tile_pos)

func smooth_terrain_pass():
	for x in range(1, world_size - 1):
		for y in range(1, world_size - 1):
			if Vector2i(x, y) == Vector2i(int(player.position.x / 16), int(player.position.y / 16)):
				continue
			var center = get_cell_atlas_coords(terrain_layer, Vector2i(x, y))
			var land_count = 0
			for dx in range(-1, 2):
				for dy in range(-1, 2):
					if dx == 0 and dy == 0:
						continue
					var neighbor = get_cell_atlas_coords(terrain_layer, Vector2i(x + dx, y + dy))
					if neighbor != deep_water_tile and neighbor != shallow_water_tile:
						land_count += 1
			if land_count >= 5 and (center == deep_water_tile or center == shallow_water_tile):
				set_cell(terrain_layer, Vector2i(x, y), 0, normal_grass_tile)
			elif land_count <= 3 and (center != deep_water_tile and center != shallow_water_tile):
				set_cell(terrain_layer, Vector2i(x, y), 0, deep_water_tile)

func _place_player_and_dungeons():
	await get_tree().process_frame
	place_player_on_land()
	smooth_terrain_pass()
	land_positions.clear()
	for x in range(world_size):
		for y in range(world_size):
			var cell = get_cell_atlas_coords(terrain_layer, Vector2i(x, y))
			if cell != deep_water_tile and cell != shallow_water_tile:
				land_positions.append(Vector2i(x, y))
	$"../StructuresTilemap".generate_dungeons(land_positions)
	generate_big_trees()

func place_player_on_land():
	if land_positions.size() > 0:
		var center_tile = Vector2i(world_size / 2, world_size / 2)
		var candidate_positions = []
		for pos in land_positions:
			if pos.x >= center_tile.x - 300 and pos.x <= center_tile.x + 300 and pos.y >= center_tile.y - 300 and pos.y <= center_tile.y + 300:
				candidate_positions.append(pos)
		if candidate_positions.size() > 0:
			var spawn_position = candidate_positions.pick_random()
			var tile_size = Vector2(16, 16)
			player.position = Vector2(spawn_position) * tile_size + tile_size / 2
			print("player spawned on land at %s" % spawn_position)
		else:
			var fallback = center_tile
			var tile_size = Vector2(16, 16)
			player.position = Vector2(fallback) * tile_size + tile_size / 2
			print("no valid land positions found in center region. placing player at fallback: %s" % fallback)
	else:
		var fallback = Vector2i(world_size / 2, world_size / 2)
		player.position = Vector2(fallback) * Vector2(16, 16) + Vector2(8, 8)
		print("no valid land positions found. placing player at fallback: %s" % fallback)

func apply_water_shader():
	var shader := preload("res://Resources/Shaders/WaterShader.gdshader")
	var mat := ShaderMaterial.new()
	mat.shader = shader
	mat.set_shader_parameter("deep_water_tile", deep_water_tile)
	mat.set_shader_parameter("shallow_water_tile", shallow_water_tile)
	mat.set_shader_parameter("tile_size", Vector2(16, 16))
	mat.set_shader_parameter("atlas_texture_size", Vector2(256, 256))
	mat.set_shader_parameter("toneColor", Color(0.8, 0.9, 1.0, 1.0))
	mat.set_shader_parameter("topColor", Color(1.0, 1.0, 1.0, 1.0))
	self.material = mat

func generate_big_trees():
	var rng = RandomNumberGenerator.new()
	rng.seed = global_seed + 5678
	var occupied = {}

	for tile_pos in land_positions:
		if rng.randf() > 0.04:
			continue
		if tile_pos in occupied:
			continue

		var atlas_tile = get_cell_atlas_coords(terrain_layer, tile_pos)
		var land_type = "normal"
		if atlas_tile in [Vector2i(1, 14), Vector2i(2, 14), Vector2i(3, 14)]:
			land_type = "cold"
		elif atlas_tile in [Vector2i(1, 11), Vector2i(2, 11), Vector2i(3, 11)]:
			land_type = "wet"
		elif atlas_tile in [Vector2i(6, 14), Vector2i(7, 14), Vector2i(8, 14)]:
			land_type = "dry"

		var pattern_indices = []

		# normal trees
		if land_type == "normal":
			pattern_indices = [0, 1, 2, 3]
			if rng.randf() < 0.05:
				pattern_indices += [12, 13, 14, 15, 16, 17, 18]

		# cold trees
		elif land_type == "cold":
			pattern_indices = [4, 5, 6, 7, 22, 23, 24, 25]

		# wet trees
		elif land_type == "wet":
			pattern_indices = [8, 9, 10, 11]

		# dry trees
		elif land_type == "dry":
			pattern_indices = [19, 20, 21]

		var pattern_id = pattern_indices.pick_random()
		var pattern = props_tilemap.tile_set.get_pattern(pattern_id)
		if not pattern:
			continue

		var offsets = pattern.get_used_cells()
		var overlap = false
		for offset in offsets:
			var abs_pos = tile_pos + offset
			if abs_pos in occupied:
				overlap = true
				break

		if overlap:
			continue

		for offset in offsets:
			occupied[tile_pos + offset] = true

		props_tilemap.set_pattern(0, tile_pos, pattern)
