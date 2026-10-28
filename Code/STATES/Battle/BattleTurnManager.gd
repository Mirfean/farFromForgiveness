@icon("res://addons/at-icons/node/node_graph_root.svg")
extends Node
class_name BattleTurnManager

enum battle_phase {
	start,
	player,
	enemy,
	neutral,
	end
}

@export var BattleStateMachine: State_Factory_Battle
@export var movementManager: MovementManager
@export var mapManager: MapManager
@export var attackManager: BattleAttackManager
@export var selectionModule: selection_module

@export_category("Items")
@export var ItemManager: BattleItemsManager
@export var ItemPreparer: BattleItemPreparer
@export var Minion_Items: Dictionary = {}

var current_phase: battle_phase = battle_phase.player

var current_minion: Ludzik
var CURRENT_ACTION: String
var current_prop: PropObject
var current_target_position: Vector2i
var current_target: Ludzik

var selection_index: int = 0

@export_category("Minions")
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
	ItemPreparer.prepare_items(Minion_Items, player_minions)

func connect_state_signals() -> void:
	if not BattleStateMachine:
		return
	
	if movementManager:
		movementManager.MoveCurrentMinion.connect(move_minion)
		
	ItemManager.itemSelected.connect(item_selected)
	
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
		if choose_target_state.has_signal("moved_to"):
			choose_target_state.moved_to.connect(show_affected_cells)
				
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
		if minion is Ludzik:
			selectable_minions.append(minion)
			minion.used_this_turn = false

func refresh_enemy_minions() -> void:
	print_debug("Refresh enemies")
	enemy_minions = EnemyContainer.get_children()
	for minion in enemy_minions:
		if minion is Ludzik:
			selectable_minions.append(minion)
			minion.used_this_turn = false

func cleaner():
	current_minion = null
	current_target_position = Vector2i(-4444,-5555)
	movementManager.cleaner()
	selection_index = 0

func begin_player_phase() -> void:
	cleaner()
	current_phase = battle_phase.player
	refresh_player_minions()
	#TODO Zastanowić się czy to ma tutaj zostać, na razie dla debugu git
	refresh_enemy_minions()
	minions_this_turn = mapManager.set_grid_positions(player_minions)
	update_grid_pos_for_selection(minions_this_turn)
	#update_grid_pos_for_all()
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
	movementManager.revertMovement()
	movementManager.cleaner()
	current_minion = null
	selectionModule.start_selection()
	
func start_move_minion():
	if current_minion == movementManager.current_minion:
		print_debug("Some backing?")
		return
	movementManager.setup_new_minion(current_minion)
	movementManager.highlight_movement_range(current_minion.grid_position, current_minion.movement)

func move_minion(move: Vector2i):
	current_minion.move(move)
	
func stop_move_minion():
	var minions_on_pos = check_minion_on_position(current_minion.grid_position)
	if minions_on_pos.size() > 1:
		print_debug("No, you can't stay here, move along!")
	else:
		#TODO Poprawić to później żeby nie było takie ble
		BattleStateMachine.get_state("Bstate_movement").confirmDestination()

func on_target_selected(target: Vector2i) -> void:
	#Przekazanie pola z grida bo można by atakować też puste pola by zastawiać pułapki itd
	current_target_position = target
	var target_object = check_minion_on_position(current_target_position)
	if target_object.size() > 0:
		current_target = target_object[0]
		
func minion_attack() -> void:
	current_minion.used_this_turn = true
	match CURRENT_ACTION:
		"ATTACK":
			attackManager.perform_attack(current_minion, "", current_target)
		"ITEM":
			if attackManager.perform_item(current_minion, current_prop, current_target):
				print("Success item use")
			else:
				print("Incorrent item use")

func finish_action() -> void:
	if selectable_minions.has(current_minion):
		selectable_minions.erase(current_minion)
	minions_this_turn.erase(current_minion)
	
	cleaner()
	next_player_turn()

func on_action_selected(action: String) -> void:
	match action:
		"MOVE":
			BattleStateMachine.get_state("Bstate_movement").Enter()
		"ATTACK":
			CURRENT_ACTION = "ATTACK"
			print_debug("ATTACK")
			#TODO Przerzucić to później do wyboru broni(jeśli więcej niż jedna)
			current_prop = current_minion.stats.weapon_stats
			show_targetable()
		"ITEM":
			CURRENT_ACTION = "ITEM"
			show_items()
		"END_TURN":
			print("Koniec rundy")
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
		if minion is Ludzik:
			minion.used_this_turn = false
	begin_player_phase()
	
#func update_grid_pos_for_all():
	#var p_minions = mapManager.set_grid_positions(player_minions)
	#var e_minions = mapManager.set_grid_positions(enemy_minions)
	#for key in p_minions:
		#var index = selectable_minions.find(p_minions[key])
		#if index >= 0:
			#player_minions[index].grid_position.x = key.x
			#player_minions[index].grid_position.y = key.y
	#for key in e_minions:
		#var index = selectable_minions.find(e_minions[key])
		#if index >= 0:
			#enemy_minions[index].grid_position.x = key.x
			#enemy_minions[index].grid_position.y = key.y
	
func update_grid_pos_for_selection(minions: Dictionary):
	for key in minions:
		var indexik = selectable_minions.find(minions[key])
		if indexik >= 0:
			selectable_minions[indexik].grid_position.x = key.x
			selectable_minions[indexik].grid_position.y = key.y

func get_targetable() -> Array:
	# TODO Wziąć od gracza zasięg broni
	var max_range = current_prop.max_range
	var min_range = current_prop.min_range
	var reachable_cells = calculate_reachable_cells(current_minion.grid_position, max_range, min_range)
	print(reachable_cells)
	mapManager.draw_range(reachable_cells, MapManager.tilemap_type.path, MapManager.highlight_type.target)
	return reachable_cells

func calculate_reachable_cells(minion_pos: Vector2i, max_range: int, min_range: int) -> Array[Vector2i]:
	var result = {}
	for x in range(-max_range, max_range+1):
		for y in range(-max_range, max_range+1):
			var distance = abs(x) + abs(y)
			if distance >= min_range and distance <= max_range:
				result[Vector2i(minion_pos.x+x,minion_pos.y+y)] = true
	return result.keys() as Array[Vector2i]

func check_minion_on_position(position: Vector2i) -> Array[Ludzik]:
	var minions_on_pos = [] as Array[Ludzik]
	for p_minion in player_minions:
		if p_minion.grid_position == position:
			minions_on_pos.append(p_minion)
	for e_minion in enemy_minions:
		if e_minion.grid_position == position:
			minions_on_pos.append(e_minion)
	return minions_on_pos
	
func show_affected_cells(cell: Vector2i):
	print("Showing affected")
	mapManager.draw_range([cell], MapManager.tilemap_type.affected, MapManager.highlight_type.affected)

#region Items

func show_items():
	print("Pokaz mi swoje towary")
	ItemManager.show_items(current_minion.equipment)

func item_selected(id: int):
	current_prop = current_minion.equipment[id]
	show_targetable()

#endregion
