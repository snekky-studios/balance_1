extends Area2D
class_name Bomb

signal cooldown_updated(value : float)

const DAMAGE : float = 50.0
const DISSOLVE_TIME : float = 0.5

var enabled : bool = false
var targets : Array[Node2D] = []

var cooldown : float = 0.0 : set = _set_cooldown
var cooldown_max : float = 10.0

var sprite_explosion : Sprite2D = null
var sprite_hover : Sprite2D = null
var animation_player : AnimationPlayer = null

func _ready() -> void:
	sprite_explosion = %SpriteExplosion
	sprite_hover = %SpriteHover
	animation_player = %AnimationPlayer
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
	sprite_hover.visible = true
	targets.clear()
	return

func disable() -> void:
	sprite_explosion.material.set_shader_parameter("u_dissolve_value", 1.0)
	enabled = false
	sprite_hover.visible = false
	targets.clear()
	return

func can_enable() -> bool:
	return cooldown >= cooldown_max

func detonate() -> void:
	animation_player.play("explode")
	var tween : Tween = create_tween()
	tween.tween_property(sprite_explosion.material, "shader_parameter/u_dissolve_value", 0.0, DISSOLVE_TIME)
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

func _on_area_entered(area : Area2D) -> void:
	if(not enabled):
		return
	if(area is Entity):
		targets.append(area)
	return

func _on_area_exited(area: Area2D) -> void:
	if(not enabled):
		return
	if(area in targets):
		targets.erase(area)
	return
