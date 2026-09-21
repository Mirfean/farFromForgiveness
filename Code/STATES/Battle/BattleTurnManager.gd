extends Node
class_name BattleTurnManager

enum battle_phase {
	player,
	enemy,
	neutral
}

@export var BattleStateMachine: State_Factory_Battle
@export var MoveManager: MovementManager
@export var SelectionModule: selection_module

var current_phase: battle_phase = battle_phase.player

var current_minion: Node2D = null #Dodać później wspólnego parenta dla wszystkich ludków
var current_target: Node

var selection_index: int = 0

@export var PlayerContainer: Node
var player_minions: Array = []

@export var EnemyContainer: Node
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
	if choose_minion_state and choose_minion_state.has_signal("change_minion"):
		choose_minion_state.change_minion.connect(on_minion_change)
		
	var player_movement = BattleStateMachine.get_state("Bstate_movement")
	if player_movement and player_movement.has_signal("startMovement"):
		player_movement.startMovement.connect(start_move_minion)
	if player_movement.has_signal("confirmMovement"):
			player_movement.confirmMovement.connect(stop_move_minion)

	var choose_action_state = BattleStateMachine.get_state("Bstate_action_selection")
	if choose_action_state and choose_action_state.has_signal("action_selected"):
		choose_action_state.action_selected.connect(on_action_selected)

	var choose_target_state = BattleStateMachine.get_state("Bstate_player_choose_target")
	if choose_target_state and choose_target_state.has_signal("target_selected"):
		choose_target_state.target_selected.connect(on_target_selected)
	
	var attack_state = BattleStateMachine.get_state("Bstate_attack")
	if attack_state and attack_state.has_signal("attack_performed"):
		attack_state.attack_performed.connect(minion_attack)
	
	var revert_movement_state = BattleStateMachine.get_state("Bstate_movement")
	if revert_movement_state:
		if revert_movement_state.has_signal("revertMovement"):
			revert_movement_state.revertMovement.connect(revert_selection)
	
	var after_player_action = BattleStateMachine.get_state("Bstate_player_end_action")
	if after_player_action:
		if after_player_action.has_signal("action_performed"):
			#TODO change it to something logical
			after_player_action.action_performed.connect(finish_action)
			print_debug("action end")

#One time on start of battle
func refresh_player_minions() -> void:
	print_debug("Refresh player's minions")
	player_minions = PlayerContainer.get_children()
	for minion in player_minions:
		if minion is Ludzik_gracza:
			minion.used_this_turn = false

func cleaner():
	current_minion = null
	current_target = null

func begin_player_phase() -> void:
	cleaner()
	current_phase = battle_phase.player
	refresh_player_minions()
	not_used_minions_this_turn = [] + player_minions
	used_minions_this_turn = []
	next_player_turn()

func begin_enemy_phase() -> void:
	not_used_minions_this_turn = [] + enemy_minions
	used_minions_this_turn = []
	current_phase = battle_phase.enemy

func next_player_turn():
	refresh_player_minions()
	if len(not_used_minions_this_turn) == 0:
		print_debug("End player's round")
		start_enemy_round()
		return
	
	movement_path.clear()
	start_selection_by_module(0)

func start_enemy_round():
	#TODO disconnect things from player turn if any is left
	begin_enemy_phase()
	pass
	
func start_selection_by_module(id: int):
	SelectionModule.start_selection()
	SelectionModule.move_box(not_used_minions_this_turn[id].global_position)

func on_minion_change(side: bool):
	if side:
		selection_index += 1
	else:
		selection_index -= 1
		
	if selection_index < 0:
		selection_index = len(not_used_minions_this_turn) - 1
	elif selection_index >= len(not_used_minions_this_turn):
		selection_index = 0
	
	SelectionModule.move_box(player_minions[selection_index].global_position)

func on_minion_selected(id: int) -> void:
	current_minion = not_used_minions_this_turn[selection_index]
	print_debug(current_minion.name)
	SelectionModule.stop_selection()

func revert_selection():
	#Cofnij miniona do startowego miejsca
	current_minion.active = false
	current_minion = null
	SelectionModule.start_selection()
	
func start_move_minion():
	current_minion.active = true

func stop_move_minion():
	current_minion.active = false

func on_target_selected(target: Node) -> void:
	#Przekazanie pola z grida bo można by atakować też puste pola by zastawiać pułapki itd
	pass

func minion_attack() -> void:
	current_minion.used_this_turn = true
	#TODO make attack current minion -> current_target

func finish_action() -> void:
	
	print_debug(current_minion.name + " " + str(selection_index) + " VS " + str(not_used_minions_this_turn.find(current_minion)))
	
	
	if current_minion:
		not_used_minions_this_turn.remove_at(selection_index)
		used_minions_this_turn.append(current_minion)
	
	cleaner()
	next_player_turn()

func on_action_selected(action: String) -> void:
	if action == "move":
		BattleStateMachine.get_state("Bstate_movement").Enter()
	elif action == "attack":
		BattleStateMachine.get_state("Bstate_player_choose_target").Enter()
	#TODO add later
	#elif action == "end_turn":
		#BattleStateMachine.get_state("Bstate_player_end").Enter()

func on_battle_started() -> void:
	#TODO Dodać logikę startu bitwy
	pass

func on_battle_ended() -> void:
	#TODO Dodać logikę końca bitwy
	pass

func reset_turn_flags() -> void:
	print_debug("New turn")
	for minion in player_minions:
		if minion is Ludzik_gracza:
			minion.used_this_turn = false
	begin_player_phase()
