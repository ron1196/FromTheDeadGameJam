extends State

@export var moving_state: State


func enter() -> void:
	pass


func exit() -> void:
	pass


func handle_input(event: InputEvent) -> void:
	super.handle_input(event)
	if zombie.is_selected && event.is_action_pressed(Globals.INPUT_COMMAND):
		zombie.state_machine.current_state = moving_state
		var mouse_position: Vector2 = zombie.get_global_mouse_position()
		zombie.nav_agent.target_position = mouse_position


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass
