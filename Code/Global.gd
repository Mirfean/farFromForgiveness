extends Node

var grid_size = 16
var DEBUG = true



### DEBUG ###

var debug_battle_state_text: RichTextLabel
func debug_battle_state(value: String):
	if not debug_battle_state_text:
		debug_battle_state_text = get_tree().get_first_node_in_group("DEBUG_BattleState")
	
	debug_battle_state_text.text = value
