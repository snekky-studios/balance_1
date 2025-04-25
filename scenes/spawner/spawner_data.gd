extends Resource
class_name SpawnerData

var corruption : float = 0.0 : set = _set_corruption # when this reaches 0, spawner switches to another team
var corruption_max : float = 100.0 : set = _set_corruption_max
var spawn_timeout : float = 3.0 : set = _set_spawn_timeout
var spawn_radius : float = 48.0 : set = _set_spawn_radius

var entity_hitpoints_max : float = 100.0 : set = _set_entity_hitpoints_max
var entity_attack : float = 10.0 : set = _set_entity_attack
var entity_attack_range : float = 34.0 : set = _set_entity_attack_range
var entity_speed : float = 30.0 : set = _set_entity_speed

func copy(spawner_data : SpawnerData) -> void:
	corruption_max = spawner_data.corruption_max
	spawn_timeout = spawner_data.spawn_timeout
	spawn_radius = spawner_data.spawn_radius
	entity_hitpoints_max = spawner_data.entity_hitpoints_max
	entity_attack = spawner_data.entity_attack
	entity_attack_range = spawner_data.entity_attack_range
	entity_speed = spawner_data.entity_speed
	return

func _set_corruption(value : float) -> void:
	corruption = value
	return

func _set_corruption_max(value : float) -> void:
	corruption_max = value
	#corruption = corruption_max
	emit_changed()
	return

func _set_spawn_timeout(value : float) -> void:
	spawn_timeout = value
	emit_changed()
	return

func _set_spawn_radius(value : float) -> void:
	spawn_radius = value
	emit_changed()
	return

func _set_entity_hitpoints_max(value : float) -> void:
	entity_hitpoints_max = value
	emit_changed()
	return

func _set_entity_attack(value : float) -> void:
	entity_attack = value
	emit_changed()
	return

func _set_entity_attack_range(value : float) -> void:
	entity_attack_range = value
	emit_changed()
	return

func _set_entity_speed(value : float) -> void:
	entity_speed = value
	emit_changed()
	return

func _to_string() -> String:
	var output : String = ""
	output += "Max Corruption: " + str(corruption_max) + "\n"
	output += "Spawn Timeout: " + str(spawn_timeout) + "\n"
	output += "Spawn Radius: " + str(spawn_radius) + "\n"
	output += "Entity Max Hitpoints:" + str(entity_hitpoints_max) + "\n"
	output += "Entity Attack: " + str(entity_attack) + "\n"
	output += "Entity Attack Range: " + str(entity_attack_range) + "\n"
	output += "Entity Speed: " + str(entity_speed)
	return output
