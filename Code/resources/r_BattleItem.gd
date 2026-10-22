extends r_BattleProp
class_name r_BattleItem

@export var tags: Array[BattleItem.BattleItemTag]
@export var max_usages: int

#Tylko do serializacji później
@export var remaining_usages: int
