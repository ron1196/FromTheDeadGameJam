class_name Zombie
extends Node2D

var body_parts: Array[BodyPart]


func calculate_attributes():
	var attributes: BodyPartAttributes = BodyPartAttributes.new()

	for part in body_parts:
		attributes.intelligence += part.attributes.intelligence
		attributes.attack += part.attributes.attack
		attributes.speed += part.attributes.speed
		attributes.health += part.attributes.health

	return attributes


func add_body_part(scene: PackedScene):
	var part: BodyPart = scene.instantiate()

	var connect_to: BodyPart = _find_best_body_part_to_connect(part)

	if connect_to == null and !body_parts.is_empty():
		return

	part.visible = false
	part.position = Vector2.ZERO
	add_child(part)

	if connect_to != null:
		var part_anchor: BodyAnchor = part.find_anchor_for(connect_to.body_type)
		var other_part_anchor: BodyAnchor = connect_to.find_anchor_for(part.body_type)
		part_anchor.is_used = true
		other_part_anchor.is_used = true

		var rotation_offset = PI + part_anchor.global_rotation - other_part_anchor.global_rotation
		part.rotation = rotation_offset

		var part_anchor_postion = other_part_anchor.global_position / other_part_anchor.global_scale
		var other_part_anchor_postion = part_anchor.global_position / part_anchor.global_scale
		part.position = part_anchor_postion - other_part_anchor_postion

	part.visible = true
	body_parts.append(part)


func _find_best_body_part_to_connect(part: BodyPart) -> BodyPart:
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


func clear():
	for body_part in body_parts:
		body_part.queue_free()

	body_parts.clear()
