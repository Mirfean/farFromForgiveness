extends Ludzik
class_name Ludzik_gracza

func _ready() -> void:
	stats.load_resource(r_stats)
	prepare_eq()
	debug_text.text = "%s/%s" % [stats.hp, stats.max_hp]
	#TODO DODAĆ STARTOWĄ WARTOŚĆ
			
func move(vector: Vector2i):
	var destination = Vector2(vector.x, vector.y) * GLOBAL.grid_size
	raycast.target_position = destination
	raycast.force_raycast_update()
	if not raycast.is_colliding():
		global_position += destination
		update_grid_position(vector)
	else:
		var collider = raycast.get_collider()
		print(collider.name)
	
