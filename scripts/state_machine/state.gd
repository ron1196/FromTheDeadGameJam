extends Node
class_name State

var zombie: Unit


func change_state(new_state: State) -> void:
	zombie.state_machine.current_state = new_state


func init(_zombie: Zombie):
	zombie = _zombie


func enter() -> void:
	pass


func exit() -> void:
	pass


func handle_input(_event: InputEvent) -> void:
	if not InputManager.is_game_input_allowed():
		return


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass
