extends Control

func _ready() -> void:
	var dir = DirAccess.open("user://Saves")
	print(DirAccess.get_open_error())
	if not dir:
		DirAccess.make_dir_absolute("user://Saves")
	dir = DirAccess.open("user://Saves")
	for str: StringName in dir.get_files():
		var file = ResourceLoader.load("user://Saves/"+str)
		var SaveDisplayScene = preload("res://Scenes/MainMenu/Util/Save.tscn")
		var display = SaveDisplayScene.instantiate()
		display.save = file
		$"./MarginContainer/VBoxContainer".add_child(display)


func _on_panel_container_gui_input(event: InputEvent) -> void:
	if event is not InputEventMouseButton: return
	event = event as InputEventMouseButton
	
	if event.is_pressed():
		var file: SaveFile = SaveFile.new()
		SaveData.saveFile = file
		get_tree().change_scene_to_file("res://Scenes/Puzzle/Dungeons/Introduction.tscn")
