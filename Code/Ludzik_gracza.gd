extends CharacterBody2D
class_name Ludzik_gracza

const inputs = {
	"move_right": Vector2.RIGHT,
	"move_left": Vector2.LEFT,
	"move_down": Vector2.DOWN,
	"move_up": Vector2.UP
}

@export var active: bool
@export var used_this_turn: bool = false


@export var raycast: RayCast2D
@export var stats: character_stats
@export var r_stats: r_character_stats

func _ready() -> void:
	stats.load_resource(r_stats)

func _unhandled_input(event: InputEvent) -> void:
	if active:
		for action in inputs.keys():
			if event.is_action_pressed(action):
				move(action)
			
func move(action):
	var destination = inputs[action] * GLOBAL.grid_size
	raycast.target_position = destination
	raycast.force_raycast_update()
	if not raycast.is_colliding():
		position += destination
	else:
		var collider = raycast.get_collider()
		print(collider.name)
