extends Control
class_name items_select_window

signal item_selected(index: int)


const MAX_ITEMS := 6

@export var selection_window: Window
@export var item_grid: GridContainer

func _ready() -> void:
	for index in range(mini(item_grid.get_child_count(), MAX_ITEMS)):
		var button := item_grid.get_child(index) as TextureButton
		button.pressed.connect(_on_item_pressed.bind(index))

	selection_window.close_requested.connect(selection_window.hide)
	selection_window.hide()

func open_items(items: Array[BattleItem]) -> void:
	for index in range(0, MAX_ITEMS-1):
		var button := item_grid.get_child(index) as TextureButton
		var has_item = items[index]
		button.visible = has_item
		button.disabled = not has_item
		button.texture_normal = items[index].sprite if has_item else null
	selection_window.popup_centered()

func _on_item_pressed(index: int) -> void:
	item_selected.emit(index)
	print("Siema " + str(index))
	selection_window.hide()
	
#Tylko przy X
func _on_window_close_requested() -> void:
	print("Closing items backpack!")
	
