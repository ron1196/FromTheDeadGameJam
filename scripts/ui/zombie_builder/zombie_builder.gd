extends VBoxContainer

@export var spawn_unit_node: Node
@export var base_area: Node2D

@onready var inventory: GridInventory
@onready var inventory_panel: GridInventoryUI = $InventoryPanel
@onready var zombie_preview: Zombie = %ZombiePreview
@onready var attributes_ui: AttributesUI = %AttributesUI

var selected_items: Array[ItemDefinition] = []
var name_gen: NameGenerator = NameGenerator.new()


func _ready() -> void:
	inventory = get_tree().get_first_node_in_group("player_inventory")
	zombie_preview.attributes_changed.connect(attributes_ui.on_zombie_attributes_changed)


func _is_valid_zombie() -> bool:
	return not selected_items.is_empty()


func _on_build_pressed() -> void:
	if not _is_valid_zombie():
		return

	var zombie: Zombie = zombie_preview.duplicate()

	selected_items.clear()
	zombie_preview.clear()

	var base_area_rect: Rect2 = base_area.rect
	var random_pos_in_area: Vector2 = Vector2(
		randf_range(base_area_rect.position.x, base_area_rect.size.x),
		randf_range(base_area_rect.position.y, base_area_rect.size.y))

	zombie.position = base_area.global_position + random_pos_in_area
	zombie.scale = Vector2(1, 1)
	zombie.name = name_gen.new_name()[randi() % 2]
	spawn_unit_node.add_child(zombie)
	zombie.disable_statute()


func _on_reset_pressed() -> void:
	for item in selected_items:
		inventory.add(item.id)

	selected_items.clear()
	zombie_preview.clear()


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

	if not zombie_preview.add_body_part(body_part_scene):
		return

	selected_items.append(item_body_part)
	inventory.remove(item_stack.item_id)
