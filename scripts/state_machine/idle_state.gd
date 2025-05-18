extends State
class_name IdleState

@export var engaging_position_state: EngagingPositionState
@export var engaging_target_state: EngagingTargetState


func handle_input(event: InputEvent) -> void:
	super.handle_input(event)

	var target_position: Vector2 = unit.movable.get_target_position()

	if target_position != Vector2.INF:
		engaging_position_state.target = target_position
		change_state(engaging_position_state)


func update(_delta: float) -> void:
	super(_delta)

	if unit.sight_component.has_unit_in_sight():
		var closest_unit: Area2D = unit.sight_component.find_closest_unit(unit.global_position)
		var distance: float = unit.global_position.distance_to(closest_unit.global_position)

		# Was here because of bug so I don't know
		#if distance <= unit.nav_agent.target_desired_distance:
			#return

		engaging_target_state.target = closest_unit
		change_state(engaging_target_state)
