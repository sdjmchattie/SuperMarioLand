extends Node

enum Powerup {
	NONE,
	MUSHROOM,
	FLOWER,
}

signal score_changed(new_score)
signal lives_changed(new_lives)
signal time_changed(new_time)
signal coins_changed(new_coins)

var _level_timer = Timer.new()

func _ready() -> void:
	_level_timer.process_mode = Node.PROCESS_MODE_PAUSABLE
	_level_timer.wait_time = 2.0/3.0
	_level_timer.timeout.connect(_on_time_decrease)
	_level_timer.one_shot = false
	add_child(_level_timer)
	_level_timer.start()

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

var powerup := Powerup.NONE
var invincible := false

func _on_time_decrease() -> void:
	time_remaining -= 1
	if time_remaining == 0:
		# TODO: handle timeout death
		pass
