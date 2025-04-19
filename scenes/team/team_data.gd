extends Resource
class_name TeamData

enum Team {
	TEAM_0,
	TEAM_1,
	TEAM_2,
	TEAM_NONE
}

const TEAM_COLOR : Dictionary = {
	Team.TEAM_NONE : Color.WHITE,
	Team.TEAM_0 : Color(0.016, 0.486, 0.424),
	Team.TEAM_1 : Color(0.988, 0.737, 0.737),
	Team.TEAM_2 : Color(1.0, 0.847, 0.596)
}

var team : TeamData.Team = Team.TEAM_NONE : set = _set_team
var castle_data : CastleData = null
var spawner_data : SpawnerData = null

func _set_team(value : TeamData.Team) -> void:
	team = value
	emit_changed()
	return
