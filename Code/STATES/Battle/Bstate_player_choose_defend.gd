extends battle_state
class_name Bstate_player_choose_defend

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func Enter():
	print("Defending :3")
	Transitioned.emit(self, "Bstate_player_end_action")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
