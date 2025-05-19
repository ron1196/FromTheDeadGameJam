extends State
class_name AttackingState

@export var attack_interval: float = 0.5
@export var attack_damage_base: float = 5
var attack_timer: Timer

@export var idle_state: State
@export var engaging_position_state: EngagingPositionState

var target: HurtboxComponent = null


func _ready() -> void:
	attack_timer = Timer.new()
	attack_timer.wait_time = attack_interval
	attack_timer.one_shot = false
	attack_timer.autostart = false
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	add_child(attack_timer)


func _validate_target() -> bool:
	if not is_instance_valid(target):
		_on_target_invalid()
		return false

	if unit.global_position.distance_to(target.global_position) >= unit.nav_agent.target_desired_distance * 3:
		_on_target_invalid()
		return false

	return true


func _on_target_invalid() -> void:
	change_state(idle_state)


func _on_attack_timer_timeout() -> void:
	if not _validate_target(): return

	if not unit.gtraits_attack.is_empty():
		var trait_callable: Callable = unit.gtraits_attack.back()
		trait_callable.call(unit)
		return

	var attack_damage: float = _get_attack_damage()
	target.health_component.damage(attack_damage)


func _get_attack_damage() -> float:
	return attack_damage_base + unit.attributes.attack * 2


func enter() -> void:
	super()
	if target == null:
		push_warning("Attacking without target, going to idle!")
		change_state(idle_state)
		return

	if not _validate_target():
		return

	target.health_component.died.connect(_on_target_invalid)
	attack_timer.start()


func exit() -> void:
	super()
	attack_timer.stop()
	if target != null:
		target.health_component.died.disconnect(_on_target_invalid)

	target = null


func update(delta: float) -> void:
	super(delta)

	_validate_target()

	var target_position: Vector2 = unit.movable.get_target_position()

	if target_position != Vector2.INF:
		engaging_position_state.target = target_position
		change_state(engaging_position_state)
