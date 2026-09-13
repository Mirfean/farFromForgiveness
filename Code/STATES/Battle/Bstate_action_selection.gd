extends battle_state
class_name Bstate_action_selection

@export var action_menu: Control

func Enter():
	print_debug("Action selection")
	
	if not action_menu:
		action_menu = get_tree().get_first_node_in_group("ActionMenu")
	
	action_menu.visible = true
	#Pin current character to his actions
	
func InputState(event: InputEvent):
	if event.is_action_pressed("confirm"):
		#Do action from current button
		#Do not remove current button if cursor is away from but set it if cursor just touched button
		#Currently, only attack after confirm xD
		Transitioned.emit(self, "Bstate_player_choose_attack")
	if event.is_action_pressed("back"):
		Transitioned.emit(self, "BState_movement")

func Exit():
	print_debug("Siemano kolano")
	action_menu.visible = false
	#unpin character from action_menu
