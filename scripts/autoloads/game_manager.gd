extends Node

var miscellaneous: Node


func _ready() -> void:
	miscellaneous = get_tree().get_first_node_in_group(Globals.GROUP_OTHERS)
