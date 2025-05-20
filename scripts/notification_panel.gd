extends PanelContainer

@export var ui: PackedScene

@onready var notifications: VBoxContainer = %Notifications


func _ready() -> void:
	GameManager.inventory.item_added.connect(_on_item_added)


func _on_item_added(item: ItemData, amount: int):
	print(item.name + " " + str(amount))
	var ui_obj: NotictionUIItem = ui.instantiate()
	ui_obj.init(item, amount)
	notifications.add_child(ui_obj)
