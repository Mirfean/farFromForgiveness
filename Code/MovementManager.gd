extends Node
class_name MovementManager

const directions = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]
# Tile for show possible movement
const SOURCE_ID = 0
const movement_highlight_tile = Vector2i(9, 9) 

signal MoveCurrentMinion(Vector2i)

@export var mapManager: MapManager

var current_minion: Ludzik_gracza
var movement_path: Array
var current_minion_remaining_movement: int

func _ready() -> void:
	pass

# Taken from internet :>
func get_reachable_cells(start_cell: Vector2i, max_movement: int) -> Dictionary:
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
	mapManager.tilemap_ui.clear()
	for cell in reachable_cells.keys():
		mapManager.tilemap_ui.set_cell(cell, SOURCE_ID, movement_highlight_tile)
		
func setup_new_minion(minion: Ludzik_gracza):
	current_minion = minion
	current_minion_remaining_movement = minion.movement
	movement_path.clear()

func checkMovement(move: Vector2i):
	if current_minion == null:
		return

	var current_cell = current_minion.grid_position
	var target_cell = current_cell + move
	var tile_to_check = mapManager.main_tilemap.get_cell_tile_data(target_cell)
	#1. Check if this space is available
	if mapManager.astargrid.is_point_solid(target_cell):
		print_debug("Blocking on " + str(target_cell))
		return
	#2. Check if this space is in movement_path
	for x in len(movement_path):
		if movement_path[x][0] == target_cell:
			current_minion_remaining_movement = movement_path[x][1]
			movement_path.resize(x+1)
			MoveCurrentMinion.emit(move)
			return
	
	#3. Check if chacter has enough movement to even move
	if tile_to_check.has_custom_data("move_cost"):
		var move_cost = tile_to_check.get_custom_data("move_cost")
		if current_minion_remaining_movement >= move_cost:
			print_debug("You can move here!")
			movement_path.append([current_cell, current_minion_remaining_movement])
			current_minion_remaining_movement -= move_cost
			MoveCurrentMinion.emit(move)
		else:
			print_debug("Not enough movement!")
	else:
		print_debug("womp womp")

func cleaner():
	current_minion = null
	current_minion_remaining_movement = 0
	movement_path.clear()
