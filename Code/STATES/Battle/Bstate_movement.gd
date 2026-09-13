extends battle_state
class_name Bstate_movement


func InputState(event: InputEvent):
	print("Bstate_movement InputState")
	
	if event.is_action_pressed("back"):
		Transitioned.emit(self, "Bstate_player_choose_minion")
		
	if event.is_action_pressed("confirm"):
		Transitioned.emit(self, "Bstate_action_selection")
