extends Node
class_name BattleItemPreparer

@export_group("DEBUG")
@export var turnMan: BattleTurnManager


func prepare_items(minion_items: Dictionary, minions: Array):
	if GLOBAL.DEBUG:
		minion_items = DEBUG_create_list()
	for minion in minion_items:
		var index = -1
		for minio in minions:
			if minio.id == minion.id:
				index = minions.find(minio)
		if index != -1:
			for item in minion_items[minion]:
				minions[index].equipment.append(create_item_from_resource(item))
			

func create_item_from_resource(item_info: r_BattleItem) -> BattleItem:
	var new_item = BattleItem.new()
	new_item.set_item(item_info)
	return new_item


func DEBUG_create_list() -> Dictionary:
	var debug_items = {}
	var potek = load("res://Resources/items/heal_potion.tres")
	
	debug_items[turnMan.player_minions[0]] = [potek, potek]
	debug_items[turnMan.player_minions[1]] = [potek]
	
	return debug_items
