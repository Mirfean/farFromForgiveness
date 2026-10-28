extends Ludzik
class_name Ludzik_oponent

func _ready() -> void:
	stats.load_resource(r_stats)
	prepare_eq()
	debug_text.text = "%s/%s" % [stats.hp, stats.max_hp]
