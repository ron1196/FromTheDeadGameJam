extends Node2D

var start_pos = Vector2()
var end_pos = Vector2()
var is_selecting = false


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# Start selection
				start_pos = get_global_mouse_position()
				is_selecting = true
			else:
				# End selection
				is_selecting = false
				select_units_in_area(start_pos, get_global_mouse_position())

	if event is InputEventMouseMotion and is_selecting:
		# Update end position while dragging
		end_pos = get_global_mouse_position()
		queue_redraw()


func _draw():
	if is_selecting:
		# Draw selection rectangle
		var rect = Rect2(start_pos, end_pos - start_pos)
		draw_rect(rect, Color(1, 1, 1, 0.3), true)
		draw_rect(rect, Color(1, 1, 1), false, 1.0)


func select_units_in_area(start: Vector2, end: Vector2):
	var rect = Rect2(start, end - start)
	rect = rect.abs() # Ensure positive size

	# Find all units in the area
	for unit in get_tree().get_nodes_in_group("zombie"):
		if rect.has_point(unit.global_position):
			unit.select() # You'll need to implement this method on your units
		else:
			unit.deselect()
