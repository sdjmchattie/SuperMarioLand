class_name Block
extends StaticBody2D

enum Type {
	QUESTION,
	USED,
	BRICK,
	SOLID,
	HIDDEN,
}

@onready var sprite: Sprite2D = $Sprite2D

var type: Type
var spawns: String

func _ready() -> void:
	sprite.frame = type
