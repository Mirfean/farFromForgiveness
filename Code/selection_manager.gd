extends Node
class_name selection_module

@export var selection_box: Sprite2D

func start_selection():
	selection_box.visible = true
	
func stop_selection():
	selection_box.visible = false
	selection_box.global_position = Vector2(1000, 1000)

func move_box(pos: Vector2):
	selection_box.global_position = pos
