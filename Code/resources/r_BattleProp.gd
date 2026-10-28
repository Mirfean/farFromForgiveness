extends Resource
class_name r_BattleProp

@export var sprite: CompressedTexture2D
@export var id: String
@export var name_: String
@export var description: String
@export var power: int
@export var max_range: int
@export var min_range: int = 0
@export var include: GLOBAL.SIDES

@export_category("AREA EFFECT")
@export var area_range: int = 0
@export var area_type: GLOBAL.AREA_TYPE
