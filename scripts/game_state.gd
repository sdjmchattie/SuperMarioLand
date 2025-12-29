extends Node

signal score_changed(new_score)
signal lives_changed(new_lives)
signal time_changed(new_time)
signal coins_changed(new_coins)

var level_timer = Timer.new()

func _ready() -> void:
	level_timer.process_mode = Node.PROCESS_MODE_PAUSABLE
	level_timer.wait_time = 2.0/3.0
	level_timer.timeout.connect(_on_time_decrease)
	level_timer.one_shot = false
	add_child(level_timer)
	level_timer.start()

var score: int = 0:
	set(value):
		score = value
		score_changed.emit(score)

var lives: int = 2:
	set(value):
		lives = value
		lives_changed.emit(lives)

var time_remaining := 400:
	set(value):
		time_remaining = value
		time_changed.emit(time_remaining)

var coins := 0:
	set(value):
		coins = value
		coins_changed.emit(coins)

func _on_time_decrease() -> void:
	time_remaining -= 1
	if time_remaining == 0:
		# TODO: handle timeout death
		pass
