extends Node
class_name weapon_info

@export var damage: int
@export var range: int
@export var min_range: int = 0
@export var attack_type: String
@export var penetration: int

func load_resource(weapon: r_weapon):
	damage = weapon.damage
	range = weapon.range
	min_range = weapon.range
	attack_type = weapon.attack_type
	penetration = weapon.penetration
