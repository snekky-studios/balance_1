extends Resource
class_name EntityData

signal dead

var hitpoints : float = 100.0 : set = _set_hitpoints
var attack : float = 10.0

func _ready() -> void:
	return

func _set_hitpoints(value : int) -> void:
	hitpoints = value
	if(hitpoints <= 0):
		dead.emit()
	emit_changed()
	return
