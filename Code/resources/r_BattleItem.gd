extends Resource
class_name r_BattleItem

@export var sprite: CompressedTexture2D
@export var id: String
@export var name_: String
@export var description: String
@export var tag: Array[BattleItem.BattleItemTag]
@export var max_usages: int

#Tylko do serializacji później
@export var remaining_usages: int
