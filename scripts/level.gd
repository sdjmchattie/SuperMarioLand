extends Node2D

@export var blocks_layout: TileMapLayer
@export var blocks_parent: Node

func _ready() -> void:
	_spawn_blocks_from_tilemap()

func _spawn_blocks_from_tilemap() -> void:
	for cell in blocks_layout.get_used_cells():
		var tile_data = blocks_layout.get_cell_tile_data(cell)
		print(tile_data.get_custom_data("Type"))
		print(tile_data.get_custom_data("Spawns"))
		print(tile_data.get_custom_data("Repeat"))
		print(tile_data.get_custom_data("Breakable"))
		print()
