extends Node
class_name MovementManager


func _ready() -> void:
	var astargrid = AStarGrid2D.new()
	astargrid.size = Vector2i(32, 32)
	astargrid.cell_size = Vector2i(16, 16)
	astargrid.update()

	print(astargrid.get_id_path(Vector2i(0, 0), Vector2i(3, 4)))
