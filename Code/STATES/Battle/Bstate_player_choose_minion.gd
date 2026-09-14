extends battle_state
class_name Bstate_player_choose_minion

signal minion_selected(minion: Ludzik_gracza)

@export var player_minions: Array[Ludzik_gracza]

@export var id_selected_minion: int
@export var selected_minion: Ludzik_gracza

func Enter():
	print_debug("Choose player minion")
	
	getMinions()

	if player_minions.size() == 0:
		Transitioned.emit(self, "Bstate_player_end_turn")
		return
	
	next_minion(0)

func InputState(event: InputEvent) -> void:
	#Add mouse choice in the far future :>
	if event.is_action_pressed("move_left"):
		next_minion(abs(id_selected_minion-1))
	if event.is_action_pressed("move_right"):
		next_minion(abs(id_selected_minion+1))
	if event.is_action_pressed("confirm"):
		Transitioned.emit(self, "Bstate_movement")

func getMinions():
	var minions = get_tree().get_nodes_in_group("Player_char") as Array[Ludzik_gracza]
	for minion in minions:
		if minion is Ludzik_gracza:
			player_minions.append(minion)

func next_minion(id: int):
	id_selected_minion = id % player_minions.size()
	selected_minion = player_minions[id_selected_minion]
	minion_selected.emit(selected_minion)
	
func Exit():
	### DEBUG ###
	selected_minion.active = true
	
	pass
