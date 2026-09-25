extends battle_state
class_name Bstate_movement

var movementManager: MovementManager

signal startMovement
signal revertMovement
signal confirmMovement

func Enter():
	if not movementManager:
		movementManager = get_tree().get_first_node_in_group("MovementManager")
	startMovement.emit()
	#movementManager.highlight_movement_range()

func InputState(event: InputEvent):
	
	if event.is_action_pressed("back"):
		Transitioned.emit(self, "Bstate_player_choose_minion")
		revertMovement.emit()
		
	if event.is_action_pressed("confirm"):
		Transitioned.emit(self, "Bstate_action_selection")
		confirmMovement.emit()
		
func Exit():
	pass
