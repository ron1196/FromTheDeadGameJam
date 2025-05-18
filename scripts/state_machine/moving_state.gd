extends State
class_name MovingState

@export var idle_state: IdleState

var velocity: Vector2

var _frame_counter: int = 0
var _calculate_next_path_interval: int = 7
var _current_path_position: Vector2

var _reach_target_timer: float = 0.0
var _reach_target_timer_scale: float = 2.5
var _reach_target_stuck_duration: float = 0.7


func get_target_position() -> Vector2:
	return Vector2.INF


func on_navigation_finished() -> State:
	return null


func enter() -> void:
	super()
	var target: Vector2 = get_target_position()

	if target == Vector2.INF:
		push_warning("Movable without target, going to idle!")
		change_state(idle_state)
		return

	unit.nav_agent.velocity_computed.connect(_on_navigation_velocity_computed)
	unit.nav_agent.path_changed.connect(_on_path_changed)

	unit.nav_agent.target_position = target


func exit() -> void:
	super()
	unit.nav_agent.velocity_computed.disconnect(_on_navigation_velocity_computed)
	unit.nav_agent.path_changed.disconnect(_on_path_changed)


func update(delta: float) -> void:
	if unit.nav_agent.is_navigation_finished():
		on_target_reached()

	# Check if stuck (no progress for 1 second)
	var distance_to_target: float = unit.nav_agent.distance_to_target()

	if distance_to_target <= unit.nav_agent.target_desired_distance * _reach_target_timer_scale:
		# Progress check - if we're not getting closer
		if distance_to_target < unit.nav_agent.distance_to_target():
			_reach_target_timer = 0.0 # Reset if making progress
		else:
			_reach_target_timer += delta

			if _reach_target_timer >= _reach_target_stuck_duration:
				_handle_stuck_situation()


func physics_update(_delta: float) -> void:
	super(_delta)

	_frame_counter += 1

	if _frame_counter % _calculate_next_path_interval == 0:
		_frame_counter = 0
		_current_path_position = unit.nav_agent.get_next_path_position()

	var direction = unit.global_position.direction_to(_current_path_position)
	direction = direction.normalized()
	unit.nav_agent.set_velocity(direction * unit.get_speed())


func on_target_reached() -> void:
	var new_state: State = on_navigation_finished()

	if new_state != null:
		change_state(new_state)


func _handle_stuck_situation() -> void:
	on_target_reached()


## Reset timer whenever path updates
func _on_path_changed():
	_reach_target_timer = 0.0


func _on_navigation_velocity_computed(safe_velocity: Vector2) -> void:
	if safe_velocity.length() > 0:
		velocity = safe_velocity
		unit.position += velocity * get_physics_process_delta_time()
