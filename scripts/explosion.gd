extends Node2D


func _ready():
	%Collision.disabled = true


func _on_frame_changed():
	if %AnimatedSprite.frame == 3:
		%Collision.disabled = false


func destory_node():
	self.queue_free()
