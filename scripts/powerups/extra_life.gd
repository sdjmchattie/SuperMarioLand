extends CharacterBody2D

enum State {
	ARC,
	FALLING,
	SLIDING,
}

@export var arc_radius := 12.0
@export var arc_speed := 4.0
@export var fall_speed := 50.0
@export var slide_speed := 35.0

var state: State = State.ARC
var arc_centre := Vector2.ZERO
var arc_angle := PI
var slide_direction = 1

func _ready() -> void:
	position.y -= 4.0
	arc_centre = position
	arc_centre.x += arc_radius

func _physics_process(delta: float) -> void:
	match state:
		State.ARC:
			_physics_arc(delta)
		State.FALLING:
			_physics_falling()
		State.SLIDING:
			_physics_sliding()

func _compute_arc_position(delta: float) -> Vector2:
	arc_angle -= arc_speed * delta

	return arc_centre + Vector2(
		cos(arc_angle),
		-sin(arc_angle) * 0.75
	) * arc_radius

func _physics_arc(delta: float) -> void:
	var next_pos = _compute_arc_position(delta)
	var delta_vec = next_pos - position

	var collision = move_and_collide(delta_vec)
	if collision:
		# Arc interrupted, fall straight down from here
		position = collision.position
		state = State.FALLING
	elif arc_angle <= 0.0:
		# Arc has finished
		state = State.FALLING
	else:
		# Continue following the arc
		position = next_pos

func _physics_falling() -> void:
	velocity = Vector2(0.0, fall_speed)
	move_and_slide()

	if is_on_floor():
		state = State.SLIDING

func _physics_sliding() -> void:
	velocity = Vector2(slide_speed * slide_direction, 0.0)
	move_and_slide()

	if is_on_wall():
		slide_direction *= -1

	if !is_on_floor():
		state = State.FALLING

func _on_collection(body: Node2D) -> void:
	body.grab_extra_life()
	queue_free()
