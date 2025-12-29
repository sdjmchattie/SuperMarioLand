extends Node

signal time_changed(value)
signal coins_changed(value)

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
