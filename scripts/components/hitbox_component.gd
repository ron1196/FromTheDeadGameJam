@icon("res://assets/scripts/hitbox.svg")
class_name HitboxComponent
extends Area2D


func _init() -> void:
	monitoring = false
	monitorable = true


func enable() -> void:
	set_deferred("monitoring", false)
	set_deferred("monitorable", true)


func disable() -> void:
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)
