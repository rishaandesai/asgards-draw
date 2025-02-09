extends Control
class_name CardNotifier

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Label.text = str(int($Label.text) + 1)
	$Label.pivot_offset = size/2
	$Label.position = $TextureRect.position+$TextureRect.size/2-$Label.size/2
	pass
