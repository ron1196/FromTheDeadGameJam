extends Camera2D

# Camera Movement
@export var pan_speed := 600 # Base speed (pixels/second)
@export var edge_scroll_margin := 50.0 # How close to edge to trigger scroll
@export var limit_pos_x: Vector2
@export var limit_pos_y: Vector2

@export var edge_scroll_min_speed := 0.8 # Multiplier for min edge scrolling
@export var edge_scroll_max_speed := 1.5 # Multiplier for max edge scrolling

# Zoom Controls
@export var zoom_speed := 0.1
@export var zoom_min := 0.5
@export var zoom_max := 2.0
@export var zoom_default := 1.0
@export var zoom_smoothing_speed := 0.1

var _target_zoom := zoom_default
var _input_direction := Vector2.ZERO


func _ready() -> void:
	# Faster on larger screens (e.g., 4K), slower on small laptops
	#var screen_width = get_viewport().get_visible_rect().size.x
	#pan_speed *= screen_width / 1920.0 # 1920 = baseline (1080p)

	reset_zoom()


func _process(_delta: float) -> void:
	handle_movement(_delta)
	handle_zoom(_delta)


func handle_movement(delta: float) -> void:
	if not InputManager.is_game_input_allowed():
		return # Block input when UI is open

	# Keyboard/gamepad movement
	if Globals.options_input_scrolling:
		_input_direction = Input.get_vector("left", "right", "up", "down")
	else:
		_input_direction = Vector2.ZERO

	var movement = _input_direction * pan_speed * delta

	# Edge scrolling (only if mouse is at screen edge)
	if Globals.options_edge_scrolling and Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
		movement += get_edge_scroll_direction() * pan_speed * delta

	# Apply movement
	position += movement

	position.x = clamp(position.x, limit_pos_x.x, limit_pos_x.y)
	position.y = clamp(position.y, limit_pos_y.x, limit_pos_y.y)


func get_edge_scroll_direction() -> Vector2:
	var viewport := get_viewport()
	var mouse_pos := viewport.get_mouse_position()
	var viewport_size := viewport.get_visible_rect().size
	var direction := Vector2.ZERO

	# Horizontal edges (X-axis)
	if mouse_pos.x >= 0 && mouse_pos.x <= edge_scroll_margin:
		var distance_to_edge = mouse_pos.x
		var edge_progress = 1.0 - (distance_to_edge / edge_scroll_margin)
		direction.x = -lerp(edge_scroll_min_speed, edge_scroll_max_speed, edge_progress) # Closer to edge = stronger pull

	elif mouse_pos.x <= viewport_size.x and mouse_pos.x >= viewport_size.x - edge_scroll_margin:
		var distance_to_edge = viewport_size.x - mouse_pos.x
		var edge_progress = 1.0 - (distance_to_edge / edge_scroll_margin)
		direction.x = lerp(edge_scroll_min_speed, edge_scroll_max_speed, edge_progress)

	# Vertical edges (Y-axis)
	if mouse_pos.y >= 0 && mouse_pos.y <= edge_scroll_margin:
		var distance_to_edge = mouse_pos.y
		var edge_progress = 1.0 - (distance_to_edge / edge_scroll_margin)
		direction.y = -lerp(edge_scroll_min_speed, edge_scroll_max_speed, edge_progress)

	elif mouse_pos.y <= viewport_size.y and mouse_pos.y >= viewport_size.y - edge_scroll_margin:
		var distance_to_edge = viewport_size.y - mouse_pos.y
		var edge_progress = 1.0 - (distance_to_edge / edge_scroll_margin)
		direction.y = lerp(edge_scroll_min_speed, edge_scroll_max_speed, edge_progress)

	return direction


func handle_zoom(_delta: float) -> void:
	var target_zoom_vector: Vector2 = Vector2(_target_zoom, _target_zoom)

	if zoom.distance_to(target_zoom_vector) <= 0.01:
		return

	# Smooth zoom
	zoom = zoom.lerp(target_zoom_vector, zoom_smoothing_speed)


func reset_zoom() -> void:
	_target_zoom = clampf(zoom_default, zoom_min, zoom_max)
	zoom = Vector2(_target_zoom, _target_zoom)


func _unhandled_input(event: InputEvent) -> void:
	if not InputManager.is_game_input_allowed():
		return # Block input when UI is open

	if event.is_action_pressed("zoom_in"):
		_target_zoom = clamp(_target_zoom + 1 * zoom_speed, zoom_min, zoom_max)

	if event.is_action_pressed("zoom_out"):
		_target_zoom = clamp(_target_zoom + -1 * zoom_speed, zoom_min, zoom_max)

	# Middle-mouse drag panning
	#if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE):
	#	position -= event.relative / zoom

	# Double-click reset (optional)
	if event.is_action_pressed("reset_camera"):
		reset_zoom()
		position = Vector2.ZERO
