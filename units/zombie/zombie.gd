extends Unit
class_name Zombie

const YELLOW_FLASH := "res://shaders/flash_yellow.tres"

@onready var hurtbox_component: HurtboxComponent = %HurtboxComponent

@export var speed: float = 700

var is_selected: bool = false


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


func clear():
	for body_part in body_parts:
		body_part.queue_free()

	body_parts.clear()

	_calculate_attributes()
