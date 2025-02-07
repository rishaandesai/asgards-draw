extends CharacterBody2D


const SPEED = 300.0


func _physics_process(_delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var hDirection := Input.get_axis("ui_left", "ui_right");
	var vDirection := Input.get_axis("ui_up", "ui_down");
	if hDirection or vDirection:
		velocity.x = hDirection * SPEED
		velocity.y = vDirection * SPEED
		velocity = velocity.normalized() * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
