extends Node
class_name BattleAttackManager

func preview_attack(attacker: Ludzik_gracza,chosen_attack: String, defender: Ludzik_gracza):
	#TODO chosen attack jakoś później rozkminić
	var attacker_weapon = attacker.stats.weapon_stats
	var defender_weapon = defender.stats.weapon_stats
	calculate_damage()



func calculate_damage():
	print_debug("calculating dmg...")

#TODO Może te dane będą wysyłane przy preview?
func perform_attack(attacker: Ludzik_gracza,chosen_attack: String, defender: Ludzik_gracza):
	var attacker_weapon = attacker.stats.weapon_stats
	var defender_weapon = defender.stats.weapon_stats
	defender.modify_hp(-attacker_weapon.damage)
	attacker.modify_hp(-defender_weapon.damage)
	print("Hp after attack %s/%s vs %s/%s" % [attacker.stats.hp,attacker.stats.max_hp, defender.stats.hp, defender.stats.max_hp])
