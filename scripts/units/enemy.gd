extends Unit
class_name Enemy

@onready var sprite: Sprite2D = %Sprite


func get_speed() -> float:
	return 100


func _calculate_attributes() -> void:
	var tmp: BodyPartAttributes = BodyPartAttributes.new()
	tmp.endurance = 10
	attributes = tmp


func get_nodes_to_change_material() -> Array[Node2D]:
	return [sprite]
