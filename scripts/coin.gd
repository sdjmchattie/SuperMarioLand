extends Area2D

func _on_mario_touched_coin(_body: Node2D) -> void:
	GameState.coins += 1
	GameState.score += 100
	queue_free()
