extends Unit
class_name Enemy

@export var floating_damage_indicator_scene: PackedScene


func _calculate_attributes() -> void:
	var tmp: BodyPartAttributes = BodyPartAttributes.new()
	tmp.endurance = 10
	attributes = tmp


func _on_died() -> void:
	queue_free()


## Flash white briefly
func _play_damage_feedback() -> void:
	%Sprite.material = preload("res://shaders/flash.tres")
	await get_tree().create_timer(0.1).timeout
	%Sprite.material = null


func _on_health_changed(amount: int, type: HealthComponent.Types) -> void:
	_play_damage_feedback()
	if floating_damage_indicator_scene != null:
		var scene: FloatingDamageIndicator = floating_damage_indicator_scene.instantiate()
		add_child(scene)
		scene.set_random_position_x(-12, 12)
		scene.set_random_position_y(-22, -40)
		scene.set_damage(amount, type)
