extends battle_state
class_name Bstate_attack

@export var attack_UI: Control


func Enter():
	#Sending info to attack_UI? Or emit signal from there to execute info share and process attack?
	print_debug("ATTACK!")
	Transitioned.emit(self, "Bstate_player_end_action")
	
func Exit():
	pass
