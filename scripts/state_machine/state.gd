extends Node
class_name State

var zombie: Zombie


func init(_zombie: Zombie):
	zombie = _zombie


func enter() -> void:
	pass


func exit() -> void:
	pass


func handle_input(_event: InputEvent) -> void:
	if not InputManager.is_game_input_allowed():
		return

	if zombie.is_static:
		return


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass
