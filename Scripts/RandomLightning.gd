extends ColorRect

@onready var timer = $Timer

func _ready():
	visible = false
	timer.start()

func _on_Timer_timeout():
	visible = true
	await get_tree().create_timer(0.1).timeout
	visible = false
