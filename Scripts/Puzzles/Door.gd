extends StaticBody2D

@export var door_id: String  # ID to link with triggers

func _ready():
	DoorManager.register_door(self, door_id)

func _exit_tree():
	# Clean up collision shape
	if has_node("CollisionShape2D"):
		$CollisionShape2D.queue_free()

func open_door():
	$CollisionShape2D.set_deferred("disabled", true)
	visible = false
	  # Make door passable
	modulate = Color(1, 1, 1, 0.1)  # Keep door visible

func close_door():
	$CollisionShape2D.set_deferred("disabled", false)  # Make door solid again
	visible = true
	modulate = Color(1, 1, 1, 1)  # Keep door visible
