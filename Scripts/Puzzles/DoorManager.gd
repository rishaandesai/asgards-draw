extends Node

# Dictionary tracking active triggers per door ID
var active_triggers = {}

# Dictionary tracking doors per door ID
var doors_by_id = {}

func register_door(door, id):
	if !is_instance_valid(door):
		return
		
	if id in doors_by_id:
		doors_by_id[id].append(door)
	else:
		doors_by_id[id] = [door]
	# Add signal to detect when door is freed
	if !door.tree_exiting.is_connected(_on_door_freed):
		door.tree_exiting.connect(_on_door_freed.bind(door, id))

func _on_door_freed(door, id):
	if id in doors_by_id:
		doors_by_id[id].erase(door)
		# Remove the array if it's empty
		if doors_by_id[id].is_empty():
			doors_by_id.erase(id)

func register_trigger(id):
	if id in active_triggers:
		active_triggers[id] += 1
	else:
		active_triggers[id] = 1
	update_doors(id)

func unregister_trigger(id):
	if id in active_triggers:
		active_triggers[id] -= 1
		if active_triggers[id] <= 0:
			active_triggers.erase(id)
	update_doors(id)

func update_doors(id):
	var should_open = active_triggers.get(id, 0) > 0
	if id in doors_by_id:
		# Create a copy of the array to safely iterate and remove invalid doors
		var doors = doors_by_id[id].duplicate()
		var valid_doors = []
		
		for door in doors:
			if is_instance_valid(door) and is_instance_valid(door.get_parent()):
				if should_open:
					door.open_door()
				else:
					door.close_door()
				valid_doors.append(door)
		
		# Update the doors list with only valid doors
		if valid_doors.is_empty():
			doors_by_id.erase(id)
		else:
			doors_by_id[id] = valid_doors
