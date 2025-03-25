extends Control

func _ready() -> void:
	var dir: DirAccess = DirAccess.open("user://Saves/")
	print_debug(dir.get_current_dir())
	for str: StringName in dir.get_files():
		var file = ResourceLoader.load("user://Saves/"+str)
		$"./MarginContainer/VBoxContainer".add_child(SaveDisplay.new(file))


func _on_panel_container_gui_input(event: InputEvent) -> void:
	if event is not InputEventMouseButton: return
	event = event as InputEventMouseButton
	
	if event.is_pressed():
		var file: SaveFile = SaveFile.new()
		SaveData.saveFile = file
		SaveData.dungeons = file.dungeons
		SaveData.playerStats = file.stats
		get_tree().change_scene_to_file("res://Scenes/PUzzle/Dungeons/Introduction.tscn")
