extends CharacterBody2D

@export var camera: Camera2D

const SPEED = 60.0
const JUMP_VELOCITY = -250.0
const HALF_WIDTH = 80.0
const LEFT_MARGIN = 4.0

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
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Stop at left margin
	if global_position.x + velocity.x * delta <= camera.global_position.x + LEFT_MARGIN:
		velocity.x = 0

	move_and_slide()

	if global_position.x > camera.global_position.x + HALF_WIDTH:
		camera.global_position.x = global_position.x - HALF_WIDTH
