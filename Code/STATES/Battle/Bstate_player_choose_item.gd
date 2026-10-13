extends battle_state
class_name Bstate_player_choose_item

signal item_chosen

@export var itemWindow: items_select_window

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	itemWindow.item_selected.connect(item_selected)

func Enter():
	print("There should be a menu to choose item :>")
	itemWindow.show()
	Transitioned.emit(self, "Bstate_player_choose_target")

func item_selected(id: int):
	item_chosen.emit(id)

func update_itemWindow(items: Array[BattleItem]):
	itemWindow.UpdateItems(items)

func Exit():
	itemWindow.hide()
