extends Node2D

var target: Node2D

func _ready():
	target = get_node("../Player")

func _process(_delta):
	if target:
		global_position = target.global_position
