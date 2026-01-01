extends Area2D

func _on_mario_touched_coin(_body: Node2D) -> void:
	GameState.coins += 1
	queue_free()
