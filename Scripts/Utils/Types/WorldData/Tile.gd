## Tile Class for non-chunked worlds
class_name Tile extends Resource
enum TileTypes {
	deep_water_tile,
	shallow_water_tile,
	snow_tile,
	wet_grass_tile,
	dry_grass_tile,
	normal_grass_tile
}
## Global position in the world
var global_position: Vector2i
## Type of the tile, uses TileTypes enum
var type: TileTypes

func _init(position: Vector2i, type: TileTypes):
	global_position = position
	self.type = type
