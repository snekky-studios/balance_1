extends Node
class_name Game

const WINDOW_WIDTH : int = 1280
const WINDOW_HEIGHT : int = 720

var score : int = 0

var battle : Battle = null
var bomb : Bomb = null
var scrambler : Scrambler = null
var blesser : Blesser = null
var timer_score : Timer = null
var ui : Control = null

var animation_player : AnimationPlayer = null
var label_ending_score : Label = null
var audio_stream_player : AudioStreamPlayer = null

func _ready() -> void:
	get_tree().paused = true
	battle = %Battle
	bomb = %Bomb
	scrambler = %Scrambler
	blesser = %Blesser
	timer_score = %TimerScore
	ui = %UI
	animation_player = %AnimationPlayer
	label_ending_score = %LabelEndingScore
	audio_stream_player = %AudioStreamPlayer
	
	battle.team_stats_changed.connect(ui.update_stats)
	battle.team_0.evolver.evolve_progress_updated.connect(ui._set_evolution_progress_0)
	battle.team_1.evolver.evolve_progress_updated.connect(ui._set_evolution_progress_1)
	battle.team_2.evolver.evolve_progress_updated.connect(ui._set_evolution_progress_2)
	battle.node_count_changed.connect(ui.update_node_counts.bind(battle.team_0, battle.team_1, battle.team_2))
	battle.one_team_remaining.connect(_on_battle_one_team_remaining)
	battle._on_team_stats_changed()
	
	bomb.disable()
	bomb.cooldown_updated.connect(ui._set_bomb_progress)
	
	scrambler.disable()
	scrambler.cooldown_updated.connect(ui._set_scrambler_progress)
	scrambler.entity_changed_team.connect(battle._on_node_corrupted)
	
	blesser.cooldown_updated.connect(ui._set_bless_progress)
	
	ui.button_bomb_pressed.connect(bomb.enable)
	ui.button_scrambler_pressed.connect(scrambler.enable)
	ui.button_bless_team_0_pressed.connect(_on_button_blessed_pressed.bind(TeamData.Team.TEAM_0))
	ui.button_bless_team_1_pressed.connect(_on_button_blessed_pressed.bind(TeamData.Team.TEAM_1))
	ui.button_bless_team_2_pressed.connect(_on_button_blessed_pressed.bind(TeamData.Team.TEAM_2))
	
	animation_player.play("opening")
	await get_tree().create_timer(10.0).timeout
	get_tree().paused = false
	audio_stream_player.play()
	return

func _on_battle_one_team_remaining() -> void:
	timer_score.stop()
	animation_player.play("ending")
	await get_tree().create_timer(1.0).timeout
	get_tree().paused = true
	return

func _on_button_blessed_pressed(team : TeamData.Team) -> void:
	blesser.cooldown = 0.0
	match(team):
		TeamData.Team.TEAM_0:
			battle.team_0.set_death_explosion()
		TeamData.Team.TEAM_1:
			battle.team_1.set_death_explosion()
		TeamData.Team.TEAM_2:
			battle.team_2.set_death_explosion()
		_:
			print("error: invalid team - ", team)
	return

func _on_timer_score_timeout() -> void:
	score += 1
	ui.set_score_count(score)
	label_ending_score.text = "You survived for " + str(score) + " seconds."
	return


func _on_button_retry_pressed() -> void:
	get_tree().reload_current_scene()
	return
