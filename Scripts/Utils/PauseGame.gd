extends Button

func _ready():
	process_mode = PROCESS_MODE_ALWAYS  # Ensure processing works when paused
	
	if not self.pressed.is_connected(_on_button_pressed):
		self.pressed.connect(_on_button_pressed)

	update_icons()

func _on_button_pressed():
	get_tree().paused = not get_tree().paused
	update_icons()

func update_icons():
	if get_tree().paused:
		$PauseIcon.visible = false
		$ResumeIcon.visible = true
		print("Paused")
	else:
		$PauseIcon.visible = true
		$ResumeIcon.visible = false
		print("Resumed")
