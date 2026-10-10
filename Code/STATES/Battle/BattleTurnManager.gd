extends Node
class_name BattleTurnManager

enum battle_phase {
	player,
	enemy,
	neutral
}

@export var BattleStateMachine: State_Factory_Battle
@export var movementManager: MovementManager
@export var mapManager: MapManager
@export var attackManager: BattleAttackManager
@export var selectionModule: selection_module

var current_phase: battle_phase = battle_phase.player

var current_minion: Ludzik_gracza = null #TODO Dodać później wspólnego parenta dla wszystkich ludków

var current_target_position: Vector2i
var current_target: Ludzik_gracza #TODO Ta, tutaj też zmienic

var selection_index: int = 0

@export var PlayerContainer: Node
var player_minions: Array = []

@export var EnemyContainer: Node
var enemy_minions: Array = []

var minions_this_turn: Dictionary
var selectable_minions: Array

var movement_path: Array = []

func _ready() -> void:
	connect_state_signals()
	begin_player_phase()

func connect_state_signals() -> void:
	if not BattleStateMachine:
		return
	
	if movementManager:
		movementManager.MoveCurrentMinion.connect(move_minion)
	
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
	if choose_target_state: 
		if choose_target_state.has_signal("target_selected"):
			choose_target_state.target_selected.connect(on_target_selected)
		if choose_target_state.has_signal("show_targets"):
			choose_target_state.show_targets.connect(show_targetable)
				
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
			selectable_minions.append(minion)
			minion.used_this_turn = false

func refresh_enemy_minions() -> void:
	print_debug("Refresh enemies")
	
	
	#TODO the rest xD

func cleaner():
	current_minion = null
	current_target_position = Vector2i(-4444,-5555)
	movementManager.cleaner()
	selection_index = 0

func begin_player_phase() -> void:
	cleaner()
	current_phase = battle_phase.player
	refresh_player_minions()
	minions_this_turn = mapManager.set_grid_positions(player_minions)
	update_grid_pos_for_selection()
	#used_minions_this_turn = []
	next_player_turn()

func begin_enemy_phase() -> void:
	#minions_this_turn = [] + enemy_minions
	#used_minions_this_turn = []
	current_phase = battle_phase.enemy

func next_player_turn():
	if len(minions_this_turn) == 0:
		print_debug("End player's round")
		start_enemy_round()
		return
	
	movement_path.clear()
	cleaner()
	start_selection_by_module(0)

func start_enemy_round():
	#TODO disconnect things from player turn if any is left
	begin_enemy_phase()
	pass
	
	
func start_selection_by_module(id: int):
	selectionModule.start_selection()
	selectionModule.move_box(selectable_minions[0].global_position)

func on_minion_change(side: bool):
	if side:
		selection_index += 1
	else:
		selection_index -= 1
		
	if selection_index < 0:
		selection_index = len(selectable_minions) - 1
	elif selection_index >= len(selectable_minions):
		selection_index = 0
	
	selectionModule.move_box(selectable_minions[selection_index].global_position)

func on_minion_selected(id: int) -> void:
	current_minion = selectable_minions[selection_index]
	print_debug(current_minion.name)
	selectionModule.stop_selection()

func revert_selection():
	#TODO Cofnij miniona do startowego miejsca
	current_minion = null
	selectionModule.start_selection()
	
func start_move_minion():
	movementManager.setup_new_minion(current_minion)
	movementManager.highlight_movement_range(current_minion.grid_position, current_minion.movement)

func move_minion(move: Vector2i):
	current_minion.move(move)
	
func stop_move_minion():
	print("stop moving minion")

func on_target_selected(target: Vector2i) -> void:
	#Przekazanie pola z grida bo można by atakować też puste pola by zastawiać pułapki itd
	current_target_position = target
	var target_object = check_minion_on_position(current_target_position)
	if target_object:
		current_target = target_object
		
func minion_attack() -> void:
	current_minion.used_this_turn = true
	attackManager.perform_attack(current_minion, "", current_target)

func finish_action() -> void:
	if selectable_minions.has(current_minion):
		selectable_minions.erase(current_minion)
	minions_this_turn.erase(current_minion)
	
	cleaner()
	next_player_turn()

func on_action_selected(action: String) -> void:
	if action == "move":
		BattleStateMachine.get_state("Bstate_movement").Enter()
	elif action == "Attack":
		#Brzydkie i bez sensu - do poprawy
		print("Attack start")
	#TODO add later
	#elif action == "end_turn":
		#BattleStateMachine.get_state("Bstate_player_end").Enter()

func clear_targetable():
	mapManager.tilemap_ui.clear()

func show_targetable():
	var target_state: Bstate_player_choose_target = BattleStateMachine.get_state("Bstate_player_choose_target")
	target_state.setup_targeting(mapManager, selectionModule, get_targetable())

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
	
func update_grid_pos_for_selection():
	for key in minions_this_turn:
		var indexik = selectable_minions.find(minions_this_turn[key])
		if indexik >= 0:
			selectable_minions[indexik].grid_position.x = key.x
			selectable_minions[indexik].grid_position.y = key.y

func get_targetable() -> Array:
	# TODO Wziąć od gracza zasięg broni
	var weapon_range = current_minion.stats.weapon_stats.range
	var weapon_min_range = current_minion.stats.weapon_stats.min_range
	# TODO Zgarnąć wszystkie pola wokół do tego zasięgu (ogarnąć czy przy range broni zabrać zasięg 1 itd)
	var reachable_cells = calculate_reachable_cells(current_minion.grid_position, weapon_range, weapon_min_range)
	# TODO Sprawdzić czy na polach są ściany albo goście co blokują atak za nimi(i jakoś to policzyć powodzenia dla mnie xD)
	# TODO wysłać listę wszystkich dostępnych pól albo stąd je brać? Nie jestem jeszcze pewien
	print(reachable_cells)
	mapManager.draw_targeting_range(reachable_cells)
	return reachable_cells

func calculate_reachable_cells(minion_pos: Vector2i, max_range: int, min_range: int) -> Array[Vector2i]:
	var result = {}
	for x in range(-max_range, max_range+1):
		for y in range(-max_range, max_range+1):
			if x==0 and y==0:
				continue
			var distance = abs(x) + abs(y)
			if distance >= min_range and distance <= max_range:
				result[Vector2i(minion_pos.x+x,minion_pos.y+y)] = true
	return result.keys() as Array[Vector2i]

func check_minion_on_position(position: Vector2i) -> Ludzik_gracza:
	for p_minion in player_minions:
		if p_minion.grid_position == position:
			return p_minion
	for e_minion in enemy_minions:
		if e_minion.grid_position == position:
			return e_minion
	return null
