extends Node
class_name Battle

signal team_stats_changed
signal node_count_changed
signal one_team_remaining

var team_0 : Team = null
var team_1 : Team = null
var team_2 : Team = null

var next_team_retarget : Team = null

func _ready() -> void:
	team_0 = %Team0
	team_1 = %Team1
	team_2 = %Team2
	
	next_team_retarget = team_0
	
	team_0.stats.team = TeamData.Team.TEAM_0
	team_1.stats.team = TeamData.Team.TEAM_1
	team_2.stats.team = TeamData.Team.TEAM_2
	
	team_0.stats.castle_data.changed.connect(_on_team_stats_changed)
	team_0.stats.spawner_data.changed.connect(_on_team_stats_changed)
	team_1.stats.castle_data.changed.connect(_on_team_stats_changed)
	team_1.stats.spawner_data.changed.connect(_on_team_stats_changed)
	team_2.stats.castle_data.changed.connect(_on_team_stats_changed)
	team_2.stats.spawner_data.changed.connect(_on_team_stats_changed)
	
	team_0.castle_corrupted.connect(_on_node_corrupted)
	team_0.spawner_corrupted.connect(_on_node_corrupted)
	team_0.entity_dying.connect(_on_entity_dying)
	team_0.entity_attacked.connect(_resolve_damage)
	team_0.entity_needs_target.connect(_set_target)
	team_0.node_created.connect(func() -> void: node_count_changed.emit())
	
	team_1.castle_corrupted.connect(_on_node_corrupted)
	team_1.spawner_corrupted.connect(_on_node_corrupted)
	team_1.entity_dying.connect(_on_entity_dying)
	team_1.entity_attacked.connect(_resolve_damage)
	team_1.entity_needs_target.connect(_set_target)
	team_1.node_created.connect(func() -> void: node_count_changed.emit())
	
	team_2.castle_corrupted.connect(_on_node_corrupted)
	team_2.spawner_corrupted.connect(_on_node_corrupted)
	team_2.entity_dying.connect(_on_entity_dying)
	team_2.entity_attacked.connect(_resolve_damage)
	team_2.entity_needs_target.connect(_set_target)
	team_2.node_created.connect(func() -> void: node_count_changed.emit())
	return

# sets the entity's target to the closest opposing node
func _set_target(entity: Entity) -> void:
	var nodes_opposing_teams : Array[Node2D] = _get_nodes_opposing_teams(entity)
	# no opposing nodes, so no target available
	if(nodes_opposing_teams.size() == 0):
		one_team_remaining.emit()
		entity.target = null
		return
	var distances_nodes_opposing_teams : Array[float] = _get_distances(entity, nodes_opposing_teams)
	var min_distance : float = distances_nodes_opposing_teams.min()
	var index_node_min_distance : int = distances_nodes_opposing_teams.find(min_distance)
	entity.target = nodes_opposing_teams[index_node_min_distance]
	return

# sets the entity's target to the closest opposing node
#func _set_target(entity: Entity) -> void:
	#var nodes_opposing_teams : Array[Node2D] = _get_nodes_opposing_teams(entity)
	## no opposing nodes, so no target available
	#if(nodes_opposing_teams.size() == 0):
		#entity.target = null
		#return
	#var distances_nodes_opposing_teams : Array[float] = []
	#for node_opponent : Node2D in nodes_opposing_teams:
		#var distance : float = _distance(entity, node_opponent)
		#distances_nodes_opposing_teams.append(distance)
		## if we find a target in range, set it immediately and exit to prevent wasting time looping through the rest
		#if(distance < entity.stats.attack_range):
			#entity.target = node_opponent
			#return
	## no target found in range, set target as nearest node
	#var min_distance : float = distances_nodes_opposing_teams.min()
	#var index_node_min_distance : int = distances_nodes_opposing_teams.find(min_distance)
	#entity.target = nodes_opposing_teams[index_node_min_distance]
	#return

# resets the target of all entities on all teams
func _set_target_all_entities() -> void:
	var entities : Array[Entity] = []
	entities.append_array(team_0.entities)
	entities.append_array(team_1.entities)
	entities.append_array(team_2.entities)
	for entity : Entity in entities:
		_set_target(entity)
	return

# sets the target of entities on team
func _set_target_entities_on_team(team : Team) -> void:
	for entity : Entity in team.entities:
		_set_target(entity)
	return

# returns a list of all nodes on opposing teams from entity
func _get_nodes_opposing_teams(entity: Entity) -> Array[Node2D]:
	var nodes_opposing_teams : Array[Node2D] = []
	match entity.team:
		TeamData.Team.TEAM_0:
			nodes_opposing_teams.append_array(team_1.get_nodes())
			nodes_opposing_teams.append_array(team_2.get_nodes())
		TeamData.Team.TEAM_1:
			nodes_opposing_teams.append_array(team_0.get_nodes())
			nodes_opposing_teams.append_array(team_2.get_nodes())
		TeamData.Team.TEAM_2:
			nodes_opposing_teams.append_array(team_0.get_nodes())
			nodes_opposing_teams.append_array(team_1.get_nodes())
		_:
			print("error: entity belongs to no team")
	return nodes_opposing_teams

# returns a list of distances from the node to each node in the opposing teams
func _get_distances(node: Node2D, nodes_opposing_teams : Array[Node2D]) -> Array[float]:
	var entity_distances : Array[float] = []
	for node_opponent : Node2D in nodes_opposing_teams:
		entity_distances.append(_distance(node, node_opponent))
	return entity_distances

# returns the distance in pixels between two nodes
func _distance(node0 : Node2D, node1 : Node2D) -> float:
	return node0.global_position.distance_to(node1.global_position)

# removes `damage` from `entity`s hitpoints
func _resolve_damage(source : Entity, target : Node2D, damage : float) -> void:
	if(target is Entity):
		target.stats.hitpoints -= damage
	elif(target is Spawner):
		target.corrupt(source, damage)
	elif(target is Castle):
		target.corrupt(source, damage)
	else:
		print("error: invalid target type - " + str(target))
	return

func _on_node_corrupted(node : Node2D, new_team : TeamData.Team) -> void:
	var new_team_instance : Team = null
	match new_team:
		TeamData.Team.TEAM_0:
			new_team_instance = team_0
		TeamData.Team.TEAM_1:
			new_team_instance = team_1
		TeamData.Team.TEAM_2:
			new_team_instance = team_2
		_:
			print("error: node's new team invalid - " + str(node) + " " + str(new_team))
	if(node is Entity):
		Team.swap_entity(node, new_team_instance)
	elif(node is Spawner):
		Team.swap_spawner(node, new_team_instance)
	elif(node is Castle):
		Team.swap_castle(node, new_team_instance)
		var spawners_copy : Array[Spawner] = node.spawners.duplicate()
		for spawner : Spawner in spawners_copy:
			Team.swap_spawner(spawner, new_team_instance)
	node_count_changed.emit()
	#_set_target_all_entities()
	return

func _on_entity_dying(entity : Entity) -> void:
	var team : TeamData.Team = entity.team
	# remove entity from the target pool
	match(team):
		TeamData.Team.TEAM_0:
			team_0.entities.erase(entity)
		TeamData.Team.TEAM_1:
			team_1.entities.erase(entity)
		TeamData.Team.TEAM_2:
			team_2.entities.erase(entity)
		_:
			print("error: entity belongs to no team")
	node_count_changed.emit()
	return

func _on_team_stats_changed() -> void:
	team_stats_changed.emit(team_0.stats, team_1.stats, team_2.stats)
	return

func _on_timer_retarget_timeout() -> void:
	#_set_target_all_entities()
	match(next_team_retarget):
		team_0:
			_set_target_entities_on_team(team_0)
			next_team_retarget = team_1
		team_1:
			_set_target_entities_on_team(team_1)
			next_team_retarget = team_2
		team_2:
			_set_target_entities_on_team(team_2)
			next_team_retarget = team_0
		_:
			print("error: invalid next_team_retarget - ", next_team_retarget)
	return
