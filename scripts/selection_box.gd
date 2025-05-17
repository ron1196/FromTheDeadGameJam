extends Node2D

var start_pos = Vector2()
var end_pos = Vector2()
var is_selecting = false


func _process(_delta: float) -> void:
	# Update end position while dragging
	if is_selecting:
		end_pos = get_global_mouse_position()
		queue_redraw()


func _input(event):
	if not InputManager.is_game_input_allowed():
		if is_selecting: _end_selection(false)
		return # Block input when UI is open

	if event.is_action_pressed("select"):
		_start_selection()

	if event.is_action_released("select"):
		_end_selection()


func _start_selection():
	start_pos = get_global_mouse_position()
	is_selecting = true


func _end_selection(handle_selection: bool = true):
	is_selecting = false

	if handle_selection:
		select_units_in_area(start_pos, get_global_mouse_position())

	queue_redraw()


func _draw():
	if is_selecting:
		var rect = Rect2(start_pos, end_pos - start_pos)
		draw_rect(rect, Color(1, 1, 1, 0.3), true)
		draw_rect(rect, Color(1, 1, 1), false, 1.0)


func select_units_in_area(start: Vector2, end: Vector2):
	var rect: Rect2 = Rect2(start, end - start).abs()

	for unit in get_tree().get_nodes_in_group(Globals.UNIT_GROUP):
		if rect.has_point(unit.global_position):
			unit.select() # You'll need to implement this method on your units
		else:
			unit.deselect()
