extends Area2D

enum State {
	RISING,
	WAITING,
}

@export var rise_speed := 20.0
@export var rise_distance := 8.0
@export var flicker_interval := 0.1

@onready var sprite: Sprite2D = $Flower

var state: State = State.RISING
var _risen := 0.0
var _flicker_timer := 0.0
var _flicker_frame := 0

func _process(delta: float) -> void:
	match state:
		State.RISING:
			_process_rising(delta)
		State.WAITING:
			_process_waiting(delta)

func _process_rising(delta: float) -> void:
	var move := rise_speed * delta
	_risen += move
	if _risen >= rise_distance:
		move -= _risen - rise_distance
		_risen = rise_distance
		state = State.WAITING
	position.y -= move

func _process_waiting(delta: float) -> void:
	_flicker_timer += delta
	if _flicker_timer >= flicker_interval:
		_flicker_timer -= flicker_interval
		_flicker_frame = 1 - _flicker_frame
		sprite.frame = 4 + _flicker_frame

func _on_collection(body: Node2D) -> void:
	body.grab_flower()
	queue_free()
