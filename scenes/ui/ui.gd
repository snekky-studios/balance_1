extends Control
class_name UI

signal button_bomb_pressed
signal button_scrambler_pressed
signal button_bless_team_0_pressed
signal button_bless_team_1_pressed
signal button_bless_team_2_pressed

var stats_expanded : bool = false

var progress_bar_bomb : ProgressBar = null
var button_bomb : Button = null
var progress_bar_scrambler : ProgressBar = null
var button_scrambler : Button = null
var progress_bar_bless : ProgressBar = null
var button_bless : Button = null
var vbox_teams : VBoxContainer = null
var button_bless_team_0 : Button = null
var button_bless_team_1 : Button = null
var button_bless_team_2 : Button = null

var button_expand : Button = null
var button_team_0 : Button = null
var button_team_1 : Button = null
var button_team_2 : Button = null

var vbox_stats_team_0 : VBoxContainer = null
var vbox_stats_team_1 : VBoxContainer = null
var vbox_stats_team_2 : VBoxContainer = null

var label_structure_count_0 : Label = null
var label_entities_count_0 : Label = null
var label_castle_corruption_amount_0 : Label = null
var label_castle_spawner_growth_speed_amount_0 : Label = null
var label_spawner_corruption_amount_0 : Label = null
var label_spawner_spawn_timeout_amount_0 : Label = null
var label_spawner_spawn_radius_amount_0 : Label = null
var label_entity_hitpoints_amount_0 : Label = null
var label_entity_attack_amount_0 : Label = null
var label_entity_attack_range_amount_0 : Label = null
var label_entity_speed_amount_0 : Label = null

var label_structure_count_1 : Label = null
var label_entities_count_1 : Label = null
var label_castle_corruption_amount_1 : Label = null
var label_castle_spawner_growth_speed_amount_1 : Label = null
var label_spawner_corruption_amount_1 : Label = null
var label_spawner_spawn_timeout_amount_1 : Label = null
var label_spawner_spawn_radius_amount_1 : Label = null
var label_entity_hitpoints_amount_1 : Label = null
var label_entity_attack_amount_1 : Label = null
var label_entity_attack_range_amount_1 : Label = null
var label_entity_speed_amount_1 : Label = null

var label_structure_count_2 : Label = null
var label_entities_count_2 : Label = null
var label_castle_corruption_amount_2 : Label = null
var label_castle_spawner_growth_speed_amount_2 : Label = null
var label_spawner_corruption_amount_2 : Label = null
var label_spawner_spawn_timeout_amount_2 : Label = null
var label_spawner_spawn_radius_amount_2 : Label = null
var label_entity_hitpoints_amount_2 : Label = null
var label_entity_attack_amount_2 : Label = null
var label_entity_attack_range_amount_2 : Label = null
var label_entity_speed_amount_2 : Label = null

var progress_bar_evolution_0 : ProgressBar = null
var progress_bar_evolution_1 : ProgressBar = null
var progress_bar_evolution_2 : ProgressBar = null

var label_score_count : Label = null

func _ready() -> void:
	progress_bar_bomb = %ProgressBarBomb
	button_bomb = %ButtonBomb
	progress_bar_scrambler = %ProgressBarScrambler
	button_scrambler = %ButtonScrambler
	progress_bar_bless = %ProgressBarBless
	button_bless = %ButtonBless
	vbox_teams = %VBoxTeams
	button_bless_team_0 = %ButtonBlessTeam0
	button_bless_team_1 = %ButtonBlessTeam1
	button_bless_team_2 = %ButtonBlessTeam2
	
	button_expand = %ButtonExpand
	button_team_0 = %ButtonTeam0
	button_team_1 = %ButtonTeam1
	button_team_2 = %ButtonTeam2
	vbox_stats_team_0 = %VBoxStatsTeam0
	vbox_stats_team_1 = %VBoxStatsTeam1
	vbox_stats_team_2 = %VBoxStatsTeam2
	
	label_structure_count_0 = %LabelStructuresCount0
	label_entities_count_0 = %LabelEntitiesCount0
	label_castle_corruption_amount_0 = %LabelCastleCorruptionAmount0
	label_castle_spawner_growth_speed_amount_0 = %LabelCastleSpawnerGrowthSpeedAmount0
	label_spawner_corruption_amount_0 = %LabelSpawnerCorruptionAmount0
	label_spawner_spawn_timeout_amount_0 = %LabelSpawnerSpawnTimeoutAmount0
	label_spawner_spawn_radius_amount_0 = %LabelSpawnerSpawnRadiusAmount0
	label_entity_hitpoints_amount_0 = %LabelEntityHitpointsAmount0
	label_entity_attack_amount_0 = %LabelEntityAttackAmount0
	label_entity_attack_range_amount_0 = %LabelEntityAttackRangeAmount0
	label_entity_speed_amount_0 = %LabelEntitySpeedAmount0
	
	label_structure_count_1 = %LabelStructuresCount1
	label_entities_count_1 = %LabelEntitiesCount1
	label_castle_corruption_amount_1 = %LabelCastleCorruptionAmount1
	label_castle_spawner_growth_speed_amount_1 = %LabelCastleSpawnerGrowthSpeedAmount1
	label_spawner_corruption_amount_1 = %LabelSpawnerCorruptionAmount1
	label_spawner_spawn_timeout_amount_1 = %LabelSpawnerSpawnTimeoutAmount1
	label_spawner_spawn_radius_amount_1 = %LabelSpawnerSpawnRadiusAmount1
	label_entity_hitpoints_amount_1 = %LabelEntityHitpointsAmount1
	label_entity_attack_amount_1 = %LabelEntityAttackAmount1
	label_entity_attack_range_amount_1 = %LabelEntityAttackRangeAmount1
	label_entity_speed_amount_1 = %LabelEntitySpeedAmount1
	
	label_structure_count_2 = %LabelStructuresCount2
	label_entities_count_2 = %LabelEntitiesCount2
	label_castle_corruption_amount_2 = %LabelCastleCorruptionAmount2
	label_castle_spawner_growth_speed_amount_2 = %LabelCastleSpawnerGrowthSpeedAmount2
	label_spawner_corruption_amount_2 = %LabelSpawnerCorruptionAmount2
	label_spawner_spawn_timeout_amount_2 = %LabelSpawnerSpawnTimeoutAmount2
	label_spawner_spawn_radius_amount_2 = %LabelSpawnerSpawnRadiusAmount2
	label_entity_hitpoints_amount_2 = %LabelEntityHitpointsAmount2
	label_entity_attack_amount_2 = %LabelEntityAttackAmount2
	label_entity_attack_range_amount_2 = %LabelEntityAttackRangeAmount2
	label_entity_speed_amount_2 = %LabelEntitySpeedAmount2
	
	progress_bar_evolution_0 = %ProgressBarEvolution0
	progress_bar_evolution_1 = %ProgressBarEvolution1
	progress_bar_evolution_2 = %ProgressBarEvolution2
	
	label_score_count = %LabelScoreCount
	return

func update_node_counts(team_0 : Team, team_1 : Team, team_2 : Team) -> void:
	label_structure_count_0.text = str(snappedi(team_0.num_structures(), 1))
	label_entities_count_0.text = str(snappedi(team_0.num_entities(), 1))
	label_structure_count_1.text = str(snappedi(team_1.num_structures(), 1))
	label_entities_count_1.text = str(snappedi(team_1.num_entities(), 1))
	label_structure_count_2.text = str(snappedi(team_2.num_structures(), 1))
	label_entities_count_2.text = str(snappedi(team_2.num_entities(), 1))
	return

func update_stats(data_team_0 : TeamData, data_team_1 : TeamData, data_team_2 : TeamData) -> void:
	label_castle_corruption_amount_0.text = str(snappedi(data_team_0.castle_data.corruption_max, 1))
	label_castle_spawner_growth_speed_amount_0.text = str(snappedf(data_team_0.castle_data.spawner_growth_speed, 0.1))
	label_spawner_corruption_amount_0.text = str(snappedi(data_team_0.spawner_data.corruption_max, 1))
	label_spawner_spawn_timeout_amount_0.text = str(snappedf(data_team_0.spawner_data.spawn_timeout, 0.1))
	label_spawner_spawn_radius_amount_0.text = str(snappedi(data_team_0.spawner_data.spawn_radius, 1))
	label_entity_hitpoints_amount_0.text = str(snappedi(data_team_0.spawner_data.entity_hitpoints_max, 1))
	label_entity_attack_amount_0.text = str(snappedi(data_team_0.spawner_data.entity_attack, 1))
	label_entity_attack_range_amount_0.text = str(snappedi(data_team_0.spawner_data.entity_attack_range, 1))
	label_entity_speed_amount_0.text = str(snappedi(data_team_0.spawner_data.entity_speed, 1))
	
	label_castle_corruption_amount_1.text = str(snappedi(data_team_1.castle_data.corruption_max, 1))
	label_castle_spawner_growth_speed_amount_1.text = str(snappedf(data_team_1.castle_data.spawner_growth_speed, 0.1))
	label_spawner_corruption_amount_1.text = str(snappedi(data_team_1.spawner_data.corruption_max, 1))
	label_spawner_spawn_timeout_amount_1.text = str(snappedf(data_team_1.spawner_data.spawn_timeout, 0.1))
	label_spawner_spawn_radius_amount_1.text = str(snappedi(data_team_1.spawner_data.spawn_radius, 1))
	label_entity_hitpoints_amount_1.text = str(snappedi(data_team_1.spawner_data.entity_hitpoints_max, 1))
	label_entity_attack_amount_1.text = str(snappedi(data_team_1.spawner_data.entity_attack, 1))
	label_entity_attack_range_amount_1.text = str(snappedi(data_team_1.spawner_data.entity_attack_range, 1))
	label_entity_speed_amount_1.text = str(snappedi(data_team_1.spawner_data.entity_speed, 1))
	
	label_castle_corruption_amount_2.text = str(snappedi(data_team_2.castle_data.corruption_max, 1))
	label_castle_spawner_growth_speed_amount_2.text = str(snappedf(data_team_2.castle_data.spawner_growth_speed, 0.1))
	label_spawner_corruption_amount_2.text = str(snappedi(data_team_2.spawner_data.corruption_max, 1))
	label_spawner_spawn_timeout_amount_2.text = str(snappedf(data_team_2.spawner_data.spawn_timeout, 0.1))
	label_spawner_spawn_radius_amount_2.text = str(snappedi(data_team_2.spawner_data.spawn_radius, 1))
	label_entity_hitpoints_amount_2.text = str(snappedi(data_team_2.spawner_data.entity_hitpoints_max, 1))
	label_entity_attack_amount_2.text = str(snappedi(data_team_2.spawner_data.entity_attack, 1))
	label_entity_attack_range_amount_2.text = str(snappedi(data_team_2.spawner_data.entity_attack_range, 1))
	label_entity_speed_amount_2.text = str(snappedi(data_team_2.spawner_data.entity_speed, 1))
	return

func set_score_count(value : int) -> void:
	label_score_count.text = str(value)
	return

func _set_bomb_progress(value : float) -> void:
	progress_bar_bomb.value = value
	button_bomb.disabled = progress_bar_bomb.value < progress_bar_bomb.max_value
	return

func _set_scrambler_progress(value : float) -> void:
	progress_bar_scrambler.value = value
	button_scrambler.disabled = progress_bar_scrambler.value < progress_bar_scrambler.max_value
	return

func _set_bless_progress(value : float) -> void:
	progress_bar_bless.value = value
	button_bless.disabled = progress_bar_bless.value < progress_bar_bless.max_value
	return

func _set_evolution_progress_0(value : float) -> void:
	progress_bar_evolution_0.value = value
	return

func _set_evolution_progress_1(value : float) -> void:
	progress_bar_evolution_1.value = value
	return

func _set_evolution_progress_2(value : float) -> void:
	progress_bar_evolution_2.value = value
	return

func _on_button_team_0_pressed() -> void:
	vbox_stats_team_0.visible = not vbox_stats_team_0.visible
	return

func _on_button_team_1_pressed() -> void:
	vbox_stats_team_1.visible = not vbox_stats_team_1.visible
	return

func _on_button_team_2_pressed() -> void:
	vbox_stats_team_2.visible = not vbox_stats_team_2.visible
	return

func _on_button_expand_pressed() -> void:
	if(stats_expanded):
		stats_expanded = false
		button_expand.text = "^"
		vbox_stats_team_0.visible = false
		vbox_stats_team_1.visible = false
		vbox_stats_team_2.visible = false
	else:
		stats_expanded = true
		button_expand.text = "v"
		vbox_stats_team_0.visible = true
		vbox_stats_team_1.visible = true
		vbox_stats_team_2.visible = true
	return

func _on_button_bomb_pressed() -> void:
	button_bomb_pressed.emit()
	return

func _on_button_scrambler_pressed() -> void:
	button_scrambler_pressed.emit()
	return

func _on_button_bless_pressed() -> void:
	button_bomb.disabled = not button_bomb.disabled
	button_scrambler.disabled = not button_scrambler.disabled
	vbox_teams.visible = not vbox_teams.visible
	return

func _on_button_bless_team_0_pressed() -> void:
	button_bless_team_0_pressed.emit()
	_on_button_bless_pressed()
	return

func _on_button_bless_team_1_pressed() -> void:
	button_bless_team_1_pressed.emit()
	_on_button_bless_pressed()
	return

func _on_button_bless_team_2_pressed() -> void:
	button_bless_team_2_pressed.emit()
	_on_button_bless_pressed()
	return
