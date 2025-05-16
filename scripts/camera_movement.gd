extends Camera2D

@export var scroll_speed := 700.0 # Max scroll speed in pixels per second
@export var edge_margin := 100.0 # Edge zone in pixels
@export var limit_rect := Rect2(-2000, -2000, 2000, 2000) # Optional camera bounds


func _process(delta: float) -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	var screen_size = get_viewport_rect().size
	var velocity = Vector2.ZERO

	# Horizontal
	if mouse_pos.x < edge_margin:
		velocity.x = -get_scroll_factor(mouse_pos.x)
	elif mouse_pos.x > screen_size.x - edge_margin:
		velocity.x = get_scroll_factor(screen_size.x - mouse_pos.x)

	# Vertical
	if mouse_pos.y < edge_margin:
		velocity.y = -get_scroll_factor(mouse_pos.y)
	elif mouse_pos.y > screen_size.y - edge_margin:
		velocity.y = get_scroll_factor(screen_size.y - mouse_pos.y)

	if velocity != Vector2.ZERO:
		position += velocity * scroll_speed * delta


# Makes movement faster the deeper the mouse is in the edge
func get_scroll_factor(dist_to_edge: float) -> float:
	var t:float = clamp((edge_margin - dist_to_edge) / edge_margin, 0.0, 1.0)
	return lerp(0.3, 1.0, pow(t, 3.0)) # Ease-out
