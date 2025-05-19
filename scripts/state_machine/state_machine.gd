extends Node
class_name StateMachine

@export var debug: bool = false

@export var default_state: State
var current_state: State:
	set(new_state):
		if current_state == new_state:
			return

		if current_state != null:
			if debug: print(unit.name + " exit state " + current_state.name)
			current_state.exit()

		current_state = new_state

		if current_state == null:
			if debug: print(unit.name + " enter state null")
			return

		if debug: print(unit.name + " enter state " + current_state.name)
		current_state.enter()

@export var unit: Unit


func _ready() -> void:
	for state in get_children():
		if state as State:
			state.init(unit)

	current_state = default_state


func is_idle() -> bool:
	return current_state == default_state


func enable() -> void:
	current_state = default_state


func disable() -> void:
	current_state = null


func _unhandled_input(event: InputEvent) -> void:
	if current_state == null:
		return

	current_state.handle_input(event)


func _process(delta: float) -> void:
	if current_state == null:
		return

	current_state.update(delta)


func _physics_process(delta: float) -> void:
	if current_state == null:
		return

	current_state.physics_update(delta)
