extends Node
class_name Wounder

@export var sprite_2d : Sprite2D = null

func _ready() -> void:
	set_unwounded()
	return

# immidiately set the sprite to the undissolved state
func set_unwounded() -> void:
	sprite_2d.material.set_shader_parameter("u_wound_value", 1.0)
	return

func set_wound(value : float) -> void:
	sprite_2d.material.set_shader_parameter("u_wound_value", value)
	return
