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

const PointsScene := preload("res://scenes/points.tscn")
const VIEWPORT_HEIGHT := 144
const MARIO_EDGE_OFFSET_Y := 8

@export var camera: Camera2D
@export var terminal_jump_speed := 108.0
@export var terminal_ledge_fall_speed := 175.0
@export var apex_gravity := 550.0
@export var death_gravity := 200.0
@export var max_jump_time := 0.2
@export var horizontal_speed := 60.0
@export var run_multiplier := 1.5

@onready var sprites: Array[Sprite2D] = [$SmallSprite, $LargeSprite]
@onready var block_ray: RayCast2D = $SmallBlockRay
@onready var movement_animator: AnimationPlayer = $MovementAnimation
@onready var powerup_animator: AnimationPlayer = $PowerupAnimation
@onready var invincibility_animator: AnimationPlayer = $InvincibilityAnimation

var mario_state: MarioState = MarioState.ON_GROUND
var half_width: float
var jump_timer = 0.0
var jumped_while_running := false
var jump_direction := 0.0
var momentum_cancelled := false

func grab_mushroom() -> void:
	GameState.powerup = GameState.Powerup.MUSHROOM
	GameState.score += 1000
	_show_points(1000)

	block_ray = $LargeBlockRay
	powerup_animator.play("Grow To Large")

func grab_flower() -> void:
	GameState.powerup = GameState.Powerup.FLOWER
	GameState.score += 1000
	_show_points(1000)

func grab_extra_life() -> void:
	GameState.lives += 1
	_show_points()

func grab_star() -> void:
	GameState.score += 1000
	_show_points(1000)
	GameState.invincible = true
	invincibility_animator.play("Flash")
	get_tree().create_timer(15.0).timeout.connect(_end_invincibility)

func _end_invincibility() -> void:
	invincibility_animator.play("RESET")
	GameState.invincible = false

func _ready() -> void:
	half_width = (
		float(sprites[0].texture.get_width()) /
		sprites[0].hframes *
		sprites[0].scale.x *
		0.5
	)

func _physics_process(delta: float) -> void:
	if mario_state != MarioState.DEAD and position.y >= camera.position.y + VIEWPORT_HEIGHT + MARIO_EDGE_OFFSET_Y:
		mario_state = MarioState.DEAD
		_begin_level_reload()
		return

	match mario_state:
		MarioState.ON_GROUND:
			_physics_on_ground(delta)
		MarioState.JUMP_ASCENT:
			_physics_jump_ascent(delta)
		MarioState.JUMP_APEX:
			_physics_jump_apex(delta)
		MarioState.JUMP_DESCENT:
			_physics_descent(delta)
		MarioState.LEDGE_DESCENT:
			_physics_descent(delta)
		MarioState.PIPE_ENTRY:
			pass
		MarioState.DEAD:
			_physics_dead(delta)

func _show_points(points: int = 0) -> void:
	var point_scene = PointsScene.instantiate()
	point_scene.set_value(points)
	point_scene.position.x = position.x - half_width + 8.0
	point_scene.position.y = position.y - 11.0
	add_sibling(point_scene)

func _horizontal_movement(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")

	# Detect opposite direction released while airborne — cancels momentum drift
	if mario_state != MarioState.ON_GROUND and jump_direction != 0:
		if Input.is_action_just_released("move_left") and jump_direction > 0:
			momentum_cancelled = true
		elif Input.is_action_just_released("move_right") and jump_direction < 0:
			momentum_cancelled = true

	if direction:
		for sprite in sprites:
			sprite.flip_h = direction < 0
		if jumped_while_running and sign(direction) != jump_direction:
			jumped_while_running = false
		var speed := horizontal_speed
		if mario_state == MarioState.ON_GROUND:
			if Input.is_action_pressed("run_fire"):
				speed = horizontal_speed * run_multiplier
		elif jumped_while_running and Input.is_action_pressed("run_fire"):
			speed = horizontal_speed * run_multiplier
		velocity.x = direction * speed
	elif mario_state != MarioState.ON_GROUND and jump_direction != 0 and not momentum_cancelled:
		# Drift at half speed in the direction Mario was moving when he jumped
		velocity.x = jump_direction * horizontal_speed * 0.5
	else:
		velocity.x = 0.0

	var distance_x = velocity.x * delta
	var new_left = position.x + distance_x - half_width
	var new_right = position.x + distance_x + half_width
	if not camera.update_mario_pos(new_left, new_right):
		velocity.x = 0.0

func _check_block_bumps() -> void:
	if velocity.y > 0:
		return

	if block_ray.is_colliding():
		block_ray.get_collider().on_bumped()
		_transition_jump_descent()

func _check_grounded() -> void:
	if is_on_floor():
		velocity.y = 0.0
		mario_state = MarioState.ON_GROUND

func _transition_jump_ascent() -> void:
	var direction := Input.get_axis("move_left", "move_right")
	jumped_while_running = Input.is_action_pressed("run_fire") and direction != 0
	jump_direction = sign(direction)
	momentum_cancelled = false
	mario_state = MarioState.JUMP_ASCENT
	movement_animator.play("jump")
	velocity.y = -1 * terminal_jump_speed
	jump_timer = 0.0

func _transition_ledge_descent() -> void:
	mario_state = MarioState.LEDGE_DESCENT
	movement_animator.pause()
	velocity.y = terminal_ledge_fall_speed

func _transition_jump_descent() -> void:
	mario_state = MarioState.JUMP_DESCENT
	velocity.y = terminal_jump_speed

func _transition_dead() -> void:
	mario_state = MarioState.DEAD
	collision_layer = 0
	collision_mask = 0
	z_index = 100
	powerup_animator.play("RESET")
	invincibility_animator.play("RESET")
	movement_animator.play("dead")
	velocity.x = 0.0
	velocity.y = -terminal_jump_speed

func _physics_on_ground(delta: float) -> void:
	_horizontal_movement(delta)
	move_and_slide()

	if not Input.get_axis("move_left", "move_right"):
		movement_animator.play("idle")
	else:
		movement_animator.play("walk")

	if Input.is_action_just_pressed("jump"):
		_transition_jump_ascent()
	elif not is_on_floor():
		_transition_ledge_descent()


func _physics_jump_ascent(delta: float) -> void:
	_horizontal_movement(delta)
	move_and_slide()
	_check_block_bumps()

	jump_timer += delta
	if not Input.is_action_pressed("jump") or jump_timer >= max_jump_time:
		mario_state = MarioState.JUMP_APEX


func _physics_jump_apex(delta: float) -> void:
	velocity.y += apex_gravity * delta
	if velocity.y >= terminal_jump_speed:
		_transition_jump_descent()

	_horizontal_movement(delta)
	move_and_slide()
	_check_block_bumps()
	_check_grounded()

func _physics_descent(delta: float) -> void:
	_horizontal_movement(delta)
	move_and_slide()
	_check_grounded()

func _physics_dead(delta: float) -> void:
	velocity.y += death_gravity * delta
	position.y += velocity.y * delta
	if position.y > camera.position.y + VIEWPORT_HEIGHT + MARIO_EDGE_OFFSET_Y:
		_begin_level_reload()

func _begin_level_reload() -> void:
	set_physics_process(false)
	await get_tree().create_timer(1.0).timeout
	GameState.lives -= 1
	GameState.reset_after_death()
	get_tree().reload_current_scene()
