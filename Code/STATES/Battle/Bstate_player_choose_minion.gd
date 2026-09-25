extends battle_state
class_name Bstate_player_choose_minion

signal minion_selected(minion: Ludzik_gracza)
signal change_minion(id: int)

@export var id_selected_minion: int
@export var selected_minion: Ludzik_gracza

func Enter():
	print_debug("Choose player minion")
	id_selected_minion = 0
	next_minion(id_selected_minion)

func InputState(event: InputEvent) -> void:
	#Add mouse choice in the far future :>
	if event.is_action_pressed("move_left"):
		next_minion(false)
	if event.is_action_pressed("move_right"):
		next_minion(true)
	if event.is_action_pressed("confirm"):
		minion_selected.emit(id_selected_minion)
		Transitioned.emit(self, "Bstate_movement")
		

#false: <-   true: -> 
func next_minion(side: bool):
	change_minion.emit(side)

	
func Exit():
	pass
