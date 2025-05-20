extends Unit
class_name EnemyGeneric

@export var enemy_data: EnemyData
@export var targets: Array[Vector2]

var enemy_visual: Node2D


func _ready() -> void:
	super()
	enemy_visual = enemy_data.visual_scene.instantiate()
	add_child(enemy_visual)
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


func _calculate_attributes() -> void:
	var tmp: BodyPartAttributes = BodyPartAttributes.new()

	for attribute: BodyPartAttributes in enemy_data.body_pars_attributes:
		tmp.add(attribute)

	attributes = tmp

	print(name + " " + str(attributes))


func get_nodes_to_change_material() -> Array[Node2D]:
	return [enemy_visual]
