extends battle_state
class_name Bstate_player_end_action

signal action_performed

func Enter():
	#TODO remove current minion info for next one and check if we lost or win
	#All other things should be handled in previous states
	print_debug("player end action")
	restart_action_loop()
	
func restart_action_loop():
	action_performed.emit()
	Transitioned.emit(self, "Bstate_player_choose_minion")
	

func Exit():
	pass
