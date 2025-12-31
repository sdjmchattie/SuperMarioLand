extends Node2D

const BlockScene := preload("res://scenes/block.tscn")

@onready var map: TileMapLayer = $BlockMap

func _ready() -> void:
	_spawn_blocks_from_tilemap()
	map.hide()
	map.set_physics_process(false)

func _spawn_blocks_from_tilemap() -> void:
	for cell in map.get_used_cells():
		var block: Block = BlockScene.instantiate()

		var tile_pos = map.map_to_local(cell)
		block.position = tile_pos

		var tile_data = map.get_cell_tile_data(cell)
		block.type = tile_data.get_custom_data("Type")
		block.spawns = tile_data.get_custom_data("Spawns")

		add_child(block)
