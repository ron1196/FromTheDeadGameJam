extends Node

var base_area: VisibleOnScreenEnabler2D

var zombies: Node
var enemies: Node
var others: Node

var inventory: Inventory


func reload() -> void:
	base_area = get_tree().get_first_node_in_group(Globals.GROUP_BASE_AREA)

	zombies = get_tree().get_first_node_in_group(Globals.GROUP_ZOMBIES)
	enemies = get_tree().get_first_node_in_group(Globals.GROUP_ENEMIES)
	others = get_tree().get_first_node_in_group(Globals.GROUP_OTHERS)

	inventory = get_tree().get_first_node_in_group(Globals.GROUP_PLAYER_INVENTORY)


func _ready() -> void:
	reload()
