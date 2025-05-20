extends Unit
class_name Zombie

const YELLOW_FLASH := "res://shaders/flash_yellow.tres"

@onready var hurtbox_component: HurtboxComponent = %HurtboxComponent

@export var speed: float = 700

var is_selected: bool = false
var body_parts: Array[BodyPart]


func get_nodes_to_change_material() -> Array[Node2D]:
	var nodes: Array[Node2D] = []

	for part: BodyPart in body_parts:
		for child in part.get_children():
			if child as Sprite2D:
				nodes.append(child)

	return nodes


func _ready():
	super()

	for child in get_children():
		if child as BodyPart:
			body_parts.append(child)

	_calculate_on_new_parts()


func get_speed() -> float:
	return speed


## Make it only sprite, cancel all other loops / triggers / collisions
func make_statute():
	state_machine.disable()
	hurtbox_component.disable()
	sight_component.disable()


func disable_statute():
	state_machine.enable()
	hurtbox_component.enable()
	sight_component.enable()

var changed: Array[Node2D]


func select() -> void:
	changed = put_shader(preload(YELLOW_FLASH))
	is_selected = true


func deselect() -> void:
	remove_shader(changed)
	is_selected = false


func _calculate_gtraits_attack() -> void:
	var tmp: Array[Callable] = []

	for part in body_parts:
		var traits_idx: Array[int] = part.get_traits()
		var callables: Array[Callable]
		for trait_idx in traits_idx:
			callables.append(part.activate_trait.bind(trait_idx))

		tmp.append_array(callables)

	gtraits_attack = tmp


func _calculate_attributes() -> void:
	var tmp: BodyPartAttributes = BodyPartAttributes.new()

	for part in body_parts:
		tmp.add(part.attributes)

	attributes = tmp


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


func clear():
	for body_part in body_parts:
		body_part.queue_free()

	body_parts.clear()

	_calculate_attributes()
