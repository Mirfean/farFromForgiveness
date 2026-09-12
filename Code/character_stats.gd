extends Node2D
class_name character_stats

@export var hp: int
@export var movement: int
@export var attack: int

func load_resource(stats: r_character_stats):
	hp = stats.hp
	movement = stats.movement
	attack = stats.attack
