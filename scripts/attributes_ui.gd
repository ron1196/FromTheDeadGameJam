extends VBoxContainer
class_name AttributesUI

@onready var attribute_intelligence_value_label: Label = $Intelligence/Value
@onready var attribute_attack_value_label: Label = $Attack/Value
@onready var attribute_speed_value_label: Label = $Speed/Value
@onready var attribute_health_value_label: Label = $Health/Value


func on_zombie_attributes_changed(attributes: BodyPartAttributes) -> void:
	attribute_intelligence_value_label.text = str(attributes.intelligence)
	attribute_attack_value_label.text = str(attributes.attack)
	attribute_speed_value_label.text = str(attributes.speed)
	attribute_health_value_label.text = str(attributes.health)
