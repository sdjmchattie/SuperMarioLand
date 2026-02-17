extends Node2D

const Gravity := 600.0
const HorizSpeed := 80.0
const VertSpeedHigh := -140.0
const VertSpeedLow := -100.0
const DistLimit := 48.0

@onready var left_high: Sprite2D = $LeftHigh
@onready var left_low: Sprite2D = $LeftLow
@onready var right_high: Sprite2D = $RightHigh
@onready var right_low: Sprite2D = $RightLow

var pieces: Array[Dictionary] = []


func _ready() -> void:
	pieces = [
		{"sprite": left_high,  "vx": -HorizSpeed, "vy": VertSpeedHigh, "dist": 0.0},
		{"sprite": left_low,   "vx": -HorizSpeed, "vy": VertSpeedLow,  "dist": 0.0},
		{"sprite": right_high, "vx":  HorizSpeed,  "vy": VertSpeedHigh, "dist": 0.0},
		{"sprite": right_low,  "vx":  HorizSpeed,  "vy": VertSpeedLow,  "dist": 0.0},
	]


func _process(delta: float) -> void:
	for piece in pieces:
		piece["vy"] += Gravity * delta
		piece["sprite"].position.x += piece["vx"] * delta
		piece["sprite"].position.y += piece["vy"] * delta
		piece["dist"] += absf(piece["vx"]) * delta
		if piece["dist"] >= DistLimit:
			queue_free()
