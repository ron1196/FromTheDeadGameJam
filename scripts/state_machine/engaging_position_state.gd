extends MovingState
class_name EngagingPositionState

var target: Vector2 = Vector2.INF


func get_target_position() -> Vector2:
	return target


func on_navigation_finished() -> State:
	return idle_state


func exit() -> void:
	super()
	target = Vector2.INF


func handle_input(event: InputEvent) -> void:
	super(event)

	var target_position: Vector2 = unit.movable.get_target_position()

	if target_position != Vector2.INF:
		unit.nav_agent.target_position = target_position
