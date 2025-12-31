class_name Block
extends StaticBody2D

enum Type {
	QUESTION,
	USED,
	BRICK,
	SOLID,
	HIDDEN,
}

const BUMP_SPEED := 0.07

@onready var sprite: Sprite2D = $Sprite2D

var type: Type
var spawns: String

func _ready() -> void:
	sprite.frame = type

func _jump_sprite() -> void:
	var tween = create_tween()
	tween.tween_property(sprite, "position:y", sprite.position.y - 4, BUMP_SPEED).as_relative()
	tween.tween_property(sprite, "position:y", sprite.position.y, BUMP_SPEED).as_relative().set_delay(BUMP_SPEED)

func on_bumped() -> void:
	if (
		GameState.powerup == GameState.Powerup.NONE and
		type in [Type.QUESTION, Type.BRICK]
	):
		_jump_sprite()
