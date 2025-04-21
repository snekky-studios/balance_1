extends Node2D
class_name Team

const MAX_ENTITIES_PER_CASTLE : int = 128

signal castle_corrupted(castle : Castle, old_team : TeamData.Team, new_team : TeamData.Team)
signal spawner_corrupted(spawner : Spawner, old_team : TeamData.Team, new_team : TeamData.Team)
signal entity_dying(entity : Entity)
signal entity_attacked(target : Entity, damage : float)
signal entity_needs_target(entity : Entity)
signal evolve_progress_updated(value : float)
signal node_created

const TEAM_DATA : TeamData = preload("res://scenes/team/team_data.tres")
const CASTLE_DATA : CastleData = preload("res://scenes/castle/castle_data.tres")
const SPAWNER_DATA : SpawnerData = preload("res://scenes/spawner/spawner_data.tres")

const CASTLE : PackedScene = preload("res://scenes/castle/castle.tscn")
const SPAWNER : PackedScene = preload("res://scenes/spawner/spawner.tscn")

var stats : TeamData = null

var castles : Array[Castle] = []
var spawners : Array[Spawner] = []
var entities : Array[Entity] = []

var entities_have_death_explosion : bool = false

var evolver : Evolver = null
var timer_death_explosion : Timer = null

func _ready() -> void:
	evolver = %Evolver
	timer_death_explosion = %TimerDeathExplosion
	
	stats = TEAM_DATA.duplicate()
	stats.castle_data = CASTLE_DATA.duplicate()
	stats.spawner_data = SPAWNER_DATA.duplicate()
	stats.changed.connect(_on_stats_changed)
	
	evolver.castle_stats = stats.castle_data
	evolver.spawner_stats = stats.spawner_data
	evolver.evolved.connect(_on_evolver_evolved)
	evolver.evolve_progress_updated.connect(_on_evolver_evolve_progress_updated)
	evolver.randomize_stats()
	
	var new_castle : Castle = CASTLE.instantiate()
	add_castle(new_castle)
	
	var spawner : Spawner = SPAWNER.instantiate()
	add_spawner(new_castle, spawner)
	new_castle.add_spawner(spawner)
	return

func _physics_process(delta: float) -> void:
	for castle : Castle in castles:
		castle.increase_spawner_growth(delta)
	evolver.increase_evolve_progress(delta)
	return

func add_castle(castle : Castle) -> void:
	if(not castle.stats):
		castle.stats = CASTLE_DATA.duplicate()
	castle.stats.copy(stats.castle_data)
	add_child(castle)
	castle.team = stats.team
	castle.corrupted.connect(_on_castle_corrupted)
	castle.spawner_grown.connect(_on_castle_spawner_grown)
	castles.append(castle)
	node_created.emit()
	return

static func swap_castle(castle : Castle, new_team : Team) -> void:
	# remove castle from self
	var position_temp : Vector2 = castle.global_position
	var team : Team = castle.get_parent()
	team.remove_child(castle)
	castle.corrupted.disconnect(team._on_castle_corrupted)
	castle.spawner_grown.disconnect(team._on_castle_spawner_grown)
	team.castles.erase(castle)
	# add castle to new team
	new_team.add_child(castle)
	castle.team = new_team.stats.team
	castle.corrupted.connect(new_team._on_castle_corrupted)
	castle.spawner_grown.connect(new_team._on_castle_spawner_grown)
	new_team.castles.append(castle)
	castle.global_position = position_temp
	return

func add_spawner(castle : Castle, spawner : Spawner) -> void:
	if(not spawner.stats):
		spawner.stats = SPAWNER_DATA.duplicate()
	spawner.stats.copy(stats.spawner_data)
	add_child(spawner)
	spawner.team = stats.team
	var radius : float = randf_range(Castle.MIN_RADIUS, Castle.SPAWNER_RADIUS)
	var direction : Vector2 = Vector2.from_angle(randf_range(0.0, 2.0 * PI))
	spawner.position = castle.position + direction * radius
	spawner.spawned.connect(add_entity)
	spawner.corrupted.connect(_on_spawner_corrupted)
	spawners.append(spawner)
	node_created.emit()
	return

func remove_spawner(spawner : Spawner) -> void:
	remove_child(spawner)
	if(spawner in spawners):
		spawners.erase(spawner)
	spawner.queue_free()
	return

static func swap_spawner(spawner : Spawner, new_team : Team) -> void:
	# remove spawner from old team
	var postition_temp : Vector2 = spawner.global_position
	var team : Team = spawner.get_parent()
	team.remove_child(spawner)
	spawner.spawned.disconnect(team.add_entity)
	spawner.corrupted.disconnect(team._on_spawner_corrupted)
	team.spawners.erase(spawner)
	# add spawner to new team
	spawner.team = new_team.stats.team
	new_team.add_child(spawner)
	spawner.spawned.connect(new_team.add_entity)
	spawner.corrupted.connect(new_team._on_spawner_corrupted)
	new_team.spawners.append(spawner)
	spawner.global_position = postition_temp
	return

func add_entity(entity : Entity) -> void:
	if(num_entities() >= MAX_ENTITIES_PER_CASTLE * max(castles.size(), 1)):
		entity.queue_free()
		return
	add_child(entity)
	entity.team = stats.team
	if(entities_have_death_explosion):
		entity.has_death_explosion = true
	entity.dying.connect(_on_entity_dying)
	entity.dead.connect(_on_entity_dead)
	entity.attacked.connect(_on_entity_attacked)
	entity.need_target.connect(_on_entity_needs_target)
	entities.append(entity)
	node_created.emit()
	return

func remove_entity(entity : Entity) -> void:
	if(entity in get_children()):
		remove_child(entity)
	if(entity in entities):
		entities.erase(entity)
	entity.queue_free()
	return

static func swap_entity(entity : Entity, new_team : Team) -> void:
	# remove entity from old team
	var postition_temp : Vector2 = entity.global_position
	var team : Team = entity.get_parent()
	team.remove_child(entity)
	entity.dying.disconnect(team._on_entity_dying)
	entity.dead.disconnect(team._on_entity_dead)
	entity.attacked.disconnect(team._on_entity_attacked)
	entity.need_target.disconnect(team._on_entity_needs_target)
	team.entities.erase(entity)
	# add entity to new team
	entity.team = new_team.stats.team
	new_team.add_child(entity)
	entity.dying.connect(new_team._on_entity_dying)
	entity.dead.connect(new_team._on_entity_dead)
	entity.attacked.connect(new_team._on_entity_attacked)
	entity.need_target.connect(new_team._on_entity_needs_target)
	new_team.entities.append(entity)
	entity.global_position = postition_temp
	return

# applies the current stats to all structures
func update_structure_stats() -> void:
	for castle : Castle in castles:
		castle.stats.copy(stats.castle_data)
	for spawner : Spawner in spawners:
		spawner.stats.copy(stats.spawner_data)
	return

# returns an array of all nodes that are part of this team
func get_nodes() -> Array[Node2D]:
	var nodes : Array[Node2D] = []
	nodes.append_array(castles)
	nodes.append_array(spawners)
	nodes.append_array(entities)
	return nodes

func num_structures() -> int:
	return castles.size() + spawners.size()

func num_entities() -> int:
	return entities.size()

# all new entities will have a death explosion until the timer runs out and the ability is disabled
func set_death_explosion() -> void:
	entities_have_death_explosion = true
	timer_death_explosion.start()
	return

func _on_stats_changed() -> void:
	for castle : Castle in castles:
		castle.team = stats.team
		castle.stats.copy(stats.castle_data)
	for spawner : Spawner in spawners:
		spawner.team = stats.team
		spawner.stats.copy(stats.spawner_data)
	for entity : Entity in entities:
		entity.team = stats.team
	return

func _on_castle_corrupted(corrupted_castle : Castle, new_team : TeamData.Team) -> void:
	castle_corrupted.emit(corrupted_castle, new_team)
	return

func _on_castle_spawner_grown(castle : Castle) -> void:
	var spawner : Spawner = SPAWNER.instantiate()
	add_spawner(castle, spawner)
	castle.add_spawner(spawner)
	return

func _on_spawner_corrupted(spawner : Spawner, new_team : TeamData.Team) -> void:
	spawner_corrupted.emit(spawner, new_team)
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

func _on_evolver_evolved(stat_type : Evolver.StatType) -> void:
	update_structure_stats()
	#print(stat_type, "\n", stats.castle_data, "\n", stats.spawner_data)
	return

func _on_evolver_evolve_progress_updated(value : float) -> void:
	evolve_progress_updated.emit(value)
	return

func _on_timer_death_explosion_timeout() -> void:
	entities_have_death_explosion = false
	return
