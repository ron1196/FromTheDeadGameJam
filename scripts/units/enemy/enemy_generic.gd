extends Unit
class_name EnemyGeneric

@export var enemy_visual_scene: PackedScene
var enemy_visual: Node2D

@export var targets: Array[Vector2]


func _ready() -> void:
	super()
	enemy_visual = enemy_visual_scene.instantiate()
	add_child(enemy_visual)
	(movable as EnemyMovable).targets = targets


func get_speed() -> float:
	return 100


func _calculate_attributes() -> void:
	var tmp: BodyPartAttributes = BodyPartAttributes.new()
	tmp.endurance = 10
	attributes = tmp


func get_nodes_to_change_material() -> Array[Node2D]:
	return [enemy_visual]
