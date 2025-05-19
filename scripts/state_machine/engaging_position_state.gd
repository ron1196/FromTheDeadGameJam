extends MovingState
class_name EngagingPositionState

@export var engaging_target_state: EngagingTargetState

@export var is_interruptible: bool

var target: Vector2 = Vector2.INF


func get_target_position() -> Vector2:
	return target


func on_navigation_finished() -> State:
	return idle_state


func exit() -> void:
	super()
	target = Vector2.INF


func update(delta: float) -> void:
	super(delta)

	if _try_moving(): return

	var distance_from_start: float = unit.global_position.distance_to(unit.start_position)
	var is_too_far: bool = distance_from_start >= unit.max_distance_from_start

	if not is_too_far and is_interruptible:
		if _try_attack():
			return


func _try_moving() -> bool:
	var target_position: Vector2 = unit.movable.get_target_position()

	if _try_move_to_position(target_position):
		return true

	return false


func _try_attack() -> bool:
	if not unit.sight_component.has_unit_in_sight(): return false
	var closest_unit: Area2D = unit.sight_component.find_closest_unit(unit.global_position)
	engaging_target_state.target = closest_unit
	change_state(engaging_target_state)
	return true


func _try_move_to_position(pos: Vector2) -> bool:
	if pos != Vector2.INF:
		unit.nav_agent.target_position = pos
		return true

	return false
