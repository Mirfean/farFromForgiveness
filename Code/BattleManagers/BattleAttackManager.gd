extends Node
class_name BattleAttackManager

func preview_attack(attacker: Ludzik,chosen_attack: String, defender: Ludzik):
	#TODO chosen attack jakoś później rozkminić
	var attacker_weapon = attacker.stats.weapon_stats
	var defender_weapon = defender.stats.weapon_stats
	calculate_damage()

func calculate_damage():
	print_debug("calculating dmg...")

#TODO Może te dane będą wysyłane przy preview?
func perform_attack(attacker: Ludzik_gracza,chosen_attack: String, defender: Ludzik):
	if defender:
		var attacker_weapon = attacker.stats.weapon_stats
		var defender_weapon = defender.stats.weapon_stats
		defender.modify_hp(-attacker_weapon.power)
		attacker.modify_hp(-defender_weapon.power)
		print("Hp after attack %s/%s vs %s/%s" % [attacker.stats.hp,attacker.stats.max_hp, defender.stats.hp, defender.stats.max_hp])
	else:
		print_debug("Hitting empty space")

#TODO Dodać żeby móc to robić na puste pola później?
func perform_item(user: Ludzik, item: BattleItem, target: Ludzik) -> bool:
	var item_after_mods = item
	#TODO Klasa postaci jak medyk czy bomber ma wpływ
	#TODO Rodzaj itemu też może mieć znaczenie względem samego efektu
	
	#TODO Tutaj rzeczy które można rzucić na puste pole, bez przeciwnika
	
	if not target:
		return false
	
	#Healing
	if item_after_mods.tags.has(BattleItem.BattleItemTag.Healing):
		target.modify_hp(item_after_mods.power)
	
	item.use()
	return true
