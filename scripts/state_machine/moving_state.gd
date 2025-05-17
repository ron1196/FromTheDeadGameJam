extends MovableState


func handle_input(event: InputEvent) -> void:
	if zombie.is_selected && event.is_action_pressed(Globals.INPUT_COMMAND):
		var mouse_position: Vector2 = zombie.get_global_mouse_position()
		zombie.nav_agent.target_position = mouse_position
