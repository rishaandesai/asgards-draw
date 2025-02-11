extends StaticBody2D

@export var door_id: String  # ID to link with triggers

func _ready():
	DoorManager.register_door(self, door_id)

func open_door():
	$CollisionShape2D.set_deferred("disabled", true)  # Make door passable
	modulate = Color(1, 1, 1, 0.1)  # Keep door visible

func close_door():
	$CollisionShape2D.set_deferred("disabled", false)  # Make door solid again
	modulate = Color(1, 1, 1, 1)  # Keep door visible
