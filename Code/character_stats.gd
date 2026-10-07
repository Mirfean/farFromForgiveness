extends Node2D
class_name character_stats

@export var hp: int
@export var movement: int
@export var additional_movement: int
@export var attack: int
@export var defence: int
@export var crit_chance: float
@export var weapon_stats: weapon_info

func load_resource(stats: r_character_stats):
	hp = stats.hp
	movement = stats.movement
	additional_movement = stats.additional_movement
	attack = stats.attack
	defence = stats.defence
	crit_chance = stats.crit_chance
	weapon_stats.load_resource(stats.weapon)
	
