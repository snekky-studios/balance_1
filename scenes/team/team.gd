extends Node2D
class_name Team

signal castle_corrupted(castle : Castle, old_team : TeamData.Team, new_team : TeamData.Team)
signal spawner_corrupted(spawner : Spawner, old_team : TeamData.Team, new_team : TeamData.Team)
signal entity_dying(entity : Entity)
signal entity_attacked(target : Entity, damage : float)
signal entity_needs_target(entity : Entity)

const TEAM_DATA : TeamData = preload("res://scenes/team/team_data.tres")
const CASTLE_DATA : CastleData = preload("res://scenes/castle/castle_data.tres")
const SPAWNER_DATA : SpawnerData = preload("res://scenes/spawner/spawner_data.tres")

const CASTLE : PackedScene = preload("res://scenes/castle/castle.tscn")
const SPAWNER : PackedScene = preload("res://scenes/spawner/spawner.tscn")

var stats : TeamData = null

var castles : Array[Castle] = []
var spawners : Array[Spawner] = []
var entities : Array[Entity] = []

func _ready() -> void:
	stats = TEAM_DATA.duplicate()
	stats.castle_data = CASTLE_DATA.duplicate()
	stats.spawner_data = SPAWNER_DATA.duplicate()
	stats.changed.connect(_on_stats_changed)
	
	var new_castle : Castle = CASTLE.instantiate()
	add_castle(new_castle)
	
	var spawner : Spawner = SPAWNER.instantiate()
	add_spawner(spawner)
	return

func add_castle(castle : Castle) -> void:
	castle.stats = stats.castle_data
	add_child(castle)
	castle.corrupted.connect(_on_castle_corrupted)
	castles.append(castle)
	return

func swap_castle(castle : Castle, new_team : Team) -> void:
	# remove castle from self
	var position_temp : Vector2 = castle.global_position
	remove_child(castle)
	castle.corrupted.disconnect(_on_castle_corrupted)
	if(castle in castles):
		castles.erase(castle)
	# add castle to new team
	new_team.add_child(castle)
	castle.corrupted.connect(new_team._on_castle_corrupted)
	new_team.castles.append(castle)
	castle.global_position = position_temp
	return

func add_spawner(spawner : Spawner) -> void:
	spawner.stats = stats.spawner_data
	add_child(spawner)
	spawner.position = Vector2(randf_range(-100, 100), randf_range(-100, 100))
	spawner.spawned.connect(add_entity)
	spawner.corrupted.connect(_on_spawner_corrupted)
	spawners.append(spawner)
	return

func remove_spawner(spawner : Spawner) -> void:
	remove_child(spawner)
	if(spawner in spawners):
		spawners.erase(spawner)
	spawner.queue_free()
	return

func swap_spawner(spawner : Spawner, new_team : Team) -> void:
	# remove spawner from self
	var postition_temp : Vector2 = spawner.global_position
	remove_child(spawner)
	spawner.spawned.disconnect(add_entity)
	spawner.corrupted.disconnect(_on_spawner_corrupted)
	if(spawner in spawners):
		spawners.erase(spawner)
	# add spawner to new team
	spawner.stats.team = new_team.stats.team
	new_team.add_child(spawner)
	spawner.spawned.connect(new_team.add_entity)
	spawner.corrupted.connect(new_team._on_spawner_corrupted)
	new_team.spawners.append(spawner)
	spawner.global_position = postition_temp
	return

func add_entity(entity : Entity) -> void:
	add_child(entity)
	entity.stats.team = stats.team
	entity.dying.connect(_on_entity_dying)
	entity.dead.connect(_on_entity_dead)
	entity.attacked.connect(_on_entity_attacked)
	entity.need_target.connect(_on_entity_needs_target)
	entities.append(entity)
	return

func remove_entity(entity : Entity) -> void:
	if(entity in get_children()):
		remove_child(entity)
	if(entity in entities):
		entities.erase(entity)
	entity.queue_free()
	return

# returns an array of all nodes that are part of this team
func get_nodes() -> Array[Node2D]:
	var nodes : Array[Node2D] = []
	nodes.append_array(castles)
	nodes.append_array(spawners)
	nodes.append_array(entities)
	return nodes


func _on_stats_changed() -> void:
	for castle : Castle in castles:
		castle.stats = stats.castle_data
	for spawner : Spawner in spawners:
		spawner.stats = stats.spawner_data
	for entity : Entity in entities:
		entity.stats.team = stats.team
	return

func _on_castle_corrupted(corrupted_castle : Castle, old_team : TeamData.Team, new_team : TeamData.Team) -> void:
	castle_corrupted.emit(corrupted_castle, old_team, new_team)
	return

func _on_spawner_corrupted(spawner : Spawner, old_team : TeamData.Team, new_team : TeamData.Team) -> void:
	spawner_corrupted.emit(spawner, old_team, new_team)
	return

func _on_entity_dying(entity : Entity) -> void:
	entity_dying.emit(entity)
	return

func _on_entity_dead(entity : Entity) -> void:
	remove_entity(entity)
	return

func _on_entity_attacked(source : Entity, target : Node2D, damage : float) -> void:
	entity_attacked.emit(source, target, damage)
	return

func _on_entity_needs_target(entity : Entity) -> void:
	entity_needs_target.emit(entity)
	return
