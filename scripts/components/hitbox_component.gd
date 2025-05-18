@icon("res://assets/scripts/hitbox.svg")
class_name HitboxComponent
extends Area2D


func _init() -> void:
	monitoring = true
	monitorable = false


func enable() -> void:
	set_deferred("monitoring", true)
	set_deferred("monitorable", false)


func disable() -> void:
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)
