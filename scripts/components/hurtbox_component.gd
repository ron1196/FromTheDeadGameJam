@icon("res://assets/scripts/hurtbox.svg")
class_name HurtboxComponent
extends Area2D

@export var health_component: HealthComponent


func _init() -> void:
	monitoring = false
	monitorable = true


func enable() -> void:
	set_deferred("monitoring", false)
	set_deferred("monitorable", true)


func disable() -> void:
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)
