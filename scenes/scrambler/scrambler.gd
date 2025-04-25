extends Area2D
class_name Scrambler

signal cooldown_updated(value : float)
signal entity_changed_team(entity : Entity, new_team : TeamData.Team)


var enabled : bool = false
var targets : Array[Node2D] = []

var cooldown : float = 0.0 : set = _set_cooldown
var cooldown_max : float = 20.0

var sprite_hover : Sprite2D = null
var animation_player : AnimationPlayer = null
var audio_stream_player : AudioStreamPlayer = null

func _ready() -> void:
	sprite_hover = %SpriteHover
	animation_player = %AnimationPlayer
	audio_stream_player = %AudioStreamPlayer
	disable()
	return

func _process(delta: float) -> void:
	if(not enabled):
		return
	position = get_global_mouse_position()
	return

func _physics_process(delta: float) -> void:
	cooldown += delta
	return

func _unhandled_input(event: InputEvent) -> void:
	if(not enabled):
		return
	if(event is InputEventMouseButton and event.is_pressed()):
		if(event.button_index == MOUSE_BUTTON_LEFT):
			scramble()
		else:
			disable()
	return

func enable() -> void:
	if(not can_enable()):
		return
	enabled = true
	sprite_hover.visible = true
	targets.clear()
	return

func disable() -> void:
	enabled = false
	sprite_hover.visible = false
	targets.clear()
	return

func can_enable() -> bool:
	return cooldown >= cooldown_max

func scramble() -> void:
	animation_player.play("scramble")
	audio_stream_player.play()
	for target : Node2D in targets:
		if(target is Entity):
			var teams : Array[TeamData.Team] = [TeamData.Team.TEAM_0, TeamData.Team.TEAM_1, TeamData.Team.TEAM_2]
			teams.erase(target.team)
			var new_team : TeamData.Team = teams.pick_random()
			entity_changed_team.emit(target, new_team)
	disable()
	cooldown = 0.0
	return

func _set_cooldown(value : float) -> void:
	cooldown = value
	if(cooldown >= cooldown_max):
		cooldown = cooldown_max
	cooldown_updated.emit(cooldown)
	return

func _on_area_entered(area: Area2D) -> void:
	if(not enabled):
		return
	if(area is Entity):
		targets.append(area)
	return

func _on_area_exited(area: Area2D) -> void:
	if(not enabled):
		return
	if(area in targets):
		targets.erase(area)
	return
