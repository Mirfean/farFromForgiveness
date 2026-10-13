extends Node
class_name BattleItem

enum BattleItemTag
{
	Healing,
	Support,
	Offensive,
	Classic_weapon, #TODO zmienić tą nazwę później
	Bomb,
	Faith,
	Magic
}

var sprite: CompressedTexture2D
var id: String
var name_: String
var description: String
var tag: Array[BattleItemTag]
var max_usages: int
var remaining_usages: int

func set_item(res: r_BattleItem):
	sprite = res.sprite
	id = res.id
	name_ = res.name_
	description = res.description
	tag = res.tag
	max_usages = res.max_usages
	
	if res.remaining_usages != 0:
		remaining_usages = res.remaining_usages
	else:
		remaining_usages = max_usages

func use(value: int = -1) -> bool:
	remaining_usages = maxi(remaining_usages+value, max_usages)
	if remaining_usages <= 0:
		return false
	return true
