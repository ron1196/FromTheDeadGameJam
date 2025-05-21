extends Node2D
class_name Unit

signal attributes_changed(attributes: BodyPartAttributes)
signal gtraits_attack_changed(gtraits: Array[GTrait])

const WHITE_FLASH := "res://shaders/flash.tres"

@export var health_component: HealthComponent
@export var sight_component: SightComponent
@export var nav_agent: NavigationAgent2D
@export var state_machine: StateMachine
@export var movable: Movable
@export var base_speed: float = 10
@export var base_hp: float = 20

@export var floating_damage_indicator_scene: PackedScene
@export var is_static: bool = false

@export var max_distance_from_start: float = INF
var start_position: Vector2

var body_parts: Array[BodyPart]

var attributes: BodyPartAttributes:
	set(value):
		if attributes != null && attributes.equals(value):
			return

		attributes = value
		attributes_changed.emit(attributes)

var gtraits_attack: Array[Callable]:
	set(value):
		if gtraits_attack != null && gtraits_attack.hash() == value.hash():
			return

		gtraits_attack = value
		gtraits_attack_changed.emit(attributes)


func _ready() -> void:
	start_position = global_position

	for child in get_children():
		if child as BodyPart:
			body_parts.append(child)

	_calculate_on_new_parts()

	health_component.died.connect(_on_died)
	health_component.health_changed.connect(_on_health_changed)

#region Body Part Connection


func add_body_part(scene: PackedScene) -> bool:
	var part: BodyPart = scene.instantiate()

	var connect_to: BodyPart = _find_best_part_to_connect(part)

	if connect_to == null and !body_parts.is_empty():
		return false

	part.visible = false
	part.position = Vector2.ZERO
	add_child(part)

	_connect_to_body_part(part, connect_to)

	part.visible = true
	body_parts.append(part)

	_calculate_on_new_parts()

	return true


func _find_best_part_to_connect(part: BodyPart) -> BodyPart:
	var best_count: int = -1
	var best_part: BodyPart = null

	for tmp_other_part in body_parts:
		if !tmp_other_part.any_available_anchor():
			continue

		var has_part_anchor: bool = part.has_anchor_for(tmp_other_part.body_type)
		var other_has_part_anchor: bool = tmp_other_part.has_anchor_for(part.body_type)
		var tmp_count: int = 0

		if has_part_anchor:
			tmp_count += 1

		if other_has_part_anchor:
			tmp_count += 1

		if tmp_count > best_count:
			best_count = tmp_count
			best_part = tmp_other_part

	return best_part


func _connect_to_body_part(part: BodyPart, connect_to: BodyPart) -> void:
	if connect_to == null:
		return

	var part_anchor: BodyAnchor = part.find_anchor_for(connect_to.body_type)
	var other_part_anchor: BodyAnchor = connect_to.find_anchor_for(part.body_type)
	part_anchor.is_used = true
	other_part_anchor.is_used = true

	var rotation_offset = PI + (other_part_anchor.global_rotation - part_anchor.global_rotation)
	part.rotation = rotation_offset

	var part_anchor_postion = other_part_anchor.global_position / scale
	var other_part_anchor_postion = part_anchor.global_position / scale

	#if other_part_anchor.properties.get(Globals.PROPERTY_DIRECTION) == "left":
		#part.flip_h()

	part.position = part_anchor_postion - other_part_anchor_postion

#endregion

#region Attributes


func _calculate_on_new_parts() -> void:
	_calculate_attributes()
	_calculate_gtraits_attack()
	_apply_attributes()


func _calculate_attributes() -> void:
	var tmp: BodyPartAttributes = BodyPartAttributes.new()

	for part: BodyPart in body_parts:
		tmp.add(part.attributes)

	attributes = tmp


func _apply_attributes() -> void:
	health_component.max_health = base_hp + 5 * 100
	nav_agent.max_speed = base_speed * max(1, attributes.speed)

#endregion


func get_nodes_to_change_material() -> Array[Node2D]:
	var nodes: Array[Node2D] = []

	for part: BodyPart in body_parts:
		for child in part.get_children():
			if child as Sprite2D:
				nodes.append(child)

	return nodes


func put_shader(shader: ShaderMaterial) -> Array[Node2D]:
	var sprites: Array[Node2D] = get_nodes_to_change_material()
	var changed: Array[Node2D] = []

	for node in sprites:
		if node.material == null:
			node.material = shader
			changed.append(node)

	return changed


func _calculate_gtraits_attack() -> void:
	var tmp: Array[Callable] = []

	for part: BodyPart in body_parts:
		var traits_idx: Array[int] = part.get_traits()
		var callables: Array[Callable]
		for trait_idx in traits_idx:
			callables.append(part.activate_trait.bind(trait_idx))

		tmp.append_array(callables)

	gtraits_attack = tmp


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
		scene.set_random_position_x(-12, 12)
		scene.set_random_position_y(-10, -20)
		scene.global_position += global_position
		GameManager.others.add_child(scene)
		scene.set_damage(amount, type)


func _on_died() -> void:
	queue_free()


func get_speed() -> float:
	return 0
