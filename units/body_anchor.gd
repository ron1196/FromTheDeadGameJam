@tool
extends Marker2D
class_name BodyAnchor

@export var connected_to_type: Enums.BodyType
@export var properties: Dictionary

var is_used: bool = false


func _ready() -> void:
	if connected_to_type == Enums.BodyType.UNDEFINED:
		push_error("Undefined anchor: " + str(get_parent().name) + "|" + str(name))


#func _process(_delta):
	#if Engine.is_editor_hint() and Globals.DEBUG:
		#queue_redraw() # Continuously schedule redraws in the editor
#
#
#func _draw() -> void:
	#var start = global_position
	#var direction = Vector2.RIGHT.rotated(global_rotation) * 30
	#var end = start + direction
	#print("Child "+ str(start) + " " + str(end))
	#draw_line(start, end, Color.GREEN_YELLOW, 2)
