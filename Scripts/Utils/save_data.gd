extends Node

var save_scene: PackedScene
var enemies: Array[EnemyType]
var saveFile: SaveFile

func _ready() -> void:
	saveFile = SaveFile.new(true)
