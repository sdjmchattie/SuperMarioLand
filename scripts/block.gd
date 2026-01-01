class_name Block
extends StaticBody2D

enum Type {
	QUESTION,
	USED,
	BRICK,
	SOLID,
	HIDDEN,
}

const CoinScene := preload("res://scenes/powerups/coin.tscn")

const BUMP_SPEED := 0.07

@onready var sprite: Sprite2D = $Sprite2D

var type: Type
var spawns: String

var _timer_triggered := false
@onready var coin_timer: Timer = $CoinTimer

func _ready() -> void:
	sprite.frame = type
	coin_timer.timeout.connect(func (): _timer_triggered = true)

func _jump_sprite() -> void:
	var tween = create_tween()
	tween.tween_property(sprite, "position:y", sprite.position.y - 4, BUMP_SPEED).as_relative()
	tween.tween_property(sprite, "position:y", sprite.position.y + 4, BUMP_SPEED).as_relative()
	tween.finished.connect(func (): sprite.frame = type)

func _spawn_coin() -> void:
	GameState.coins += 1
	if _timer_triggered:
		type = Type.USED

	var coin = CoinScene.instantiate()
	coin.position = Vector2i.ZERO
	coin.position.y -= 7
	add_child(coin)

func on_bumped() -> void:
	if type == Type.USED:
		return

	if (
		GameState.powerup == GameState.Powerup.NONE and
		type in [Type.QUESTION, Type.BRICK]
	):
		_jump_sprite()

	match spawns:
		"Coin":
			_timer_triggered = true
			_spawn_coin()
		"MultiCoin":
			if coin_timer.is_stopped():
				coin_timer.start()
			_spawn_coin()
