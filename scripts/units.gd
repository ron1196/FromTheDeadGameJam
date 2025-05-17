extends Node


func _on_child_entered_tree(node: Node) -> void:
	node.add_to_group(Globals.UNIT_GROUP)
