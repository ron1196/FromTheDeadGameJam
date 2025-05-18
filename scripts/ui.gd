extends Panel

@export var action: Enums.InputMapOptions
var action_string_value = InputManager.convert_enum_to_string(action)


func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)
	visible = false


func _exit_tree():
	InputManager.unregister_ui_layer()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(action_string_value):
		visible = !visible;


func _on_visibility_changed() -> void:
	if visible:
		InputManager.register_ui_layer()
	else:
		InputManager.unregister_ui_layer()
