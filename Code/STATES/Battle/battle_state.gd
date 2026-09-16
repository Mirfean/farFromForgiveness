extends Node
class_name battle_state

signal Transitioned

#Nie dodawać warunków z wracaniem do poprzedniego state
func Enter():
	pass
	
func Exit():
	pass
	
func InputState(_event: InputEvent):
	pass

func Update(_delta: float):
	pass

func PhysicsUpdate(_delta: float):
	pass
