extends RigidBody2D

@export var friction: float = 5  # Adjust friction strength

func _ready():
	linear_damp = friction  # Apply friction

func _process(_delta):
	update_z_index()

func update_z_index(): #deth sorting so that boxes on top appear below things on bottom
	z_index = int(global_position.y)  # Higher Y values appear on top
