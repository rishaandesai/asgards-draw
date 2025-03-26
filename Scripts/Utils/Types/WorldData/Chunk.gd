extends Resource
class_name Chunk

var tiles: Dictionary[Vector2i, ChunkTile] # Array[Array[chunkTile]]
var position: Vector2i

func _init(pos: Vector2i, newTiles: Array[Tile]):
	var important_tiles: Array[Tile] = newTiles.filter(func(tile: Tile): return tile.type == Tile.TileTypes.deep_water_tile)
	if important_tiles.is_empty(): return # Filter out deep_water tiles, in an effort to reduce world file size by not saving each individual deep water tile
	for tile: Tile in important_tiles:
		tiles[tile.global_position-position] = ChunkTile.new(tile.global_position, tile.type, tile.global_position-position)

func get_tile(pos: Vector2i) -> ChunkTile:
	return tiles.get(pos)
