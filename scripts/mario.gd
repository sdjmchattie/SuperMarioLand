extends CharacterBody2D

@export var camera: Camera2D

const SPEED = 60.0
const JUMP_VELOCITY = -250.0

@onready var sprite: Sprite2D = $SmallSprite

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		sprite.flip_h = direction < 0
		velocity.x = direction * SPEED
	else:
		velocity.x = 0

	var new_x = position.x + velocity.x * delta
	if not camera.update_mario_pos(new_x):
		velocity.x = 0

	move_and_slide()
