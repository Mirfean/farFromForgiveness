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

func open_items(item_icons: Array[Texture2D]) -> void:
	for index in range(mini(item_grid.get_child_count(), MAX_ITEMS)):
		var button := item_grid.get_child(index) as TextureButton
		var has_item := index < item_icons.size()
		button.visible = has_item
		button.disabled = not has_item
		button.texture_normal = item_icons[index] if has_item else null

	selection_window.popup_centered()

func _on_item_pressed(index: int) -> void:
	item_selected.emit(index)
	print("Siema " + str(index))
	selection_window.hide()
