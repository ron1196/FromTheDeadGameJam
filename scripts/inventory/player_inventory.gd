extends GridInventory


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("creative"):
		for item in database.items:
			add(item.id)
