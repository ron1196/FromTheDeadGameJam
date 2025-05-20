extends HBoxContainer
class_name NotictionUIItem


func _ready() -> void:
	await get_tree().create_timer(2).timeout
	queue_free()


func init(item: ItemData, amount: int):
	%ItemIcon.texture = item.icon
	%StackSizeLabel.text = "+" + str(amount)
