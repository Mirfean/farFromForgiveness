extends battle_state
class_name Bstate_player_choose_target

signal target_selected(target_cell: Vector2i)

@export var select_module: selection_module

var map_manager: MapManager
var valid_target_cells: Array[Vector2i]
var current_selected: Vector2i

func Enter():
	print_debug("player choose target")
	if not valid_target_cells.is_empty():
		select_module.start_selection()
		move_selection_to_cell(current_selected)

func is_attack_possible():
	#Warunki
	perform_attack()
	
func InputState(event: InputEvent)-> void:
	if event is InputEventMouseMotion:
		select_mouse_cell()
		return

	if event.is_action_pressed("LMB"):
		var mouse_cell = get_mouse_cell()
		if valid_target_cells.has(mouse_cell):
			current_selected = mouse_cell
			perform_attack()
		return

	if event.is_action_pressed("move_up"):
		move_to_target(Vector2i(GLOBAL.move_inputs["move_up"]))
	if event.is_action_pressed("move_down"):
		move_to_target(Vector2i(GLOBAL.move_inputs["move_down"]))
	if event.is_action_pressed("move_left"):
		move_to_target(Vector2i(GLOBAL.move_inputs["move_left"]))
	if event.is_action_pressed("move_right"):
		move_to_target(Vector2i(GLOBAL.move_inputs["move_right"]))
	if event.is_action_pressed("back"):
		Transitioned.emit(self, "Bstate_player_choose_attack")
	if event.is_action_pressed("confirm"):
		if valid_target_cells.has(current_selected):
			perform_attack()
	
func setup_targeting(map: MapManager, selector: selection_module, cells: Array) -> void:
	map_manager = map
	select_module = selector
	valid_target_cells.clear()
	valid_target_cells.append_array(cells)
	if not valid_target_cells.is_empty():
		current_selected = valid_target_cells[0]

func get_mouse_cell() -> Vector2i:
	return map_manager.main_tilemap.local_to_map(
		map_manager.main_tilemap.to_local(map_manager.main_tilemap.get_global_mouse_position())
	)

func select_mouse_cell() -> void:
	if valid_target_cells.is_empty():
		return
	var mouse_cell = get_mouse_cell()
	if valid_target_cells.has(mouse_cell):
		current_selected = mouse_cell
		move_selection_to_cell(mouse_cell)

func move_to_target(direction: Vector2i) -> void:
	var next_cell = current_selected + direction
	if valid_target_cells.has(next_cell):
		current_selected = next_cell
		move_selection_to_cell(next_cell)

func move_selection_to_cell(cell: Vector2i) -> void:
	var local_position = map_manager.main_tilemap.map_to_local(cell)
	select_module.move_box(map_manager.main_tilemap.to_global(Vector2(local_position.x-8, local_position.y-8)))

func perform_attack() -> void:
	print(current_selected)
	target_selected.emit(current_selected)
	Transitioned.emit(self, "Bstate_attack")

func Exit():
	if select_module:
		select_module.stop_selection()
