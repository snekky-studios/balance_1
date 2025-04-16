extends Resource
class_name TeamData

enum Team {
	TEAM_NONE,
	TEAM_0,
	TEAM_1,
	TEAM_2
}

const TEAM_COLOR : Dictionary = {
	Team.TEAM_NONE : Color.WHITE,
	Team.TEAM_0 : Color(0.5, 1.0, 1.0, 1.0),
	Team.TEAM_1 : Color(1.0, 0.5, 1.0, 1.0),
	Team.TEAM_2 : Color(1.0, 1.0, 0.5, 1.0)
}

var team : TeamData.Team = Team.TEAM_NONE : set = _set_team
var castle_data : CastleData = null
var spawner_data : SpawnerData = null


func _set_team(value : TeamData.Team) -> void:
	team = value
	castle_data.team = team
	spawner_data.team = team
	emit_changed()
	return
