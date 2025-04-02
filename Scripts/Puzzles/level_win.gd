extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		dep_load_next_level()

func load_overworld() -> void:
	get_tree().change_scene_to_file.call_deferred("res://Scenes/World.tscn")
	pass

func dep_load_next_level() -> void:
	var currentScene: StringName = owner.scene_file_path
	var nextArray: PackedStringArray = DirAccess.get_files_at("res://Scenes/Puzzle/Dungeons")
	if nextArray.has(currentScene.get_file()):
		nextArray.remove_at(nextArray.find(currentScene.get_file()))
	get_tree().change_scene_to_file.call_deferred("res://Scenes/Puzzle/Dungeons/"+nextArray[RandomNumberGenerator.new().randi_range(0, nextArray.size()-1)])
