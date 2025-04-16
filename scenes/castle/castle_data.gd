extends Resource
class_name CastleData

signal team_changed

var team : TeamData.Team = TeamData.Team.TEAM_NONE : set = _set_team

var corruption : float = 100.0 : set = _set_corruption # when this reaches 0, spawner switches to another team
var corruption_max : float = 100.0 : set = _set_corruption_max

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
