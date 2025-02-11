extends Node2D

var objects_in_area = []  # Tracks objects inside the trigger

func _ready():
	$Trigger.area_entered.connect(_on_trigger_entered)
	$Trigger.area_exited.connect(_on_trigger_exited)

func _on_trigger_entered(area):
	if area.get_parent() not in objects_in_area:
		objects_in_area.append(area.get_parent())
	$Door.open_door()

func _on_trigger_exited(area):
	objects_in_area.erase(area.get_parent())
	if objects_in_area.is_empty():
		$Door.close_door()
