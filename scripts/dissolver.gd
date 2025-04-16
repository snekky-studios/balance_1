extends Node
class_name Dissolver

signal dissolved
signal undissolved

const DISSOLVE_TIME : float = 0.5

@export var sprite_2d : Sprite2D = null
var is_undissolving : bool = false

func _ready() -> void:
	set_undissolved()
	return

func is_dissolved() -> bool:
	return sprite_2d.material.get_shader_parameter("u_dissolve_value") == 0.0

# immidiately set the sprite to the dissolved state
func set_dissolved() -> void:
	sprite_2d.material.set_shader_parameter("u_dissolve_value", 0.0)
	return

# immidiately set the sprite to the undissolved state
func set_undissolved() -> void:
	sprite_2d.material.set_shader_parameter("u_dissolve_value", 1.0)
	return

# dissolve the references sprite over `DISSOLVE_TIME` period of time
func dissolve(dissolve_time : float = DISSOLVE_TIME) -> void:
	var tween : Tween = create_tween()
	tween.finished.connect(func() -> void: dissolved.emit())
	tween.tween_property(sprite_2d.material, "shader_parameter/u_dissolve_value", 0.0, dissolve_time)
	return

# undissolve the references sprite over `DISSOLVE_TIME` period of time
func undissolve(dissolve_time : float = DISSOLVE_TIME) -> void:
	is_undissolving = true
	var tween : Tween = create_tween()
	tween.finished.connect(func() -> void: undissolved.emit())
	tween.tween_property(sprite_2d.material, "shader_parameter/u_dissolve_value", 1.0, dissolve_time)
	return
