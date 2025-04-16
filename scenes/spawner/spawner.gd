extends Area2D
class_name Spawner

signal spawned(entity : Entity)
signal corrupted(spawner : Spawner, old_team : TeamData.Team, new_team : TeamData.Team)

const SPAWNER : PackedScene = preload("res://scenes/spawner/spawner.tscn")
const SPAWNER_DATA : SpawnerData = preload("res://scenes/spawner/spawner_data.tres")
const ENTITY : PackedScene = preload("res://scenes/entity/entity.tscn")
const ENTITY_DATA : EntityData = preload("res://scenes/entity/entity_data.tres")

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
	stats.team_changed.connect(_on_stats_team_changed)
	return

static func create_spawner(data : SpawnerData) -> Spawner:
	var spawner : Spawner = SPAWNER.instantiate()
	spawner.stats = data
	return spawner

func spawn_entity() -> Entity:
	var entity : Entity = ENTITY.instantiate();
	#TODO better spawn mechanics
	entity.position = Vector2(randf_range(position.x - 100, position.x + 100), randf_range(position.y - 100, position.y + 100))
	entity.stats = _create_entity_data()
	return entity

func corrupt(source : Entity, damage : float) -> void:
	stats.corruption -= damage
	if(stats.corruption <= 0.0):
		var old_team : TeamData.Team = stats.team
		var new_team : TeamData.Team = source.stats.team
		stats.corruption = stats.corruption_max
		stats.team = new_team
		corrupted.emit(self, old_team, new_team)
	return

func _create_entity_data() -> EntityData:
	var entity_data : EntityData = ENTITY_DATA.duplicate()
	entity_data.team = stats.team
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
	collision_shape_radius.shape.radius = stats.spawn_radius
	spawn_timer.wait_time = stats.spawn_timeout
	return

func _on_stats_team_changed() -> void:
	_set_color(TeamData.TEAM_COLOR[stats.team])
	return

func _on_spawn_timer_timeout() -> void:
	spawned.emit(spawn_entity())
	return
