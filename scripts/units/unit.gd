extends Node2D
class_name Unit

signal attributes_changed(attributes: BodyPartAttributes)

@export var health_component: HealthComponent
@export var sight_component: SightComponent
@export var nav_agent: NavigationAgent2D
@export var state_machine: StateMachine
@export var movable: Movable

@export var is_static: bool = false

var attributes: BodyPartAttributes


func _ready() -> void:
	_calculate_attributes()
	health_component.max_health += attributes.endurance * 10


func get_speed() -> float:
	return 0


func _calculate_attributes() -> void:
	attributes = BodyPartAttributes.new()
