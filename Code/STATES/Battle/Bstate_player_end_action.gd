extends battle_state
class_name Bstate_player_end_action


func Enter():
	#Usuwanie
	pass
	
func restart_action_loop():
	Transitioned.emit(self, "Bstate_player_choose_minion")
