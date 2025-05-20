extends GTrait
class_name SelfDestructTrait

@export var scene_explosion: PackedScene

var activated: bool = false


func activate(unit: Unit) -> void:
	if activated:
		return

	activated = true

	var misc: Node = GameManager.others
	var explosion: Node2D = scene_explosion.instantiate()
	explosion.global_position = unit.global_position
	misc.add_child(explosion)

	unit.queue_free()
