extends battle_state
class_name Bstate_player_choose_attack

func Enter():
	print_debug("player choose attack")

func is_attack_possible():
	#Warunki
	select_weapon()
	
func InputState(event: InputEvent)-> void:
	if event.is_action_pressed("back"):
		Transitioned.emit("Bstate_player_movement")
	if event.is_action_pressed("confirm"):
		select_weapon()
	
func select_weapon():
	Transitioned.emit(self, "Bstate_player_choose_target")

func Exit():
	pass
