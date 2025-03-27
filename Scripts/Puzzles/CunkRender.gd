extends Node2D

var render_distance: int = 5
var unrender_distance: int = 10
var loaded_chunks: Dictionary[Vector2i, Chunk] = {}
var LandscapeScript: Script = load("res://LandscapeTileMap.gd")

func _ready() -> void:
	$Player.position = Vector2(LandscapeScript.world_size/2, LandscapeScript.world_size/2)

func _process(_delta: float) -> void:
	var player_chunk: Vector2i = Vector2i($Player.position/LandscapeScript.chunk_size)
	
	# Load chunks within render distance
	for x: int in range(player_chunk.x-render_distance, player_chunk.x+render_distance):
		if x < 0 or x > LandscapeScript.world_size/LandscapeScript.chunk_size: 
			continue
		for y: int in range(player_chunk.y-render_distance, player_chunk.y+render_distance):
			if y < 0 or y > LandscapeScript.world_size/LandscapeScript.chunk_size: 
				continue
				
			var chunk_pos = Vector2i(x,y)
			if loaded_chunks.has(chunk_pos):
				continue
				
			# Set all tiles for this chunk (including deep water for empty spaces)
			for local_x in range(LandscapeScript.chunk_size):
				for local_y in range(LandscapeScript.chunk_size):
					var local_pos = Vector2i(local_x, local_y)
					var global_pos = local_pos + (chunk_pos * LandscapeScript.chunk_size)
					
					var tile_type = Tile.TileTypes.deep_water_tile
					
					# Check if we have this chunk and position saved
					if SaveData.saveFile.world.has(chunk_pos):
						var chunk = SaveData.saveFile.world[chunk_pos]
						loaded_chunks[chunk_pos] = chunk
						
						# Use saved tile type if available
						if chunk.tiles.has(local_pos):
							tile_type = chunk.tiles[local_pos].type
					
					# Set the tile on the tilemap
					$"World Layer".set_cells_terrain_connect(0, [global_pos], 0, tile_type)
	
	# Unload chunks outside unrender distance
	var chunks_to_unload = []
	for chunk_pos in loaded_chunks.keys():
		if abs(chunk_pos.x - player_chunk.x) > unrender_distance or \
		   abs(chunk_pos.y - player_chunk.y) > unrender_distance:
			chunks_to_unload.append(chunk_pos)
			
			# Clear all tiles for this chunk
			for local_x in range(LandscapeScript.chunk_size):
				for local_y in range(LandscapeScript.chunk_size):
					var local_pos = Vector2i(local_x, local_y)
					var global_pos = local_pos + (chunk_pos * LandscapeScript.chunk_size)
					$"World Layer".erase_cell(0, global_pos)
	
	# Remove unloaded chunks from loaded_chunks
	for chunk_pos in chunks_to_unload:
		loaded_chunks.erase(chunk_pos)
	
