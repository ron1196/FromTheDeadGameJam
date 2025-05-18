extends Control

@onready var center: CenterContainer = $Center
@onready var node: Zombie = $ZombiePreview


func _ready() -> void:
	node.make_statute()


func _on_resized() -> void:
	node.position = center.position
