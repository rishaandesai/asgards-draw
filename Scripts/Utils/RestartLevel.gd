extends Button

func _ready():
	process_mode = PROCESS_MODE_ALWAYS  # Ensures the button works when paused
	if not self.pressed.is_connected(_on_button_pressed):
		self.pressed.connect(_on_button_pressed)

func _on_button_pressed():
	var current_scene = get_tree().current_scene.scene_file_path
	get_tree().paused = false 
	get_tree().reload_current_scene()
	print("Level Restarted")
