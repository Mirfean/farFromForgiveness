extends battle_state
class_name Bstate_movement

var movementManager: MovementManager

var remainingMovement: int

signal startMovement
signal revertMovement
signal confirmMovement

func Enter():
	if not movementManager:
		movementManager = get_tree().get_first_node_in_group("MovementManager")
	startMovement.emit()
	#movementManager.highlight_movement_range()

func InputState(event: InputEvent):
	if event.is_action_pressed("move_down"):
		checkMovement(GLOBAL.move_inputs["move_down"])
	elif event.is_action_pressed("move_left"):
		checkMovement(GLOBAL.move_inputs["move_left"])
	elif event.is_action_pressed("move_right"):
		checkMovement(GLOBAL.move_inputs["move_right"])
	elif event.is_action_pressed("move_up"):
		checkMovement(GLOBAL.move_inputs["move_up"])
	elif event.is_action_pressed("back"):
		Transitioned.emit(self, "Bstate_player_choose_minion")
		revertMovement.emit()
	elif event.is_action_pressed("confirm"):
		Transitioned.emit(self, "Bstate_action_selection")
		confirmMovement.emit()
		
func Exit():
	pass

func checkMovement(move: Vector2i):
	movementManager.checkMovement(move)
