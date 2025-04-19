extends Node
class_name Game

const WINDOW_WIDTH : int = 640
const WINDOW_HEIGHT : int = 360

var score : int = 0

var battle : Battle = null
var bomb : Bomb = null
var ui : Control = null

func _ready() -> void:
	battle = %Battle
	bomb = %Bomb
	ui = %UI
	
	battle.team_stats_changed.connect(ui.update_stats)
	battle.team_0.evolver.evolve_progress_updated.connect(ui._set_evolution_progress_0)
	battle.team_1.evolver.evolve_progress_updated.connect(ui._set_evolution_progress_1)
	battle.team_2.evolver.evolve_progress_updated.connect(ui._set_evolution_progress_2)
	battle._on_team_stats_changed()
	
	bomb.disable()
	bomb.cooldown_updated.connect(ui._set_bomb_progress)
	
	ui.button_bomb_pressed.connect(bomb.enable)
	
	return

func _on_timer_score_timeout() -> void:
	score += 1
	ui.set_score_count(score)
	return
