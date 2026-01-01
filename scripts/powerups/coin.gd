extends Sprite2D

@export var rise_velocity := 60.0
@export var rise_seconds := 0.5

@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var free_timer: Timer = $FreeTimer

func _ready() -> void:
	animator.play("default")
	free_timer.start(rise_seconds)

func _process(delta: float) -> void:
	position.y -= rise_velocity * delta

func _on_free_timer_timeout() -> void:
	queue_free()
