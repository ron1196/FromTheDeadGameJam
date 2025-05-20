extends VBoxContainer

@onready var inventory: Inventory = %Inventory
@onready var zombie_preview: Zombie = %ZombiePreview
@onready var attributes_ui: AttributesUI = %AttributesUI

var selected_items: Array[ItemData] = []
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

	var base_area_rect: Rect2 = GameManager.base_area.rect
	var random_pos_in_area: Vector2 = Vector2(
		randf_range(base_area_rect.position.x, base_area_rect.size.x),
		randf_range(base_area_rect.position.y, base_area_rect.size.y))

	zombie.position = GameManager.base_area.global_position + random_pos_in_area
	zombie.scale = Vector2(1, 1)
	zombie.name = name_gen.new_name()[randi() % 2]
	GameManager.zombies.add_child(zombie)
	zombie.disable_statute()


func _on_reset_pressed() -> void:
	for item in selected_items:
		inventory.add_item(item, 1)

	selected_items.clear()
	zombie_preview.clear()


func _on_inventory_item_selected(item: ItemData) -> void:
	var body_part_scene: PackedScene = item.scene

	if body_part_scene == null:
		push_error("No scene for item with id: " + str(item.name))
		return

	if not zombie_preview.add_body_part(body_part_scene):
		return

	selected_items.append(item)
	inventory.remove_item(item, 1)
