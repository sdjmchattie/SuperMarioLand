extends Node2D

const CoinScene := preload("res://scenes/coin.tscn")

@onready var map: TileMapLayer = $CoinMap

func _ready() -> void:
	_spawn_coins_from_tilemap()
	map.hide()
	map.set_physics_process(false)

func _spawn_coins_from_tilemap() -> void:
	for cell in map.get_used_cells():
		var coin = CoinScene.instantiate()
		coin.position = map.map_to_local(cell)
		add_child(coin)
