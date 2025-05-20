@tool
extends Button
class_name GridSlotUI

@export var regular_style: StyleBox
@export var hover_style: StyleBox
@export var selected_style: StyleBox

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var default_item_icon = %ItemIcon.texture

var item_data: ItemData = null:
	set(value):
		item_data = value

		if value != null:
			%ItemIcon.texture = item_data.icon
		else:
			%ItemIcon.texture = default_item_icon

var amount: int = 0:
	set(value):
		amount = value

		%StackSizeLabel.text = str(amount) if amount > 1 else ""


func select():
	pressed
	if is_instance_valid(selected_style):
		_set_panel_style(selected_style)


func unselect():
	_set_panel_style(regular_style)


func _ready() -> void:
	_set_panel_style(regular_style)
	mouse_entered.connect(func():
		_set_panel_style(hover_style)
		audio_stream_player.play())

	mouse_exited.connect(func():
		_set_panel_style(regular_style))


func _set_panel_style(style: StyleBox) -> void:
	remove_theme_stylebox_override("panel")
	if style != null:
		add_theme_stylebox_override("panel", style)


func set_item(_item_data: ItemData, _amount: int):
	item_data = _item_data
	amount = _amount


func add_item_amount(_amount: int) -> void:
	amount += _amount


func remove_item_amount(_amount: int) -> void:
	amount -= _amount

	if amount <= 0:
		clear_slot()


func clear_slot():
	item_data = null
	amount = 0
