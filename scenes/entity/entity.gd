extends Node2D
class_name Entity

const ENTITY_DATA : EntityData = preload("res://scenes/entity/entity_data.tres")

var stats : EntityData = null



func _ready() -> void:
	stats = ENTITY_DATA.duplicate()
	return

func _process(delta : float) -> void:

	return
