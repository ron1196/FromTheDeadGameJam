@icon("res://assets/scripts/hurtbox.svg")
class_name HurtboxComponent
extends Area2D

@export var health_component: HealthComponent


func _init() -> void:
	monitoring = true
	monitorable = true
	area_entered.connect(_on_area_entered)


func _on_area_entered(_hit: HitboxComponent):
	health_component.damage(int(INF))


func enable() -> void:
	set_deferred("monitoring", true)
	set_deferred("monitorable", true)


func disable() -> void:
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)
