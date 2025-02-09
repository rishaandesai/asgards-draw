extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AreaObject.body_entered.connect(body_entered) # Replace with function body.

func body_entered(body: Node2D) -> void:
	if body.get_parent().get_path().get_name(body.get_parent().get_path().get_name_count()-1) == "PuzzlePushBlock":
		get_node(get_meta("door")).find_child("CollisionShape2D", true).set_deferred('disabled', true)
		get_node(get_meta("door")).set_deferred('visible', false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
