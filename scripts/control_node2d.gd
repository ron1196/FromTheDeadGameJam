extends Control

@onready var center: CenterContainer = $Center
@onready var node: Node2D = $ZombiePreview


func _on_resized() -> void:
	node.position = center.position
