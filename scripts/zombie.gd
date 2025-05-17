class_name Zombie
extends Node2D

@onready var selected_shadow: Sprite2D = %SelectedShadow
@onready var nav_agent: NavigationAgent2D = %Navigation
@onready var state_machine: StateMachine = %StateMachine

@export var speed: float = 700
@export var is_static: bool = false

var body_parts: Array[BodyPart]
var attributes: BodyPartAttributes
var is_selected: bool = false

signal attributes_changed(attributes: BodyPartAttributes)


func _ready():
	for child in get_children():
		if child as BodyPart:
			body_parts.append(child)

	selected_shadow.visible = false
	_calculate_attributes()


func _physics_process(_delta: float) -> void:
	pass


func _on_navigation_finished():
	pass


func select() -> void:
	selected_shadow.visible = true
	is_selected = true


func deselect() -> void:
	selected_shadow.visible = false
	is_selected = false


func _calculate_attributes() -> void:
	var tmp: BodyPartAttributes = BodyPartAttributes.new()

	for part in body_parts:
		tmp.intelligence += part.attributes.intelligence
		tmp.attack += part.attributes.attack
		tmp.speed += part.attributes.speed
		tmp.health += part.attributes.health

	if attributes != null && \
		tmp.intelligence == attributes.intelligence && \
		tmp.attack == attributes.attack && \
		tmp.speed == attributes.speed && \
		tmp.health == attributes.health: return

	attributes = tmp
	attributes_changed.emit(attributes)


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

	_calculate_attributes()

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

	var rotation_offset = PI + part_anchor.global_rotation - other_part_anchor.global_rotation
	part.rotation = rotation_offset

	var part_anchor_postion = other_part_anchor.global_position / other_part_anchor.global_scale
	var other_part_anchor_postion = part_anchor.global_position / part_anchor.global_scale
	part.position = part_anchor_postion - other_part_anchor_postion


func clear():
	for body_part in body_parts:
		body_part.queue_free()

	body_parts.clear()

	_calculate_attributes()
