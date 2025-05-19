extends Movable
class_name EnemyMovable

var targets: Array[Vector2]
var target_idx = 0
var base_max_distance_from_start: float


func _ready() -> void:
	base_max_distance_from_start = unit.max_distance_from_start
	unit.nav_agent.target_reached.connect(_on_target_reached)


func _on_target_reached() -> void:
	if targets.is_empty(): return
	var old_target: Vector2 = targets[target_idx]

	if not unit.global_position.distance_to(old_target) <= unit.nav_agent.target_desired_distance:
		return

	unit.start_position = old_target
	var new_target_idx: int = (target_idx + 1) % targets.size()
	var new_target: Vector2 = targets[new_target_idx]
	unit.max_distance_from_start = abs(new_target.distance_to(old_target)) + base_max_distance_from_start
	target_idx = new_target_idx


func get_target_position() -> Vector2:
	if targets.is_empty(): return Vector2.INF
	if not unit.state_machine.is_idle(): return Vector2.INF
	var target: Vector2 = targets[target_idx]
	unit.start_position = target
	return target
