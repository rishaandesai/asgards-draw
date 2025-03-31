## World Tile Class for already chunked worlds.
extends Tile
class_name ChunkTile

## Position in the chunk
var position: Vector2i

func _init(global_position: Vector2i = Vector2i(-1,-1), type: TileTypes = 0, position: Vector2i = Vector2i(-1,-1)):
	self.position = position
	super(global_position, type)
