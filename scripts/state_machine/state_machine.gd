extends Node
class_name StateMachine

@export var debug: bool = false

@export var default_state: State
var current_state: State:
	set(new_state):
		if new_state == null:
			push_warning("Trying to set null state for " + name)
			return

		if current_state == new_state:
			return

		if current_state != null:
			if debug:
				print(zombie.name + " exit state " + current_state.name)

			current_state.exit()

		current_state = new_state

		if debug:
			print(zombie.name + " enter state " + current_state.name)

		current_state.enter()

@export var zombie: Zombie


func _ready() -> void:
	for state in get_children():
		if state as State:
			state.init(zombie)

	if zombie.is_static:
		return

	current_state = default_state


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
