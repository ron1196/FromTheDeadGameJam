extends Node

@export_enum(Globals.GROUP_ZOMBIE, Globals.GROUP_ENEMY, Globals.GROUP_MISCELLANEUM) var group: String


func _on_child_entered_tree(node: Node) -> void:
	node.add_to_group(Globals.GROUP_UNIT)
	node.add_to_group(group)
