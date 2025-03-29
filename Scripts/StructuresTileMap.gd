extends TileMap

var dungeon_noise: FastNoiseLite = FastNoiseLite.new()
var dungeon_tile: Vector2i = Vector2i(0, 3)
var dungeon_layer: int = 0
var global_seed: int = 87885
var world_size: int = 4096
var min_distance: int = 150

func generate_dungeons(land_positions: Array) -> Array[DungeonSave]:
	print("dungeon generation started")
	var start_time = Time.get_ticks_msec()

	dungeon_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	dungeon_noise.seed = global_seed + 4242
	dungeon_noise.frequency = 0.02
	dungeon_noise.fractal_octaves = 3
	dungeon_noise.fractal_gain = 0.4

	var land_set := {}
	for pos in land_positions:
		land_set[pos] = true

	var used := {}
	var chunk_size := 32
	var dungeon_positions := []

	for pos in land_positions:
		var cell_x = int(pos.x / chunk_size) * chunk_size
		var cell_y = int(pos.y / chunk_size) * chunk_size
		var chunk_origin = Vector2i(cell_x, cell_y)
		if chunk_origin in used:
			continue

		var noise_val = dungeon_noise.get_noise_2d(float(cell_x), float(cell_y)) * 0.5 + 0.5
		if noise_val > 0.8:
			var too_close = false
			for existing_pos in dungeon_positions:
				if existing_pos.distance_to(chunk_origin) < min_distance:
					too_close = true
					break
			if too_close:
				continue

			for dx in range(chunk_size):
				for dy in range(chunk_size):
					var tile_pos = chunk_origin + Vector2i(dx, dy)
					if tile_pos in land_set:
						set_cell(dungeon_layer, tile_pos, 0, dungeon_tile)
			used[chunk_origin] = true
			dungeon_positions.append(chunk_origin)

	var result: Array[DungeonSave] = []
	for i in dungeon_positions.size():
		var pos = dungeon_positions[i]
		var dungeon = DungeonSave.new(Vector2i(world_size, world_size), pos, i)
		result.append(dungeon)

	var total_time = (Time.get_ticks_msec() - start_time) / 1000.0
	print("dungeon generation complete. (%.2f seconds total)" % total_time)

	return result
