extends Area2D
class_name Spawner

signal spawned(entity : Entity)
signal corrupted(spawner : Spawner, new_team : TeamData.Team)

const SPAWNER : PackedScene = preload("res://scenes/spawner/spawner.tscn")
const SPAWNER_DATA : SpawnerData = preload("res://scenes/spawner/spawner_data.tres")
const ENTITY : PackedScene = preload("res://scenes/entity/entity.tscn")
const ENTITY_DATA : EntityData = preload("res://scenes/entity/entity_data.tres")

const MIN_RADIUS : float = 32.0

var team : TeamData.Team = TeamData.Team.TEAM_NONE : set = _set_team
var stats : SpawnerData = null

var sprite_core : Sprite2D = null
var sprite_radius : Sprite2D = null
var collision_shape_radius : CollisionShape2D = null
var spawn_timer : Timer = null

func _ready() -> void:
	sprite_core = %SpriteCore
	sprite_radius = %SpriteRadius
	collision_shape_radius = %CollisionShapeRadius
	spawn_timer = %SpawnTimer
	
	stats.changed.connect(_on_stats_changed)
	
	_on_stats_changed()
	spawn_timer.start()
	return

static func create_spawner(data : SpawnerData) -> Spawner:
	var spawner : Spawner = SPAWNER.instantiate()
	spawner.stats = data
	return spawner

func spawn_entity() -> Entity:
	var entity : Entity = ENTITY.instantiate();
	var radius : float = randf_range(MIN_RADIUS, stats.spawn_radius)
	var direction : Vector2 = Vector2.from_angle(randf_range(0.0, 2.0 * PI))
	entity.position = position + radius * direction
	entity.stats = _create_entity_data()
	return entity

func corrupt(source : Entity, damage : float) -> void:
	stats.corruption -= damage
	if(stats.corruption <= 0.0):
		var new_team : TeamData.Team = source.team
		stats.corruption = stats.corruption_max
		team = new_team
		corrupted.emit(self, new_team)
	return

func _create_entity_data() -> EntityData:
	var entity_data : EntityData = ENTITY_DATA.duplicate()
	entity_data.hitpoints_max = stats.entity_hitpoints_max
	entity_data.attack = stats.entity_attack
	entity_data.attack_range = stats.entity_attack_range
	entity_data.speed = stats.entity_speed
	return entity_data

func _set_color(color : Color) -> void:
	sprite_core.material.set_shader_parameter("color", color)
	sprite_radius.material.set_shader_parameter("color", color)
	return

func _on_stats_changed() -> void:
	sprite_radius.scale = Vector2((stats.spawn_radius * 2.0) / MIN_RADIUS, (stats.spawn_radius * 2.0) / MIN_RADIUS)
	spawn_timer.wait_time = stats.spawn_timeout
	return

func _set_team(value : TeamData.Team) -> void:
	team = value
	_set_color(TeamData.TEAM_COLOR[team])
	return

func _on_spawn_timer_timeout() -> void:
	spawned.emit(spawn_entity())
	return
