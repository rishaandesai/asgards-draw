extends Node2D

@export var encounter: Array[EnemyType] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D.body_entered.connect(on_body_enter)
	pass # Replace with function body.

func on_body_enter(body: Node2D):
	if (body.get_path().get_concatenated_names() as String).split("/").has("PuzzleCharacter"):
		call_deferred("trigger_combat")
		

func trigger_combat():
	var scene = PackedScene.new()
	scene.pack(get_parent())
	SaveData.save_scene = scene
	SaveData.enemies = encounter.duplicate(true)
	get_tree().change_scene_to_file("res://Scenes/combat_scene.tscn")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
