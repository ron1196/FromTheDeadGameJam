extends Area2D
class_name SightComponent

@export var debug: bool

var units: Array[Area2D]


func enable() -> void:
	set_deferred("monitorable", true)
	set_deferred("monitoring", true)


func disable() -> void:
	set_deferred("monitorable", false)
	set_deferred("monitoring", false)


func _on_sight_entered(unit: Area2D) -> void:
	if debug:
		print(name + " enter " + unit.name)

	units.append(unit)


func unit_in_sight(unit: Unit) -> bool:
	return units.find(unit) != -1


func has_unit_in_sight() -> bool:
	return !units.is_empty()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("ui_focus_next"):
		print(units)


func find_closest_unit(target: Vector2) -> Area2D:
	var closest: Area2D = null
	var min_distance: float = INF

	for unit in units:
		if unit == null or not unit is Area2D:
			continue

		var distance = target.distance_to(unit.global_position)

		if distance < min_distance:
			min_distance = distance
			closest = unit

	return closest


func _on_sight_exited(unit: Area2D) -> void:
	if debug:
		print(name + " exit " + unit.name)

	units.erase(unit)
