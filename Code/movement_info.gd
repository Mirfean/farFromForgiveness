extends Control

@export var remaining_label: Label
@export var moves_left: Label

signal change_moves

var remaining_moves: int = 0


func _ready() -> void:
	moves_left.text = str(remaining_moves)
	change_moves.connect(update_moves)

func update_moves(value: int) -> void:
	remaining_moves += value
	moves_left.text = str(remaining_moves)
