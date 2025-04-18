extends Area2D
class_name Castle

const SPAWNER_RADIUS : float = 128.0
const MIN_RADIUS : float = 32.0

signal corrupted(castle : Castle, new_team : TeamData.Team)
signal spawner_grown(castle : Castle, team : TeamData.Team)

var team : TeamData.Team = TeamData.Team.TEAM_NONE : set = _set_team
var stats : CastleData = null
var spawners : Array[Spawner] = []

var sprite : Sprite2D = null

func _ready() -> void:
	sprite = %Sprite
	
	stats.changed.connect(_on_stats_changed)
	stats.spawner_grown.connect(_on_stats_spawner_grown)
	return

func corrupt(source : Entity, damage : float) -> void:
	stats.corruption -= damage
	if(stats.corruption <= 0.0):
		var new_team : TeamData.Team = source.team
		stats.corruption = stats.corruption_max
		team = new_team
		corrupted.emit(self, new_team)
	return

func increase_spawner_growth(delta : float) -> void:
	stats.spawner_growth += stats.spawner_growth_speed * delta
	return

func add_spawner(spawner : Spawner) -> void:
	if(not spawner in spawners):
		spawners.append(spawner)
	return

func _set_color(color : Color) -> void:
	sprite.material.set_shader_parameter("color", color)
	return

func _on_stats_changed() -> void:
	return

func _set_team(value : TeamData.Team) -> void:
	team = value
	_set_color(TeamData.TEAM_COLOR[team])
	return

func _on_stats_spawner_grown() -> void:
	spawner_grown.emit(self)
	return
