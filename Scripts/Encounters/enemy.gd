extends CharacterBody2D

@export var encounter: Array[EnemyType] = []
@export var path: Path2D
@export var SPEED: int = 250
var progress: float = 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func on_body_enter(body: Node2D):
	if (body.get_path().get_concatenated_names() as String).split("d/").has("Player"):
		call_deferred("trigger_combat")
		

func trigger_combat():
	var parent = get_parent()
	var scene = PackedScene.new()
	SaveData.enemies = encounter.duplicate(true)
	parent.remove_child(self)
	scene.pack(parent)
	SaveData.save_scene = scene
	for id in DoorManager.doors_by_id:
		DoorManager.unregister_trigger(id)
	parent.get_tree().change_scene_to_file("res://Scenes/combat_scene.tscn")
# Called every frame. 'delta' is the elapsed time since the previous frame.



func _physics_process(delta: float) -> void:
	if path != null:
		progress += SPEED*delta
		progress = fmod(progress, 2*path.curve.get_baked_length())
		path.get_node("PathFollow2D").progress = progress
		$NavigationAgent2D.target_position = path.get_node("PathFollow2D").global_position
		velocity = SPEED*position.direction_to($NavigationAgent2D.get_next_path_position())
		move_and_slide()
