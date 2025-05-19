extends State
class_name IdleState

@export var engaging_position_state: EngagingPositionState
@export var engaging_target_state: EngagingTargetState


func update(_delta: float) -> void:
	super(_delta)

	var distance_from_start: float = unit.global_position.distance_to(unit.start_position)
	var is_too_far: bool = distance_from_start >= unit.max_distance_from_start

	if is_too_far:
		if _try_move(): return
		_try_move_to_position(unit.start_position)

	else:
		if _try_attack(): return
		if _try_move(): return


func _try_move() -> bool:
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
		engaging_position_state.target = pos
		change_state(engaging_position_state)
		return true

	return false
