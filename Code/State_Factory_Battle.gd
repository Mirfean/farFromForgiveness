extends Node
class_name State_Factory_Battle

@export var current_state: battle_state
@export var states: Dictionary = {}

func _ready():
	for child in get_children():
		if child is battle_state:
			states[child.name] = child as battle_state
			child.Transitioned.connect(on_child_transition)
	
	if not current_state:
		current_state = states[0]
	
	setup_initial_state()

func setup_initial_state():
	#YADA YADA
	current_state.Enter()

func get_state(state_name):
	if states.has(state_name):
		return states.get(state_name)
	else:
		printerr("No state ", state_name, " in state factory!")

func _input(event: InputEvent) -> void:
	if current_state:
		current_state.InputState(event)
		
func _physics_process(delta: float) -> void:
	if current_state:
		current_state.PhysicsUpdate(delta)

func get_current_state():
	return current_state

func on_child_transition(state, new_state_name):
	if state != current_state:
		return
		
	var new_state = states.get(new_state_name)
	
	if !new_state:
		return

	if current_state:
		current_state.Exit()
	
	current_state = new_state	
	new_state.Enter()
	
	if GLOBAL.DEBUG and current_state:
		GLOBAL.debug_battle_state(current_state.name)
	
