extends Node

@export_enum(Globals.GROUP_ZOMBIE, Globals.GROUP_ENEMY, Globals.GROUP_OTHER) var group: String
@export var is_unit: bool = true


func _on_child_entered_tree(node: Node) -> void:
	if is_unit:
		node.add_to_group(Globals.GROUP_UNIT)

	node.add_to_group(group)
