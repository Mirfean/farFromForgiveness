extends PropObject
class_name weapon_info

@export var attack_type: String
@export var penetration: int

func load_resource(weapon: r_weapon):
	power = weapon.power
	max_range = weapon.max_range
	min_range = weapon.min_range
	attack_type = weapon.attack_type
	penetration = weapon.penetration
