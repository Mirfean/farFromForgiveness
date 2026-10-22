extends PropObject
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

var tags: Array[BattleItemTag]
var max_usages: int
var remaining_usages: int

func set_item(res: r_BattleItem):
	sprite = res.sprite
	id = res.id
	name_ = res.name_
	description = res.description
	power = res.power
	tags = res.tags
	max_usages = res.max_usages
	min_range = res.min_range
	max_range = res.max_range
	
	if res.remaining_usages != 0:
		remaining_usages = res.remaining_usages
	else:
		remaining_usages = max_usages

func use(value: int = -1) -> bool:
	remaining_usages = maxi(remaining_usages+value, max_usages)
	if remaining_usages <= 0:
		return false
	return true
