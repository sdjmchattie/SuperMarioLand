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
const MushroomScene := preload("res://scenes/powerups/mushroom.tscn")
const FlowerScene := preload("res://scenes/powerups/flower.tscn")
const ExtraLifeScene := preload("res://scenes/powerups/extra_life.tscn")

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
	GameState.score += 100
	if _timer_triggered:
		type = Type.USED

	var coin = CoinScene.instantiate()
	coin.position = global_position
	coin.position.y -= 7
	get_tree().current_scene.add_child(coin)

func _spawn_mushroom() -> void:
	type = Type.USED

	var mushroom = MushroomScene.instantiate()
	mushroom.position = global_position
	get_tree().current_scene.add_child(mushroom)

func _spawn_flower() -> void:
	type = Type.USED

	var flower = FlowerScene.instantiate()
	flower.position = global_position
	get_tree().current_scene.add_child(flower)

func _spawn_extra_life() -> void:
	type = Type.USED

	var extra_life = ExtraLifeScene.instantiate()
	extra_life.position = global_position
	get_tree().current_scene.add_child(extra_life)

func on_bumped() -> void:
	if type == Type.USED:
		return

	match type:
		Type.BRICK:
			if GameState.powerup == GameState.Powerup.NONE or spawns != "":
				_jump_sprite()
			else:
				pass
		Type.QUESTION:
			_jump_sprite()

	match spawns:
		"Coin":
			_timer_triggered = true
			_spawn_coin()
		"MultiCoin":
			if coin_timer.is_stopped():
				coin_timer.start()
			_spawn_coin()
		"Upgrade":
			if GameState.powerup == GameState.Powerup.NONE:
				_spawn_mushroom()
			elif GameState.powerup == GameState.Powerup.MUSHROOM:
				_spawn_flower()
		"Life":
			_spawn_extra_life()
		"Invincibility":
			pass
