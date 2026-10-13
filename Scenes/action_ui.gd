extends Control
class_name action_ui

signal action_selected(String)

@export var button_attack: TextureButton
@export var button_item: TextureButton
@export var button_defend: TextureButton
@export var button_interact: TextureButton #TODO Dodać to później

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_attack_pressed() -> void:
	action_selected.emit("ATTACK")


func _on_use_item_pressed() -> void:
	action_selected.emit("ITEM")


func _on_defend_pressed() -> void:
	action_selected.emit("DEFEND")
