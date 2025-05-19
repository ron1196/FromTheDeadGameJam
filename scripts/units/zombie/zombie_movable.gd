extends Movable
class_name ZombieMovable


func get_target_position() -> Vector2:
	var zombie: Zombie = unit

	if not zombie.is_selected:
		return Vector2.INF

	if not Input.is_action_just_pressed(Globals.INPUT_COMMAND):
		return Vector2.INF

	return get_global_mouse_position()
