extends Resource
class_name CastleData

signal spawner_grown

var corruption : float = 0.0 : set = _set_corruption # when this reaches 0, spawner switches to another team
var corruption_max : float = 100.0 : set = _set_corruption_max
var spawner_growth : float = 0.0 : set = _set_spawner_growth # creates a new spawner when it reaches `spawner_growth_max`
var spawner_growth_max : float = 200.0 : set = _set_spanwer_growth_max
var spawner_growth_speed : float = 10.0 : set = _set_spawner_growth_speed

func copy(castle_data : CastleData) -> void:
	corruption_max = castle_data.corruption_max
	spawner_growth_max = castle_data.spawner_growth_max
	spawner_growth_speed = castle_data.spawner_growth_speed
	return

func _set_corruption(value : float) -> void:
	corruption = value
	return

func _set_corruption_max(value : float) -> void:
	corruption_max = value
	emit_changed()
	return

func _set_spawner_growth(value : float) -> void:
	spawner_growth = value
	if(spawner_growth >= spawner_growth_max):
		spawner_growth = 0.0
		spawner_grown.emit()
	return

func _set_spanwer_growth_max(value : float) -> void:
	spawner_growth_max = value
	return

func _set_spawner_growth_speed(value : float) -> void:
	spawner_growth_speed = value
	emit_changed()
	return

func _to_string() -> String:
	var output : String = ""
	output += "Max Corruption: " + str(corruption_max) + "\n"
	output += "Spawner Growth Speed: " + str(spawner_growth_speed)
	return output
