extends Dungeon
class_name DungeonSave

## Dungeon File which is saved to save files
## I wouldn't recommend you edit these yourself but I mean...
## Who am I to stop you.

## Position is assigned in generation
@export var position: Vector2i
## ID of the dungeon save
@export var uid: int

func _init(worldSize: Vector2i, pos: Vector2i, id: int) -> void:
	position = pos
	var diff_rating: float = (pos.distance_to(worldSize/2)/(worldSize.length()**2))*(sqrt(2)/24) ## this can go up to 12 difficulty... somehow
	var folder_name: String = "10+" if int(diff_rating) >= 10 else type_string(int(diff_rating))
	var folder: DirAccess = DirAccess.open("res://Resources/Dungeons/"+folder_name)
	var dungeon_resc: Dungeon = load(folder.get_files()[range(0, folder.get_files().size()).pick_random()])
	rarity = dungeon_resc.rarity
	type = dungeon_resc.type
	scene = dungeon_resc.scene
	uid = id
	super(dungeon_resc.name)

static func weights(d_r: float) -> PackedFloat32Array:
	var temp: Array = Rarity.Rarity.values()
	var c: Array[float] = []
	for i: float in temp:
		c.append(bell_curve(i, d_r))
	c.reverse()
	return PackedFloat32Array(c)

static func bell_curve(x: float, mean: float, std_dev: float=0.2) -> float:
	return (1.0/(std_dev*sqrt(2.0*PI)))*exp(1.0)**(-(1.0/10.0)*((x-mean)/std_dev)**2.0)
