extends battle_state
class_name Bstate_action_selection

@export var action_menu: action_ui

signal action_selected(action: String)
signal action_attack
signal action_item
signal action_defend

func Enter():
	print_debug("Action selection")
	
	if not action_menu:
		action_menu = get_tree().get_first_node_in_group("ActionMenu")
		if not action_menu.action_selected.has_connections():
			action_menu.action_selected.connect(action_button_clicked)
	
	action_menu.visible = true
	#Pin current character to his actions
	
func InputState(event: InputEvent):
	if event.is_action_pressed("back"):
		Transitioned.emit(self, "Bstate_movement")

func action_button_clicked(button: String):
	print_debug("Action chosen " + button)
	match button:
		"ATTACK":
			action_attack.emit()
			Transitioned.emit(self, "Bstate_player_choose_target")
		"ITEM":
			action_item.emit()
			Transitioned.emit(self, "Bstate_player_choose_item") 
		"DEFEND":
			action_defend.emit()
			Transitioned.emit(self, "Bstate_player_choose_defend")
		"INTERACT":
			pass
			
func Exit():
	action_menu.visible = false
	#unpin character from action_menu
