extends battle_state
class_name Bstate_choose_attack_target


func is_attack_possible():
	#Warunki
	perform_attack()
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("back"):
		Transitioned.emit("Bstate_player_movement")
	if event.is_action_pressed("confirm"):
		perform_attack()
	
func perform_attack():
	Transitioned.emit(self, "Bstate_attack")
