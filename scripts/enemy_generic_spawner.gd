extends Marker2D
class_name EnemyGenericSpawner

@export var enemy_data: EnemyData
@export var spawn_count: int = 1
@export var spawn_after_kill_delay: float = 0.0
@export var auto_spawn: bool = true
@export var spawn_on_start: bool = true
@export var spawn_random_offset: float = 50.0

var unit_scene: PackedScene = preload("res://scenes/enemy_generic.tscn")
var epoch_last_kill: int = 0
var active: bool = false

var units_spawned: Array[Unit] = []


func _ready():
	if auto_spawn:
		active = true

	if spawn_on_start:
		epoch_last_kill = (spawn_after_kill_delay) * 1000.0 * -1


func _process(delta: float) -> void:
	var sec_since_last_kill: float = (Time.get_ticks_msec() - epoch_last_kill) / 1000.0

	if not active or spawn_after_kill_delay > sec_since_last_kill or units_spawned.size() >= spawn_count:
		return

	spawn()


func spawn():
	var unit: EnemyGeneric = unit_scene.instantiate()
	var offset = Vector2(randf_range(-spawn_random_offset, spawn_random_offset), randf_range(-spawn_random_offset, spawn_random_offset))
	unit.global_position = global_position + offset
	unit.enemy_data = enemy_data
	GameManager.enemies.add_child(unit)
	unit.health_component.died.connect(_on_died.bind(unit))
	units_spawned.append(unit)


func _on_died(unit: EnemyGeneric):
	epoch_last_kill = Time.get_ticks_msec()
	units_spawned.erase(unit)
