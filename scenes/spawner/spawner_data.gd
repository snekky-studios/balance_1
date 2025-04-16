extends Resource
class_name SpawnerData

signal team_changed

var team : TeamData.Team = TeamData.Team.TEAM_NONE : set = _set_team

var corruption : float = 100.0 : set = _set_corruption # when this reaches 0, spawner switches to another team
var corruption_max : float = 100.0 : set = _set_corruption_max
var spawn_timeout : float = 10.0 : set = _set_spawn_timeout
var spawn_radius : float = 48.0 : set = _set_spawn_radius

var entity_hitpoints_max : float = 100.0
var entity_attack : float = 10.0
var entity_attack_range : float = 32.0
var entity_speed : float = 30.0

func _set_team(value : TeamData.Team) -> void:
	team = value
	team_changed.emit()
	return

func _set_corruption(value : float) -> void:
	corruption = value
	return

func _set_corruption_max(value : float) -> void:
	corruption_max = value
	corruption = corruption_max
	return

func _set_spawn_timeout(value : float) -> void:
	spawn_timeout = value
	emit_changed()
	return

func _set_spawn_radius(value : float) -> void:
	spawn_radius = value
	emit_changed()
	return
