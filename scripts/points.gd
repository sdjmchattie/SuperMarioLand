extends Sprite2D

@export var rise_velocity := 32.0
@export var rise_seconds := 0.9

@onready var free_timer: Timer = $FreeTimer

func _ready() -> void:
	free_timer.start(rise_seconds)

func _process(delta: float) -> void:
	position.y -= rise_velocity * delta

func set_value(points: int) -> void:
	# Map point value to sprite frame
	match points:
		100: frame = 1
		200: frame = 2
		400: frame = 3
		500: frame = 4
		800: frame = 5
		1000: frame = 6
		_: frame = 0  # Default to 1UP

func _on_free_timer_timeout() -> void:
	queue_free()
