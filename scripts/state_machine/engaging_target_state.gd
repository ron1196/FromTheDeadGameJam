extends MovingState
class_name EngagingTargetState

@export var engaging_position_state: EngagingPositionState
@export var attacking_state: AttackingState

var target: Area2D = null


func get_target_position() -> Vector2:
	if target == null:
		return Vector2.INF

	return target.global_position


func exit() -> void:
	super()
	target = null


func handle_input(event: InputEvent) -> void:
	super.handle_input(event)

	var target_position: Vector2 = unit.movable.get_target_position()

	if target_position != Vector2.INF:
		engaging_position_state.target = target_position
		change_state(engaging_position_state)


func on_navigation_finished() -> State:
	if not is_instance_valid(target):
		return idle_state

	if target as HurtboxComponent:
		attacking_state.target = target

	return attacking_state
