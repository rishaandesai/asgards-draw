extends PanelContainer

func _ready() -> void:
	position.x = 0
	get_parent().queue_sort()
	$AnimationPlayer.play("Popup Animation")
	await $AnimationPlayer.animation_finished
	await get_tree().create_timer(1).timeout
	$AnimationPlayer.play_backwards("Popup Animation")
	await $AnimationPlayer.animation_finished
	get_parent().remove_child(self)
	#TODO Fix notifier UI overlap when mulitiple notifiers exist at the same time
