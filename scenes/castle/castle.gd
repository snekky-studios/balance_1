extends Area2D
class_name Castle

signal corrupted(castle : Castle, old_team : TeamData.Team, new_team : TeamData.Team)

var stats : CastleData = null

var sprite : Sprite2D = null

func _ready() -> void:
	sprite = %Sprite
	
	stats.changed.connect(_on_stats_changed)
	stats.team_changed.connect(_on_stats_team_changed)
	return

func corrupt(source : Entity, damage : float) -> void:
	stats.corruption -= damage
	if(stats.corruption <= 0.0):
		var old_team : TeamData.Team = stats.team
		var new_team : TeamData.Team = source.stats.team
		stats.corruption = stats.corruption_max
		stats.team = new_team
		corrupted.emit(self, old_team, new_team)
	return

func _set_color(color : Color) -> void:
	sprite.material.set_shader_parameter("color", color)
	return

func _on_stats_changed() -> void:
	return

func _on_stats_team_changed() -> void:
	_set_color(TeamData.TEAM_COLOR[stats.team])
	return
