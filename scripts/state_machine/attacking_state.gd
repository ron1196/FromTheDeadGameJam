extends State
class_name AttackingState

@export var attack_interval = 0.5
@export var attack_damage_base = 5
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


func _on_target_died() -> void:
	change_state(idle_state)


func _on_attack_timer_timeout() -> void:
	var attack_damage: float = _get_attack_damage()
	target.health_component.damage(attack_damage)


func _get_attack_damage() -> float:
	return attack_damage_base + zombie.attributes.attack * 2


func enter() -> void:
	super()
	if target == null:
		push_warning("Attacking without target, going to idle!")
		change_state(idle_state)
		return

	target.health_component.died.connect(_on_target_died)
	attack_timer.start()


func exit() -> void:
	super()
	attack_timer.stop()
	target.health_component.died.disconnect(_on_target_died)
	target = null


func handle_input(event: InputEvent) -> void:
	super.handle_input(event)

	var target_position: Vector2 = zombie.movable.get_target_position()

	if target_position != Vector2.INF:
		engaging_position_state.target = target_position
		change_state(engaging_position_state)
