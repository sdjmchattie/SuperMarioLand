extends Area2D

enum State {
	ARC,
	FALLING,
}

@export var arc_radius := 12.0
@export var arc_speed := 4.0
@export var fall_speed := 50.0

var state: State = State.ARC
var arc_centre := Vector2.ZERO
var arc_angle := PI

func _ready() -> void:
	position.y -= 4.0
	arc_centre = position
	arc_centre.x += arc_radius

func _physics_process(delta: float) -> void:
	match state:
		State.ARC:
			_physics_arc(delta)
		State.FALLING:
			_physics_falling(delta)

func _physics_arc(delta: float) -> void:
	arc_angle -= arc_speed * delta
	position = arc_centre + Vector2(
		cos(arc_angle),
		-sin(arc_angle) * 0.75
	) * arc_radius

	if arc_angle <= 0.0:
		state = State.FALLING

func _physics_falling(delta: float) -> void:
	position.y += fall_speed * delta

func _on_collection(body: Node2D) -> void:
	body.grab_star()
	queue_free()
