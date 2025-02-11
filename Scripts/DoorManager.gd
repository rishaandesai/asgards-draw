extends Node

# Dictionary tracking active triggers per door ID
var active_triggers = {}

# Dictionary tracking doors per door ID
var doors_by_id = {}

func register_door(door, id):
	if id in doors_by_id:
		doors_by_id[id].append(door)
	else:
		doors_by_id[id] = [door]

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
		for door in doors_by_id[id]:
			if should_open:
				door.open_door()
			else:
				door.close_door()
