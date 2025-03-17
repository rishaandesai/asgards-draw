extends Control
class_name CardNotifier

static func notify(text: String, color: String, parent: Node2D) -> void:
	var instance = preload("res://Scenes/CombatScenes/Util/score_notifier.tscn").instantiate()
	parent.add_child(instance)
	instance.get_node("Label").text = text
	instance.get_node("TextureRect").modulate = Color(color)
	instance.position = Vector2.ZERO
	instance.z_index = parent.z_index + 1
	instance.get_node("Label").position.x = -instance.get_node("Label").size.x/2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label.scale = Vector2.ZERO
	var TexRectTween: Tween = create_tween()
	var LabelTween: Tween = create_tween()
	LabelTween.set_parallel()
	TexRectTween.set_parallel()
	LabelTween.set_ease(Tween.EASE_OUT)
	TexRectTween.set_ease(Tween.EASE_OUT)
	TexRectTween.tween_property($TextureRect, "rotation_degrees", 60, .15)
	TexRectTween.tween_property($TextureRect, "scale", Vector2(2, 2), .05)
	TexRectTween.chain().tween_property($TextureRect, "scale", Vector2(1, 1), .1)
	LabelTween.tween_property($Label, "rotation_degrees", -45, .05)
	LabelTween.tween_property($Label, "scale", Vector2(2,2), .05)
	LabelTween.chain().tween_property($Label, "rotation_degrees", 0, .1)
	LabelTween.tween_property($Label, "scale", Vector2(1.5,1.5), .1)
	await LabelTween.finished
	await TexRectTween.finished
	await get_tree().create_timer(.5).timeout
	queue_free()
