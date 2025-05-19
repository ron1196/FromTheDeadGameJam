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

	var target_position: Vector2 = unit.movable.get_target_position()

	if target_position != Vector2.INF:
		unit.nav_agent.target_position = target_position

	if is_interruptible and unit.sight_component.has_unit_in_sight():
		var closest_unit: Area2D = unit.sight_component.find_closest_unit(unit.global_position)

		# Was here because of bug so I don't know
		#var distance: float = unit.global_position.distance_to(closest_unit.global_position)
		#if distance <= unit.nav_agent.target_desired_distance:
			##return

		engaging_target_state.target = closest_unit
		change_state(engaging_target_state)
