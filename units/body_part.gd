@tool
class_name BodyPart
extends Node2D

@export var body_type: Enums.BodyType
@export var attributes: BodyPartAttributes
@export var traits: Array[Trait]

var anchors: Array[BodyAnchor]:
	get:
		if anchors.is_empty():
			anchors = _get_anchors()

		return anchors


func _ready() -> void:
	if body_type == Enums.BodyType.UNDEFINED:
		push_error("Undefined body part for node: " + str(name))

	if attributes == null:
		push_error("Undefined attributes for node: " + str(name))


func get_traits():
	pass


func activate_trait():
	pass


func flip_h() -> void:
	for child: Node2D in get_children():
		if "flip_h" in child:
			child.flip_h = !child.flip_h


## Find an anchor that matches the exact body type, if none is found, select one at random
func find_anchor_for(connect_body_type: Enums.BodyType) -> BodyAnchor:
	var idx: int = _find_anchor_for(connect_body_type)

	if idx != -1:
		return anchors[idx]

	return anchors.filter(func(an: BodyAnchor): return !an.is_used).pick_random()


## Return true if there is an anchor that matches the exact body type, if none is found, return false
func has_anchor_for(connect_body_type: Enums.BodyType) -> bool:
	var idx: int = _find_anchor_for(connect_body_type)
	return idx != -1


func _find_anchor_for(connect_body_type: Enums.BodyType) -> int:
	var anchor_idx: int = anchors.find_custom(
			func(an: BodyAnchor):
				return !an.is_used and an.connected_to_type == connect_body_type)

	return anchor_idx


func any_available_anchor() -> bool:
	return anchors.any(func(an: BodyAnchor): return !an.is_used)


func _process(_delta):
	if Engine.is_editor_hint() and Globals.DEBUG:
		queue_redraw() # Continuously schedule redraws in the editor


func _draw() -> void:
	if Engine.is_editor_hint() and Globals.DEBUG:
		for child in get_children():
			if child is Marker2D:
				var start = child.position
				var direction = Vector2.RIGHT.rotated(child.rotation) * 5
				var end = start + direction
				draw_line(start, end, Color.YELLOW, 2)


func _get_anchors() -> Array[BodyAnchor]:
	var temp: Array[BodyAnchor] = []

	for child in get_children():
		if child as BodyAnchor:
			if child != null:
				temp.append(child)

	return temp
