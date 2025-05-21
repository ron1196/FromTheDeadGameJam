extends Unit
class_name EnemyGeneric

@export var enemy_data: EnemyData
@export var targets: Array[Vector2]


func _ready() -> void:
	super()

	for part_scene in enemy_data.body_parts_scenes:
		add_body_part(part_scene)

	(movable as EnemyMovable).targets = targets


func get_speed() -> float:
	return 100


func _on_died() -> void:
	for loot_entry in enemy_data.loot_entries:
		var rand = randf()

		if rand <= loot_entry.chance:
			print("got " + loot_entry.item.name)
			GameManager.inventory.add_item(loot_entry.item, loot_entry.amount)

	super()
