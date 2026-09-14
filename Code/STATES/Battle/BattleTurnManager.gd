extends Node
class_name BattleTurnManager

enum battle_phase {
	player,
	enemy,
	neutral
}

@export var BattleStateMachine: State_Factory_Battle

var current_phase: battle_phase = battle_phase.player
var current_minion: Node = null #Dodać później wspólnego parenta dla wszystkich ludków
var player_minions: Array = []
var enemy_minions: Array = []
var used_minions_this_turn: Array = []
var not_used_minions_this_turn: Array = []
var movement_path: Array = []

func _ready() -> void:
	refresh_player_minions()
	connect_state_signals()
	begin_player_phase()

func connect_state_signals() -> void:
	if not BattleStateMachine:
		return
	
	var choose_minion_state = BattleStateMachine.get_state("Bstate_player_choose_minion")
	if choose_minion_state and choose_minion_state.has_signal("minion_selected"):
		choose_minion_state.minion_selected.connect(on_minion_selected)

	var choose_action_state = BattleStateMachine.get_state("Bstate_action_selection")
	if choose_action_state and choose_action_state.has_signal("action_selected"):
		choose_action_state.action_selected.connect(on_action_selected)

	var choose_target_state = BattleStateMachine.get_state("Bstate_player_choose_target")
	if choose_target_state and choose_target_state.has_signal("target_selected"):
		choose_target_state.target_selected.connect(on_target_selected)
	
	var attack_state = BattleStateMachine.get_state("Bstate_attack")
	if attack_state and attack_state.has_signal("attack_performed"):
		attack_state.attack_performed.connect(minion_attack)

	#var end_enemy_phase_state = BattleStateMachine.get_state("Bstate_enemy_end")
	#if end_enemy_phase_state and end_enemy_phase_state.has_signal("phase_ended"):
		#end_enemy_phase_state.phase_ended.connect(begin_player_phase)

	#var end_player_phase_state = BattleStateMachine.get_state("Bstate_player_end")
	#if end_player_phase_state and end_player_phase_state.has_signal("phase_ended"):
	#	end_player_phase_state.phase_ended.connect(begin_enemy_phase)

func refresh_player_minions() -> void:
	player_minions = get_tree().get_nodes_in_group("Player_char")
	for minion in player_minions:
		if minion is Ludzik_gracza:
			minion.used_this_turn = false

func begin_player_phase() -> void:
	current_phase = battle_phase.player
	not_used_minions_this_turn = [] + player_minions
	used_minions_this_turn = []
	movement_path.clear()
	#TODO Dodać connect do startu rundy gracza

func begin_enemy_phase() -> void:
	not_used_minions_this_turn = [] + enemy_minions
	used_minions_this_turn = []
	current_phase = battle_phase.enemy
	#TODO Dodać connect do startu rundy enemy

func on_minion_selected(minion: Ludzik_gracza) -> void:
	current_minion = minion
	movement_path.clear()

func on_target_selected(target: Node) -> void:
	#Przekazanie pola z grida bo można by atakować też puste pola by zastawiać pułapki itd
	pass

func mark_minion_moved(minion: Ludzik_gracza, path: Array) -> void:
	movement_path = path

func minion_attack() -> void:
	current_minion.used_this_turn = true
	#TODO make attack current minion -> current_target

func finish_action(minion: Ludzik_gracza) -> void:
	if minion == current_minion:
		minion.used_this_turn = true

func on_action_selected(action: String) -> void:
	if action == "move":
		BattleStateMachine.get_state("Bstate_movement").Enter()
	elif action == "attack":
		BattleStateMachine.get_state("Bstate_player_choose_target").Enter()
	elif action == "end_turn":
		BattleStateMachine.get_state("Bstate_player_end").Enter()

func on_battle_started() -> void:
	#TODO Dodać logikę startu bitwy
	pass

func on_battle_ended() -> void:
	#TODO Dodać logikę końca bitwy
	pass


func reset_turn_flags() -> void:
	for minion in player_minions:
		if minion is Ludzik_gracza:
			minion.used_this_turn = false
	begin_player_phase()
