extends Control

func _on_play_pressed() -> void:
	SaveData.saveFile.global_seed = RandomNumberGenerator.new().randi()
	get_tree().change_scene_to_file("res://Scenes/Puzzle/Dungeons/Introduction.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
