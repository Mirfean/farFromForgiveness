extends battle_state
class_name Bstate_action_selection

@export var action_menu: Control

func Enter():
	print_debug("Action selection")
	action_menu.visible = true
	#Pin current character to his actions

func Exit():
	print_debug("Siemano kolano")
	action_menu.visible = false
	#unpin character from action_menu
