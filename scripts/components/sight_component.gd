extends Area2D

var sight: Array


func _on_sight_entered(unit: Area2D) -> void:
	print(name + " enter " + unit.name)
	sight.append(unit)


func _on_sight_exited(unit: Area2D) -> void:
	print(name + " exit " + unit.name)
	sight.erase(unit)
