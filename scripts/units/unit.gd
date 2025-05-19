extends Node2D
class_name Unit

signal attributes_changed(attributes: BodyPartAttributes)

const WHITE_FLASH := "res://shaders/flash.tres"

@export var health_component: HealthComponent
@export var sight_component: SightComponent
@export var nav_agent: NavigationAgent2D
@export var state_machine: StateMachine
@export var movable: Movable

@export var floating_damage_indicator_scene: PackedScene
@export var is_static: bool = false

var attributes: BodyPartAttributes:
	set(value):
		if attributes != null && attributes.equals(value):
			return

		attributes = value
		attributes_changed.emit(attributes)


func _ready() -> void:
	_calculate_attributes()

	health_component.max_health += attributes.endurance * 10

	health_component.died.connect(_on_died)
	health_component.health_changed.connect(_on_health_changed)


func get_nodes_to_change_material() -> Array[Node2D]:
	return []


func put_shader(shader: ShaderMaterial) -> Array[Node2D]:
	var sprites: Array[Node2D] = get_nodes_to_change_material()
	var changed: Array[Node2D] = []

	for node in sprites:
		if node.material == null:
			node.material = shader
			changed.append(node)

	return changed


func remove_shader(arr: Array[Node2D]):
	for node in arr:
		node.material = null


## Flash white briefly
func _play_damage_feedback(shader: ShaderMaterial) -> void:
	var changed: Array[Node2D] = put_shader(shader)
	await get_tree().create_timer(0.1).timeout
	remove_shader(changed)


func _on_health_changed(amount: int, type: HealthComponent.Types) -> void:
	_play_damage_feedback(preload(WHITE_FLASH))
	if floating_damage_indicator_scene != null:
		var scene: FloatingDamageIndicator = floating_damage_indicator_scene.instantiate()
		add_child(scene)
		scene.set_random_position_x(-12, 12)
		scene.set_random_position_y(-10, -20)
		scene.set_damage(amount, type)


func _on_died() -> void:
	queue_free()


func get_speed() -> float:
	return 0


func _calculate_attributes() -> void:
	pass
