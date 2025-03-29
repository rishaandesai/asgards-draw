extends PanelContainer
class_name SaveDisplay

@export var save: SaveFile

func _ready():
	if has_node("ClickCatcher"):
		$ClickCatcher.pressed.connect(_on_click)
	else:
		push_error("ClickCatcher not found.")
	
	$"MarginContainer/HBoxContainer/VBoxContainer/Label".text = str(save.name)
	$"MarginContainer/HBoxContainer/VBoxContainer/Label2".text = Time.get_datetime_string_from_unix_time(FileAccess.get_modified_time("user://Saves/" + str(save.name) + ".tres"))
	$"MarginContainer/HBoxContainer/MarginContainer/PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer2/Health".text = str(save.stats.health)
	$"MarginContainer/HBoxContainer/MarginContainer/PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/Deck_Size".text = str(save.deck.size())
	$"MarginContainer/HBoxContainer/MarginContainer/PanelContainer/MarginContainer/HBoxContainer/VBoxContainer2/HBoxContainer2/Dungeon_Percent".text = str(save.completed_dungeons.size() * 100.0 / max(1, save.dungeons.size())) + "%"
	$"MarginContainer/HBoxContainer/MarginContainer/PanelContainer/MarginContainer/HBoxContainer/VBoxContainer2/HBoxContainer/Dungeon_Number".text = str(save.dungeons.size())

func _on_click():
	print("Loading save:", save.name)
	SaveData.saveFile = save
	get_tree().change_scene_to_file("res://Scenes/World/world.tscn")
