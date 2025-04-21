extends Node
class_name Blesser

signal cooldown_updated(value : float)

var cooldown : float = 0.0 : set = _set_cooldown
var cooldown_max : float = 90.0

func _ready() -> void:
	return

func _physics_process(delta: float) -> void:
	cooldown += delta
	return

func _set_cooldown(value : float) -> void:
	cooldown = value
	if(cooldown >= cooldown_max):
		cooldown = cooldown_max
	cooldown_updated.emit(cooldown)
	return
