extends Node2D
class_name Test

const ENTITY : PackedScene = preload("res://scenes/entity/entity.tscn")

var battle : Battle = null



func _ready() -> void:
	battle = %Battle

	return
