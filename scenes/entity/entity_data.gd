extends Resource
class_name EntityData

signal dying

var hitpoints : float = 100.0 : set = _set_hitpoints
var hitpoints_max : float = 100.0 : set = _set_hitpoints_max
var attack : float = 10.0
var attack_range : float = 32.0
var speed : float = 30.0

func _ready() -> void:
	return

func _set_hitpoints(value : float) -> void:
	hitpoints = value
	if(hitpoints <= 0.0):
		dying.emit()
	emit_changed()
	return

func _set_hitpoints_max(value : float) -> void:
	hitpoints_max = value
	hitpoints = hitpoints_max
	emit_changed()
	return
