extends State
class_name IdleState

@export var engaging_position_state: EngagingPositionState
@export var engaging_target_state: EngagingTargetState


func handle_input(event: InputEvent) -> void:
	super.handle_input(event)

	var target_position: Vector2 = zombie.movable.get_target_position()

	if target_position != Vector2.INF:
		engaging_position_state.target = target_position
		change_state(engaging_position_state)


func update(_delta: float) -> void:
	super(_delta)
	if zombie.sight_component.has_unit_in_sight():
		var unit: Area2D = zombie.sight_component.find_closest_unit(zombie.global_position)
		var distance: float = zombie.global_position.distance_to(unit.global_position)

		if distance <= zombie.nav_agent.target_desired_distance * 3:
			return

		engaging_target_state.target = unit
		change_state(engaging_target_state)
