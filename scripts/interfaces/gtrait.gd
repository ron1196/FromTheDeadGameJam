extends Node2D
class_name GTrait

@export var type: Enums.GTraitType


func _ready() -> void:
	if type == Enums.GTraitType.UNDEFINED:
		push_error("Undefined gtrait type for trait: " + str(name))


func activate(_unit: Unit) -> void:
	pass
