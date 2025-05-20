extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.options_edge_scrolling = false
	await get_tree().create_timer(2).timeout
	Globals.options_edge_scrolling = true
