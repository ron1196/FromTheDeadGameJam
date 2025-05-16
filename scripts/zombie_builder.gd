extends VBoxContainer

@onready var inventory: GridInventory
@onready var inventory_panel: GridInventoryUI = $InventoryPanel

@onready var zombie_preview: Zombie = $HeaderPanel/ZombiePreviewContainer/ZombiePreview
@onready var attribute_intelligence_value_label: Label = $HeaderPanel/StatsMargin/Stats/Intelligence/Value
@onready var attribute_attack_value_label: Label = $HeaderPanel/StatsMargin/Stats/Attack/Value
@onready var attribute_speed_value_label: Label = $HeaderPanel/StatsMargin/Stats/Speed/Value
@onready var attribute_health_value_label: Label = $HeaderPanel/StatsMargin/Stats/Health/Value

var selected_items: Array[ItemDefinition] = []


func _ready() -> void:
	inventory = get_tree().get_first_node_in_group("player_inventory")
	visible = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("build"):
		visible = !visible;


func _on_reset_pressed() -> void:
	for item in selected_items:
		inventory.add(item.id)

	selected_items.clear()
	zombie_preview.clear()

	_update_stats()


func _on_inventory_item_selected() -> void:
	var item_stack_ui: GridItemStackUI = inventory_panel.get_selected_inventory_item()

	if item_stack_ui == null:
		return

	var item_stack = item_stack_ui.stack
	var item_body_part: ItemDefinition = inventory.get_item_from_id(item_stack.item_id)

	if item_body_part == null:
		push_error("No item with id: " + str(item_stack_ui.stack.item_id))
		return

	var body_part_scene: PackedScene = item_body_part.properties.scene

	if body_part_scene == null:
		push_error("No scene for item with id: " + str(item_stack_ui.stack.item_id))
		return

	selected_items.append(item_body_part)
	inventory.remove(item_stack.item_id)

	zombie_preview.add_body_part(body_part_scene)
	_update_stats()


func _update_stats() -> void:
	var attributes: BodyPartAttributes = zombie_preview.calculate_attributes()
	attribute_intelligence_value_label.text = str(attributes.intelligence)
	attribute_attack_value_label.text = str(attributes.attack)
	attribute_speed_value_label.text = str(attributes.speed)
	attribute_health_value_label.text = str(attributes.health)
