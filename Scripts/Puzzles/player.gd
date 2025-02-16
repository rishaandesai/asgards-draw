extends CharacterBody2D

const SPEED = 250.0
const PUSH_FORCE = 10.0  # Adjust for stronger/weaker pushing

@onready var animation_player = $AnimationPlayer
@onready var wasd_prompt = $WASD  # Reference to the WASD prompt

var last_direction = "front"

func _ready() -> void:
	wasd_prompt.visible = true  # Show the WASD prompt at the start

func _physics_process(_delta: float) -> void:
	var direction_x := Input.get_axis("move_left", "move_right")
	var direction_y := Input.get_axis("move_up", "move_down")

	velocity = Vector2(direction_x, direction_y).normalized() * SPEED

	if direction_x:
		last_direction = "left" if direction_x < 0 else "right"
	elif direction_y:
		last_direction = "back" if direction_y < 0 else "front"

	if velocity.length() > 0:
		animation_player.play("run_" + last_direction)
		wasd_prompt.visible = false  # Hide prompt on movement
	else:
		animation_player.play("idle_" + last_direction)

	move_and_slide()
	_handle_pushing()
	
	z_index = int(position.y)

func _handle_pushing():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()

		if collider is RigidBody2D:
			var push_direction = collision.get_normal() * -1  # Get push direction
			collider.apply_central_impulse(push_direction * PUSH_FORCE)
