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
