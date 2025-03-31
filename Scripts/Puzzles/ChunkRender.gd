extends Node2D

var render_distance: int = 5
var unrender_distance: int = 10
var loaded_chunks: Dictionary[Vector2i, Chunk] = {}

var tiles: Array[Vector2i] = [Vector2i(3, 0), #Deep Water
							Vector2i(3, 2), # Shallow Water
							Vector2i(1, 1), #Wet Grass
							Vector2i(2, 3), #dry grass
							Vector2i(2, 2),#normal grass
							Vector2i(0, 0)] #snow

func _ready() -> void:
	$Player.position = Vector2(SaveData.saveFile.world_size, SaveData.saveFile.world_size)/2

func _process(_delta: float) -> void:
	var player_chunk: Vector2i = Vector2i($Player.position/SaveData.saveFile.chunk_size)
	# Load chunks within render distance
	for x: int in range(player_chunk.x-render_distance, player_chunk.x+render_distance):
		if x < 0 or x > SaveData.saveFile.world_size/SaveData.saveFile.chunk_size: 
			continue
		for y: int in range(player_chunk.y-render_distance, player_chunk.y+render_distance):
			if y < 0 or y > SaveData.saveFile.world_size/SaveData.saveFile.chunk_size: 
				continue
				
			var chunk_pos = Vector2i(x,y)
			if loaded_chunks.has(chunk_pos):
				continue
				
			# Set all tiles for this chunk (including deep water for empty spaces)
			for local_x in range(SaveData.saveFile.chunk_size):
				for local_y in range(SaveData.saveFile.chunk_size):
					var local_pos = Vector2i(local_x, local_y)
					var global_pos = local_pos*16 + (chunk_pos * SaveData.saveFile.chunk_size)
					
					var tile_type = Tile.TileTypes.deep_water_tile
					
					# Check if we have this chunk and position saved
					if ($LandscapeTilemap as TileMapLayer).get_cell_tile_data(global_pos) == null:
						tile_type = SaveData.saveFile.get_tile(global_pos.x, global_pos.y)
					
					# Set the tile on the tilemap
					$LandscapeTilemap.set_cell($LandscapeTilemap.local_to_map(global_pos), 0, tiles[tile_type])
	
	# Unload chunks outside unrender distance
	var chunks_to_unload = []
	for chunk_pos in loaded_chunks.keys():
		if abs(chunk_pos.x - player_chunk.x) > unrender_distance or \
		   abs(chunk_pos.y - player_chunk.y) > unrender_distance:
			chunks_to_unload.append(chunk_pos)
			
			# Clear all tiles for this chunk
			#for local_x in range(SaveData.saveFile.chunk_size):
			#	for local_y in range(SaveData.saveFile.chunk_size):
			#		var local_pos = Vector2i(local_x, local_y)
			#		var global_pos = local_pos + (chunk_pos * SaveData.saveFile.chunk_size)
			#		$LandscapeTilemap.erase_cell(0, global_pos)
	
	# Remove unloaded chunks from loaded_chunks
	for chunk_pos in chunks_to_unload:
		loaded_chunks.erase(chunk_pos)
	
