extends Node

@export var Styles: Array[Theme]

enum eStyles {
	POSITIVE,
	NEGATIVE
}



func notify(type: eStyles, notifyTexture: Texture2D = load("res://Resources/Textures/Enemy_Placeholder.JPG")) -> void:
	var notifierScene: PanelContainer = preload("res://Scenes/HUD UI/pickup_notifier.tscn").instantiate()
	notifierScene.theme = Styles[type] # TEMP
	notifierScene.get_node("MarginContainer/HBoxContainer/TextureRect").texture = notifyTexture
	$PickupNotifierContainer.add_child(notifierScene)
