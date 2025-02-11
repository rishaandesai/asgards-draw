extends Area2D

@export var trigger_id: String  # ID to link with doors

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	DoorManager.register_trigger(trigger_id)  # Notify DoorManager when object steps on it

func _on_body_exited(body):
	DoorManager.unregister_trigger(trigger_id)  # Notify when object leaves
