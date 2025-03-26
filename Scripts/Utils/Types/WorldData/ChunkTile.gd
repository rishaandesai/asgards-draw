## World Tile Class for already chunked worlds.
extends Tile
class_name ChunkTile

## Position in the chunk
var position: Vector2i

func _init(global_position: Vector2i, type: TileTypes, position: Vector2i):
	self.position = position
	super(global_position, type)
