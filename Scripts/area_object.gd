extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", body_entered) # Replace with function body.

func body_entered(body: Node2D) -> void:
	if body.get_parent().get_path() == $"../".get_node($"../".get_meta("PushBlock")).get_path():
		$"../".get_node($"../".get_meta("door")).find_child("CollisionShape2D", true).set_deferred('disabled', true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
