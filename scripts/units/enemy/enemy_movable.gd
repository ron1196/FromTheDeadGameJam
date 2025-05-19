extends Movable
class_name EnemyMovable

var targets: Array[Vector2]
var target_idx = 0

const DESIRED_DISTANCE_THRESHOLD: float = 20


func _ready() -> void:
	unit.nav_agent.target_reached.connect(_on_target_reached)


func _on_target_reached() -> void:
	target_idx = (target_idx + 1) % targets.size()


func get_target_position() -> Vector2:
	if targets.is_empty(): return Vector2.INF
	if not unit.state_machine.is_idle(): return Vector2.INF
	var target: Vector2 = targets[target_idx]
	return target
