extends Node
class_name State

var unit: Unit


func change_state(new_state: State) -> void:
	unit.state_machine.current_state = new_state


func init(_unit: Unit):
	unit = _unit


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
