extends PanelContainer
class_name SaveDisplay

var save: SaveFile

func _init(file: SaveFile):
	$"MarginContainer/HBoxContainer/VBoxContainer/Label".text = file.name
	$"MarginContainer/HBoxContainer/VBoxContainer/Label2".text = Time.get_datetime_string_from_unix_time(FileAccess.get_modified_time("user://Saves/"+file.name+".tres"))
	$"MarginContainer/HBoxContainer/MarginContainer/PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer2/Health".text = file.stats.health
	$"MarginContainer/HBoxContainer/MarginContainer/PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/Deck_Size".text = file.deck.size()
	$"MarginContainer/HBoxContainer/MarginContainer/PanelContainer/MarginContainer/HBoxContainer/VBoxContainer2/HBoxContainer2/Dungeon_Percent".text = str(file.completed_dungeons.size()*100.0/file.dungeons.size())+"%"
	$"MarginContainer/HBoxContainer/MarginContainer/PanelContainer/MarginContainer/HBoxContainer/VBoxContainer2/HBoxContainer/Dungeon_Number".text = file.dungeon.size()
	pass

func _load() -> void:
	#TODO CUS FUCK ME
	
	pass
