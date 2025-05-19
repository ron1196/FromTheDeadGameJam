extends Node2D
class_name FloatingDamageIndicator

@export var color_positive: Color
@export var color_negative: Color

@onready var label: Label = %LabelNumber


func set_damage(amount: int, type: HealthComponent.Types) -> void:
	if type == HealthComponent.Types.Damage:
		label.add_theme_color_override("font_color", color_negative)
		label.text = "-" + str(amount)
	else:
		label.add_theme_color_override("font_color", color_positive)
		label.text = "+" + str(amount)


func set_random_position_x(start: float, end: float):
	position.x = randf_range(start, end)


func set_random_position_y(start: float, end: float):
	position.y = randf_range(start, end)
