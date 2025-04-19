extends Area2D
class_name Bomb

signal cooldown_updated(value : float)

const DAMAGE : float = 50.0

var enabled : bool = false
var targets : Array[Node2D] = []

var cooldown : float = 0.0 : set = _set_cooldown
var cooldown_max : float = 5.0

var timer_cooldown : Timer = null

func _ready() -> void:
	timer_cooldown = %TimerCooldown
	disable()
	return

func _process(delta: float) -> void:
	if(not enabled):
		return
	position = get_global_mouse_position()
	return

func _physics_process(delta: float) -> void:
	cooldown += delta
	return

func _unhandled_input(event: InputEvent) -> void:
	if(not enabled):
		return
	if(event is InputEventMouseButton and event.is_pressed()):
		if(event.button_index == MOUSE_BUTTON_LEFT):
			detonate()
		else:
			disable()
	return

func enable() -> void:
	if(not can_enable()):
		return
	enabled = true
	visible = true
	targets.clear()
	return

func disable() -> void:
	enabled = false
	visible = false
	targets.clear()
	return

func can_enable() -> bool:
	return cooldown >= cooldown_max

func detonate() -> void:
	for target : Node2D in targets:
		if(target is Entity):
			target.stats.hitpoints -= DAMAGE
	disable()
	cooldown = 0.0
	return

func _set_cooldown(value : float) -> void:
	cooldown = value
	if(cooldown >= cooldown_max):
		cooldown = cooldown_max
	cooldown_updated.emit(cooldown)
	return

func _on_body_entered(body: Node2D) -> void:
	if(not enabled):
		return
	if(body is Entity):
		targets.append(body)
	return

func _on_body_exited(body: Node2D) -> void:
	if(not enabled):
		return
	if(body in targets):
		targets.erase(body)
	return
