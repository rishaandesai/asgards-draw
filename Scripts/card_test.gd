extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("ready")
	connect('mouse_entered', on_mouse_enter)
	connect('mouse_exited', on_mouse_exit)
	pass # Replace with function body.

func on_mouse_enter() -> void:
	position.y -= 20
	pass

func on_mouse_exit() -> void:
	position.y += 20
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
