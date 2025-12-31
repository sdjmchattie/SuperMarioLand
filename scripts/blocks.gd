extends Node2D

const BlockScene := preload("res://scenes/block.tscn")

@onready var map: TileMapLayer = $BlockMap

func _ready() -> void:
	_spawn_blocks_from_tilemap()

func _spawn_blocks_from_tilemap() -> void:
	for cell in map.get_used_cells():
		var tile_pos = map.map_to_local(cell)
		var tile_data = map.get_cell_tile_data(cell)
		var type = tile_data.get_custom_data("Type")
		var spawns = tile_data.get_custom_data("Spawns")
		var breakable = tile_data.get_custom_data("Breakable")

		print(tile_pos)
		var block := BlockScene.instantiate()
		block.position = tile_pos
		add_child(block)
