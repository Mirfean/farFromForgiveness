extends Node
class_name MapManager

#TEMPORARY
const grid_start = Vector2i(-64, -64)
const cell_size = 16

var astargrid: AStarGrid2D
@export var main_tilemap: TileMapLayer
@export var tilemap_ui: TileMapLayer
var map_size: Vector2i

func _ready() -> void:
	astargrid = AStarGrid2D.new()
	
	#TODO move it later to resource loader for map
	map_size = Vector2i(1024, 1024)
	astargrid.region = Rect2i(-64, -64, map_size.x, map_size.y)
	astargrid.cell_size = Vector2i(16, 16)
	
	astargrid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astargrid.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astargrid.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astargrid.update()
	set_obstacles()
	setup_grid_from_tilemap()
	print_debug("Debug Siema")
	astargrid.update()
	print_debug("Debug Siema")

func set_obstacles():
	for x in map_size.x:
		for x_y in map_size.y:
			var coords = Vector2i(x, x_y)
			var tile_data = main_tilemap.get_cell_tile_data(coords)
			
			if tile_data:
				var is_solid = tile_data.get_custom_data("is_solid")
				var move_cost = tile_data.get_custom_data("move_cost")
				
				if is_solid:
					astargrid.set_point_solid(coords, true)
				elif move_cost:
					astargrid.set_point_weight_scale(coords, move_cost)

func apply_mud_effect(target_tile: Vector2i):
	#TODO ADD mud tile
	main_tilemap.set_cell(target_tile, 1, Vector2i(2, 0))

	astargrid.set_point_weight_scale(target_tile, 3.0)

func setup_grid_from_tilemap():
	#var used_rect: Rect2i = main_tilemap.get_used_rect()
	#astargrid.region = used_rect
	#astargrid.cell_size = main_tilemap.tile_set.tile_size
	astargrid.update()

	for cell in main_tilemap.get_used_cells():
		var tile_data: TileData = main_tilemap.get_cell_tile_data(cell)
		
		if tile_data != null:
			var is_solid: bool = tile_data.get_custom_data("is_solid")
			var move_cost: float = tile_data.get_custom_data("move_cost")
			
			if is_solid:
				astargrid.set_point_solid(cell, true)
			elif move_cost > 0:
				astargrid.set_point_weight_scale(cell, move_cost)

func calculate_grid_position(pos: Vector2) -> Vector2i:
	var x = (pos.x - grid_start.x) / cell_size
	var y = (pos.y - grid_start.y) / cell_size
	return Vector2i(x, y)

func set_grid_positions(list: Array) -> Dictionary:
	var result = {}
	for minion in list:
		result[calculate_grid_position(minion.global_position)] = minion
	return result
	
	
	
