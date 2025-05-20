extends Node

var zombies: Node
var others: Node


func _ready() -> void:
	zombies = get_tree().get_first_node_in_group(Globals.GROUP_ZOMBIES)
	others = get_tree().get_first_node_in_group(Globals.GROUP_OTHERS)
