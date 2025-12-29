extends Camera2D

const CAMERA_MARGIN = 4.0

@export var level_background: Node

var half_width: float
var max_x: float

func _ready() -> void:
	var view_width = get_viewport_rect().size.x
	half_width = view_width / 2.0
	max_x = level_background.size.x - view_width

func update_mario_pos(mario_left: float, mario_right: float) -> int:
	# Updates the camera according to the player position.
	# Returns:
	#   true if Mario is within bounds.
	#   false if Mario should not move to the new position.
	if mario_right > position.x + half_width:
		position.x = min(mario_right - half_width, max_x)

	var left_stop = position.x - CAMERA_MARGIN
	var right_stop = (
		position.x +
		2 * half_width +
		CAMERA_MARGIN
	)

	return mario_left > left_stop and mario_right < right_stop
