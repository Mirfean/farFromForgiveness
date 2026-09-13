extends Node
class_name Bstate_player_choose_minion

@export var player_minions: Array[Ludzik_gracza]

@export var id_selected_minion: int
@export var selected_minion: CharacterBody2D

func Enter():
	next_minion(0)
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("move_left") or event.is_action_pressed("move_right"):
		next_minion(id_selected_minion+1)

func next_minion(id: int):
	id_selected_minion = id % player_minions.size()
	selected_minion = player_minions[id_selected_minion]
	
