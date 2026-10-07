extends Node
class_name BattleActionManager

enum ActionType # Dodać więcej później
{
	NONE = -1, # Default akcja, ma do niej wracać po resecie/zmianie. Przy akcjach jeśli to jest ta, ignor i debug info dać
	ATTACK = 1,
	ITEM = 2,
	DEFEND = 3
}	

signal ActionSelected(ActionType)

var CurrentAction: ActionType

func setCurrentAction(value: int):
	CurrentAction = value

#EJ TO CHYBA POWINNO BYĆ W BState XD

func PerformAction():
	match CurrentAction:
		ActionType.ATTACK:
			#TODO Tu jeszcze trzeba dać wybór broni :>
			pass
		ActionType.ITEM:
			#TODO Tu jeszcze pomiędzy tym a choose target trzeba dać wybór itema 
			pass
		ActionType.DEFEND:
			#TODO A tu chillera w sumie (Jeśli będę dawał obracanie na koniec tury to może jeszcze to)
			pass
		_:
			print_debug("None or unsupported action")
	pass
