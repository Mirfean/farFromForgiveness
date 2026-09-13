extends battle_state
class_name Bstate_attack

@export var attack_UI: Control


func Enter():
	#Sending info to attack_UI? Or emit signal from there to execute info share and process attack?
	pass
	
func Exit():
	Transitioned.emit(self, )
