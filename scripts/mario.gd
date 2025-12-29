extends CharacterBody2D

enum MarioState {
	ON_GROUND,
	JUMP_ASCENT,
	JUMP_APEX,
	JUMP_DESCENT,
	LEDGE_DESCENT,
	PIPE_ENTRY,
	DEAD,
}

@export var camera: Camera2D
@export var terminal_jump_speed := 120.0
@export var terminal_ledge_fall_speed := 250.0
@export var apex_gravity := 700.0
@export var max_jump_time := 0.18
@export var horizontal_speed = 60.0

@onready var sprite: Sprite2D = $SmallSprite

var mario_state: MarioState = MarioState.ON_GROUND
var jump_timer = 0.0

func _physics_process(delta: float) -> void:
	match mario_state:
		MarioState.ON_GROUND:
			_physics_on_ground(delta)
		MarioState.JUMP_ASCENT:
			_physics_jump_ascent(delta)
		MarioState.JUMP_APEX:
			_physics_jump_apex(delta)
		MarioState.JUMP_DESCENT:
			_physics_jump_descent(delta)
		MarioState.LEDGE_DESCENT:
			_physics_ledge_descent(delta)
		MarioState.PIPE_ENTRY:
			pass
		MarioState.DEAD:
			pass

func _horizontal_movement(delta: float) -> void:
		# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		sprite.flip_h = direction < 0
		velocity.x = direction * horizontal_speed
	else:
		velocity.x = 0.0

	var distance_x = velocity.x * delta
	var half_width = (
		float(sprite.texture.get_width()) /
		sprite.hframes *
		sprite.scale.x *
		0.5
	)
	var new_left = position.x + distance_x - half_width
	var new_right = position.x + distance_x + half_width
	if not camera.update_mario_pos(new_left, new_right):
		velocity.x = 0.0

func _check_grounded() -> void:
	if is_on_floor():
		velocity.y = 0.0
		mario_state = MarioState.ON_GROUND

func _physics_on_ground(delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		velocity.y = -1 * terminal_jump_speed
		jump_timer = 0.0
		mario_state = MarioState.JUMP_ASCENT
	elif not is_on_floor():
		velocity.y = terminal_ledge_fall_speed
		mario_state = MarioState.LEDGE_DESCENT

	_horizontal_movement(delta)
	move_and_slide()

func _physics_jump_ascent(delta: float) -> void:
	jump_timer += delta
	if not Input.is_action_pressed("jump") or jump_timer >= max_jump_time:
		mario_state = MarioState.JUMP_APEX

	_horizontal_movement(delta)
	move_and_slide()

func _physics_jump_apex(delta: float) -> void:
	velocity.y += apex_gravity * delta
	if velocity.y >= terminal_jump_speed:
		velocity.y = terminal_jump_speed
		mario_state = MarioState.JUMP_DESCENT

	_check_grounded()
	_horizontal_movement(delta)
	move_and_slide()

func _physics_jump_descent(delta: float) -> void:
	_check_grounded()
	_horizontal_movement(delta)
	move_and_slide()

func _physics_ledge_descent(delta: float) -> void:
	_check_grounded()
	_horizontal_movement(delta)
	move_and_slide()
