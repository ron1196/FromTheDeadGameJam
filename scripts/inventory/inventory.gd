extends GridContainer
class_name Inventory

signal item_added(item: ItemData, amount: int)
signal item_selected(item: ItemData)

#region Variables
@export var grid_size: Vector2i
@export var grid_slot_size: Vector2
@export var grid_slot_ui_scene: PackedScene
@export var unlimited_items: Array[ItemData]
#endregion

var slots: Array[GridSlotUI]


func _ready() -> void:
	columns = grid_size.x

	for idx in range(grid_size.x * grid_size.y):
		var grid_slot_ui: GridSlotUI = grid_slot_ui_scene.instantiate()
		grid_slot_ui.custom_minimum_size = grid_slot_size
		add_child(grid_slot_ui)
		grid_slot_ui.pressed.connect(_on_click.bind(idx))
		slots.append(grid_slot_ui)

	for item in unlimited_items:
		_add_item_not_checking_unlimited(item, item.stack_size)


func _on_click(idx: int):
	if slots[idx].item_data == null: return
	item_selected.emit(slots[idx].item_data)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("creative"):
		for item: String in get_all_file_paths():
			var res: ItemData = load(item)
			add_item(res, 1)


func get_all_file_paths(path: String = "res://items/") -> Array[String]:
	var file_paths: Array[String] = []
	var dir = DirAccess.open(path)
	dir.list_dir_begin()
	var file_name = dir.get_next()

	while file_name != "":
		var file_path = path + "/" + file_name

		if dir.current_is_dir():
			file_paths += get_all_file_paths(file_path)
		else:
			file_paths.append(file_path)

		file_name = dir.get_next()

	return file_paths


func add_item(_item_data: ItemData, _amount: int):
	if _item_data in unlimited_items: return
	_add_item_not_checking_unlimited(_item_data, _amount)


func _add_item_not_checking_unlimited(_item_data: ItemData, _amount: int) -> void:
	for slot in slots:
		if slot.item_data == _item_data and slot.amount + _amount <= _item_data.stack_size:
			slot.add_item_amount(_amount)
			item_added.emit(_item_data, _amount)
			return

	for slot: GridSlotUI in slots:
		if slot.item_data == null:
			slot.set_item(_item_data, _amount)
			item_added.emit(_item_data, _amount)
			return

	print("Inventory full!")


func remove_item(_item_data: ItemData, _amount: int):
	if _item_data in unlimited_items:
		return

	for slot: GridSlotUI in slots:
		if slot.item_data == _item_data:
			slot.remove_item_amount(_amount)
			return
