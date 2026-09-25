extends Node
class_name MovementManager

const directions = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]
# Tile for show possible movement
const SOURCE_ID = 0
const movement_highlight_tile = Vector2i(9, 9) 


@export var mapManager: MapManager

func _ready() -> void:
	pass

# Taken from internet :>
func get_reachable_cells(start_cell: Vector2i, max_movement: int) -> Dictionary:
	mapManager.astargrid.update()
	var astargrid = mapManager.astargrid
	print_debug("For " + str(start_cell) )
	var reachable: Dictionary = {}
	var frontier: Array[Dictionary] = [{ "cell": start_cell, "remaining_move": max_movement }]
	
	reachable[start_cell] = max_movement

	while not frontier.is_empty():
		var current = frontier.pop_front()
		var current_cell: Vector2i = current["cell"]
		var current_move: int = current["remaining_move"]

		for dir in directions:
			var neighbor: Vector2i = current_cell + dir
			
			if astargrid.is_point_solid(neighbor):
				continue

			var tile_weight: int = int(astargrid.get_point_weight_scale(neighbor))
			var new_remaining_move: int = current_move - tile_weight

			if new_remaining_move < 0:
				continue

			if not reachable.has(neighbor) or new_remaining_move > reachable[neighbor]:
				reachable[neighbor] = new_remaining_move
				frontier.append({ "cell": neighbor, "remaining_move": new_remaining_move })
				print(neighbor)

	return reachable

func highlight_movement_range(start_cell: Vector2i, movement_points: int):
	var reachable_cells = get_reachable_cells(start_cell, movement_points)
	#TODO przesunąć o -64 -64
	mapManager.tilemap_ui.clear()
	for cell in reachable_cells.keys():
		mapManager.tilemap_ui.set_cell(cell, SOURCE_ID, movement_highlight_tile)
