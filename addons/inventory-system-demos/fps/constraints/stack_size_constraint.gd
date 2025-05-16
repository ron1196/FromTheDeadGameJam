extends InventoryConstraint
class_name StackSizeConstraint

@export var max_size_stack: int = 2

func _can_add_new_stack_on_inventory(inventory: Node, item_id: String, amount: int, properties: Dictionary) -> bool:
	if inventory.stacks.size() >= max_size_stack:
		return false
	return true
	
func _get_max_stack(inventory: Node, item_id: String, amount: int, properties: Dictionary) -> int:
	if item_id == "wood":
		return 32
	return 2

func _is_override_max_stack(inventory: Node, item_id: String, amount: int, properties: Dictionary) -> bool:
	if item_id == "wood":
		return true
	return false
