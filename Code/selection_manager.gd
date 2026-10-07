extends Node
class_name selection_module

@export var selection_box: Sprite2D
@export var target_box: Sprite2D

@export var state_choose_target: Bstate_player_choose_target

func _ready() -> void:
	if not state_choose_target:
		state_choose_target = get_parent().find_children("*", "Bstate_player_choose_target")[0]
	state_choose_target.next_target.connect(select_target_keyboard)

func start_selection():
	selection_box.visible = true
	
func stop_selection():
	selection_box.visible = false
	selection_box.global_position = Vector2(1000, 1000)

func move_box(pos: Vector2):
	selection_box.global_position = pos

func select_target_keyboard(direction: Vector2i):
	print("keyboard click :>")
