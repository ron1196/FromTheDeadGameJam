extends State
class_name MovableState

var velocity: Vector2

var _frame_counter: int = 0
var _calc_next_path_frames_interval: int = 7
var _current_path_position: Vector2

@export var idle_state: State


func enter() -> void:
	zombie.nav_agent.velocity_computed.connect(_on_navigation_velocity_computed)


func exit() -> void:
	zombie.nav_agent.velocity_computed.disconnect(_on_navigation_velocity_computed)


func physics_update(_delta: float) -> void:
	if zombie.nav_agent.is_navigation_finished():
		zombie.state_machine.current_state = idle_state
		return

	_frame_counter += 1

	if _frame_counter % _calc_next_path_frames_interval == 0:
		_frame_counter = 0
		_current_path_position = zombie.nav_agent.get_next_path_position()

	var direction = zombie.global_position.direction_to(_current_path_position)
	direction = direction.normalized()
	zombie.nav_agent.set_velocity(direction * zombie.speed)


func _on_navigation_velocity_computed(safe_velocity: Vector2) -> void:
	if safe_velocity.length() > 0:
		velocity = safe_velocity
		zombie.position += velocity * get_physics_process_delta_time()
