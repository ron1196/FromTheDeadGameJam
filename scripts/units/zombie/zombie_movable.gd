extends Movable
class_name ZombieMovable

var is_selected: bool = false


func select() -> void:
	is_selected = true


func deselect() -> void:
	is_selected = false


func get_target_position() -> Vector2:
	if not is_selected:
		return Vector2.INF

	if not Input.is_action_just_pressed(Globals.INPUT_COMMAND):
		return Vector2.INF

	return get_global_mouse_position()
