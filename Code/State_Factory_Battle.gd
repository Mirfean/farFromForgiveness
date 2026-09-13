extends Node
class_name State_Factory_Battle

var current_state: battle_state
var states: Dictionary = {}

func _ready():
	for child in get_children():
		if child is battle_state:
			states[child.name] = child as battle_state
			child.Transitioned.connect(on_child_transition)
			
func get_state(state_name):
	if states.has(state_name):
		return states.get(state_name)
	else:
		printerr("No state ", state_name, " in state factory!")

func get_current_state():
	return current_state

func on_child_transition(state, new_state_name):
	if state != current_state:
		return
		
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
		
	if current_state:
		current_state.exit()
		
	new_state.enter()
	
	
