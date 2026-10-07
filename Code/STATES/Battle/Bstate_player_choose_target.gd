extends battle_state
class_name Bstate_player_choose_target

signal target_selected(target: Node) #Pole na gridzie?
signal next_target(direction: Vector2i)

@export var select_module: Node

func Enter():
	print_debug("player choose target")

func is_attack_possible():
	#Warunki
	perform_attack()
	
func InputState(event: InputEvent)-> void:
	if event.is_action_pressed("move_up"):
		next_target.emit(GLOBAL.move_inputs["move_up"])
	if event.is_action_pressed("move_down"):
		next_target.emit(GLOBAL.move_inputs["move_down"])
	if event.is_action_pressed("move_left"):
		next_target.emit(GLOBAL.move_inputs["move_left"])
	if event.is_action_pressed("move_right"):
		next_target.emit(GLOBAL.move_inputs["move_right"])
	if event.is_action_pressed("back"):
		Transitioned.emit("Bstate_player_choose_attack")
	if event.is_action_pressed("confirm"):
		perform_attack()
	
func perform_attack():
	if select_module:
		target_selected.emit(select_module.current_selected)
	Transitioned.emit(self, "Bstate_attack")

func Exit():
	pass
