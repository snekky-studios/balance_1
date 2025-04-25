extends Area2D
class_name DeathExplosion

const EXPLOSION_RADIUS_BASE : float = 32.0

const COLLISION_INDEX : Dictionary = {
	"world" : 1,
	"team0" : 2,
	"team1" : 3,
	"team2" : 4,
}

var team : TeamData.Team = TeamData.Team.TEAM_NONE : set = _set_team
var explosion_radius : float = 48.0 : set = _set_explosion_radius
var targets : Array[Node2D] = []

var sprite : Sprite2D = null
var collision_shape : CollisionShape2D = null
var animation_player : AnimationPlayer = null
var audio_stream_player : AudioStreamPlayer = null

func _ready() -> void:
	sprite = %Sprite
	collision_shape = %CollisionShape
	animation_player = %AnimationPlayer
	audio_stream_player = %AudioStreamPlayer
	return

func explode(damage : float) -> void:
	animation_player.play("explode")
	audio_stream_player.play()
	for target : Node2D in targets:
		if(target is Entity and target.is_alive()):
			target.stats.hitpoints -= damage
	return

func _set_team(value : TeamData.Team) -> void:
	team = value
	# update collision layers and masks
	match team:
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
		TeamData.Team.TEAM_NONE:
			set_collision_layer_value(COLLISION_INDEX["world"], true)
			set_collision_layer_value(COLLISION_INDEX["team0"], false)
			set_collision_layer_value(COLLISION_INDEX["team1"], false)
			set_collision_layer_value(COLLISION_INDEX["team2"], false)
			set_collision_mask_value(COLLISION_INDEX["world"], true)
			set_collision_mask_value(COLLISION_INDEX["team0"], false)
			set_collision_mask_value(COLLISION_INDEX["team1"], false)
			set_collision_mask_value(COLLISION_INDEX["team2"], false)
		_:
			print("error: entity team not valid - ", team)
	return

func _set_explosion_radius(value : float) -> void:
	explosion_radius = value
	collision_shape.shape.radius = explosion_radius
	var library : AnimationLibrary = animation_player.get_animation_library("")
	var animation : Animation = library.get_animation("explode")
	var track_idx : int = 2
	var key : int = animation.track_find_key(track_idx, 0.5)
	var animation_scale : Vector2 = Vector2(explosion_radius / EXPLOSION_RADIUS_BASE, explosion_radius / EXPLOSION_RADIUS_BASE)
	animation.track_set_key_value(track_idx, key, animation_scale)
	return

func _on_area_entered(area : Area2D) -> void:
	if(area is Entity):
		targets.append(area)
	return

func _on_area_exited(area: Area2D) -> void:
	if(area in targets):
		targets.erase(area)
	return
