extends battle_state
class_name Bstate_start_player_turn

#ENTER ONLY ONCE PER FULL TURN
func Enter():
	print_debug("Start player turn")
	Transitioned.emit(self, "Bstate_player_choose_minion")
	#Get all minions?

func Exit():
	print_debug("End starting player turn")
