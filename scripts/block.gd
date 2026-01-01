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

func _ready() -> void:
	sprite.frame = type

func _jump_sprite() -> void:
	var tween = create_tween()
	tween.tween_property(sprite, "position:y", sprite.position.y - 4, BUMP_SPEED).as_relative()
	tween.tween_property(sprite, "position:y", sprite.position.y + 4, BUMP_SPEED).as_relative()
	tween.finished.connect(func (): sprite.frame = type)

func _spawn_coin() -> void:
	GameState.coins += 1
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
			_spawn_coin()

	if GameState.powerup == GameState.Powerup.NONE:
		type = Type.USED
