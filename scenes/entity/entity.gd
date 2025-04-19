extends RigidBody2D
class_name Entity

signal dying(entity : Entity)
signal dead(entity : Entity)
signal attacked(source : Entity, target : Node2D, damage : float) # emits when unit makes an attack
signal need_target(entity : Entity)

const ENTITY_DATA : EntityData = preload("res://scenes/entity/entity_data.tres")

const COLLISION_INDEX : Dictionary = {
	"world" : 1,
	"team0" : 2,
	"team1" : 3,
	"team2" : 4,
}

var team : TeamData.Team = TeamData.Team.TEAM_NONE : set = _set_team

var stats : EntityData = null
@export var target : Node2D = null
var in_range : bool = false # true if target is within attack range
var in_combat : bool = false # true if actively attacking target

var sprite : Sprite2D = null
var dissolver : Dissolver = null
var wounder : Wounder = null

func _ready() -> void:
	sprite = %Sprite
	dissolver = %Dissolver
	wounder = %Wounder

	stats.changed.connect(_on_stats_changed)
	stats.dying.connect(_on_dying)
	
	sprite.material.set_shader_parameter("u_wound_value", 1.0)
	sprite.material.set_shader_parameter("u_dissolve_value", 1.0)
	
	dissolver.dissolved.connect(_on_dissolved)
	
	wounder.set_unwounded()
	
	contact_monitor = true
	max_contacts_reported = 1
	return

func _physics_process(delta: float) -> void:
	if(target):
		if(not in_range):
			var distance : float = _distance(self, target)
			in_range = distance < stats.attack_range
			var direction : Vector2 = (target.global_position - global_position).normalized()
			linear_velocity = direction * stats.speed
		else:
			linear_velocity = Vector2.ZERO
			in_combat = true
			_attack(delta)
	else:
		linear_velocity = Vector2.ZERO
		in_range = false
		in_combat = false
		need_target.emit(self)
	return

func set_stats(data : EntityData) -> void:
	stats.team = data.team
	stats.hitpoints_max = data.hitpoints_max
	stats.attack = data.attack
	stats.attack_range = data.attack_range
	stats.speed = data.speed
	return

func _attack(delta : float) -> void:
	var damage : float = stats.attack * delta
	attacked.emit(self, target, damage)
	return

# returns the distance in pixels between two nodes
func _distance(node0 : Node2D, node1 : Node2D) -> float:
	return node0.global_position.distance_to(node1.global_position)

func _set_color(color : Color) -> void:
	sprite.material.set_shader_parameter("color", color)
	return

func _on_stats_changed() -> void:
	wounder.set_wound(stats.hitpoints / stats.hitpoints_max)
	return

func _set_team(value : TeamData.Team) -> void:
	team = value
	_set_color(TeamData.TEAM_COLOR[team])
	# update collision layers and masks
	match team:
		TeamData.Team.TEAM_NONE:
			set_collision_layer_value(COLLISION_INDEX["world"], true)
			set_collision_layer_value(COLLISION_INDEX["team0"], false)
			set_collision_layer_value(COLLISION_INDEX["team1"], false)
			set_collision_layer_value(COLLISION_INDEX["team2"], false)
			set_collision_mask_value(COLLISION_INDEX["world"], true)
			set_collision_mask_value(COLLISION_INDEX["team0"], false)
			set_collision_mask_value(COLLISION_INDEX["team1"], false)
			set_collision_mask_value(COLLISION_INDEX["team2"], false)
		TeamData.Team.TEAM_0:
			set_collision_layer_value(COLLISION_INDEX["world"], false)
			set_collision_layer_value(COLLISION_INDEX["team0"], true)
			set_collision_layer_value(COLLISION_INDEX["team1"], false)
			set_collision_layer_value(COLLISION_INDEX["team2"], false)
			set_collision_mask_value(COLLISION_INDEX["world"], true)
			set_collision_mask_value(COLLISION_INDEX["team0"], false)
			set_collision_mask_value(COLLISION_INDEX["team1"], true)
			set_collision_mask_value(COLLISION_INDEX["team2"], true)
		TeamData.Team.TEAM_1:
			set_collision_layer_value(COLLISION_INDEX["world"], false)
			set_collision_layer_value(COLLISION_INDEX["team0"], false)
			set_collision_layer_value(COLLISION_INDEX["team1"], true)
			set_collision_layer_value(COLLISION_INDEX["team2"], false)
			set_collision_mask_value(COLLISION_INDEX["world"], true)
			set_collision_mask_value(COLLISION_INDEX["team0"], true)
			set_collision_mask_value(COLLISION_INDEX["team1"], false)
			set_collision_mask_value(COLLISION_INDEX["team2"], true)
		TeamData.Team.TEAM_2:
			set_collision_layer_value(COLLISION_INDEX["world"], false)
			set_collision_layer_value(COLLISION_INDEX["team0"], false)
			set_collision_layer_value(COLLISION_INDEX["team1"], false)
			set_collision_layer_value(COLLISION_INDEX["team2"], true)
			set_collision_mask_value(COLLISION_INDEX["world"], true)
			set_collision_mask_value(COLLISION_INDEX["team0"], true)
			set_collision_mask_value(COLLISION_INDEX["team1"], true)
			set_collision_mask_value(COLLISION_INDEX["team2"], false)
	return

func _on_dying() -> void:
	dissolver.dissolve()
	dying.emit(self)
	return

func _on_dissolved() -> void:
	dead.emit(self)
	return
