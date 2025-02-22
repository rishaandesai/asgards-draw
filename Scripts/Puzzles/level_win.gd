extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		load_next_level()

func load_next_level() -> void:
	var currentScene: StringName = owner.scene_file_path
	var nextArray: PackedStringArray = DirAccess.get_files_at("res://Scenes/Puzzle/Puzzles")
	if nextArray.has(currentScene.get_file()):
		nextArray.remove_at(nextArray.find(currentScene.get_file()))
	get_tree().change_scene_to_file.call_deferred("res://Scenes/Puzzle/Puzzles/"+nextArray[RandomNumberGenerator.new().randi_range(0, nextArray.size()-1)])
