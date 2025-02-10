extends Control

var target: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().get_nodes_in_group("enemies")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
