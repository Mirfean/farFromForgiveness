extends Node
class_name BattleItemsManager

@export var itemWindow: items_select_window

signal itemSelected

func _ready() -> void:
	itemWindow.item_selected.connect(item_selected)

func show_items(items: Array[BattleItem]):
	if not itemWindow.open_items(items):
		print_debug("0 items in eq")
		return
	itemWindow.open_items(items)
		

func item_selected(id: int):
	itemSelected.emit(id)
