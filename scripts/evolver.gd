extends Node
class_name Evolver

signal evolved(stat_type : StatType)
signal evolve_progress_updated(value : float)

const SPAWN_TIMEOUT_MIN : float = 1.0
const SPAWN_RADIUS_MAX : float = 360.0
const ENTITY_ATTACK_RANGE_MAX : float = 128.0

enum StatType {
	CASTLE_CORRUPTION_MAX,
	CASTLE_SPAWNER_GROWTH_SPEED,
	SPAWNER_CORRUPTION_MAX,
	SPAWN_TIMEOUT,
	SPAWN_RADIUS,
	ENTITY_HITPOINTS_MAX,
	ENTITY_ATTACK,
	ENTITY_ATTACK_RANGE,
	ENTITY_SPEED
}

const stat_types : Array[StatType] = [
	StatType.CASTLE_CORRUPTION_MAX,
	StatType.CASTLE_SPAWNER_GROWTH_SPEED,
	StatType.SPAWNER_CORRUPTION_MAX,
	StatType.SPAWN_TIMEOUT,
	StatType.SPAWN_RADIUS,
	StatType.ENTITY_HITPOINTS_MAX,
	StatType.ENTITY_ATTACK,
	StatType.ENTITY_ATTACK_RANGE,
	StatType.ENTITY_SPEED
]

const EVOLVE_SPEED : float = 10.0 # how much evolve progress per second is made
const EVOLVE_MODIFIER : float = 0.3 # how much a stat is modified per evolution
const RANDOM_COMPONENT : float = 0.05 # each stat varies by this much when randomize_stats is called

var castle_stats : CastleData = null
var spawner_stats : SpawnerData = null

var evolve_progress : float = 0.0 : set = _set_evolve_progress
var evolve_progress_max : float = 100.0 : set = _set_evolve_progress_max

func _ready() -> void:
	return

# adds to evolve progress and evolves if evolve progress exceeds its maximum
func increase_evolve_progress(delta : float) -> void:
	evolve_progress += EVOLVE_SPEED * delta
	if(evolve_progress >= evolve_progress_max):
		evolve_stat()
		evolve_progress = 0.0
	evolve_progress_updated.emit(evolve_progress)
	return

# makes a random stat better
func evolve_stat() -> void:
	var stat_type : StatType = stat_types.pick_random()
	match(stat_type):
		StatType.CASTLE_CORRUPTION_MAX:
			castle_stats.corruption_max *= (1.0 + EVOLVE_MODIFIER)
		StatType.SPAWNER_CORRUPTION_MAX:
			spawner_stats.corruption_max *= (1.0 + EVOLVE_MODIFIER)
		StatType.SPAWN_TIMEOUT:
			# spawn timeout gets better when it goes down
			spawner_stats.spawn_timeout *= (1.0 - EVOLVE_MODIFIER)
			spawner_stats.spawn_timeout = max(spawner_stats.spawn_timeout, SPAWN_TIMEOUT_MIN)
		StatType.SPAWN_RADIUS:
			spawner_stats.spawn_radius *= (1.0 + EVOLVE_MODIFIER)
			spawner_stats.spawn_radius = min(spawner_stats.spawn_radius, SPAWN_RADIUS_MAX)
		StatType.ENTITY_HITPOINTS_MAX:
			spawner_stats.entity_hitpoints_max *= (1.0 + EVOLVE_MODIFIER)
		StatType.ENTITY_ATTACK:
			spawner_stats.entity_attack *= (1.0 + EVOLVE_MODIFIER)
		StatType.ENTITY_ATTACK_RANGE:
			spawner_stats.entity_attack_range *= (1.0 + EVOLVE_MODIFIER)
			spawner_stats.entity_attack_range = min(spawner_stats.entity_attack_range, ENTITY_ATTACK_RANGE_MAX)
		StatType.ENTITY_SPEED:
			spawner_stats.entity_speed *= (1.0 + EVOLVE_MODIFIER)
	evolved.emit(stat_type)
	return

# adds a random component to a stat
func randomize_stat(stat : StatType) -> void:
	match(stat):
		StatType.CASTLE_CORRUPTION_MAX:
			castle_stats.corruption_max *= (1.0 + randf_range(-RANDOM_COMPONENT, RANDOM_COMPONENT))
		StatType.SPAWNER_CORRUPTION_MAX:
			spawner_stats.corruption_max *= (1.0 + randf_range(-RANDOM_COMPONENT, RANDOM_COMPONENT))
		StatType.SPAWN_TIMEOUT:
			spawner_stats.spawn_timeout *= (1.0 + randf_range(-RANDOM_COMPONENT, RANDOM_COMPONENT))
		StatType.SPAWN_RADIUS:
			spawner_stats.spawn_radius *= (1.0 + randf_range(-RANDOM_COMPONENT, RANDOM_COMPONENT))
		StatType.ENTITY_HITPOINTS_MAX:
			spawner_stats.entity_hitpoints_max *= (1.0 + randf_range(-RANDOM_COMPONENT, RANDOM_COMPONENT))
		StatType.ENTITY_ATTACK:
			spawner_stats.entity_attack *= (1.0 + randf_range(-RANDOM_COMPONENT, RANDOM_COMPONENT))
		StatType.ENTITY_ATTACK_RANGE:
			spawner_stats.entity_attack_range *= (1.0 + randf_range(-RANDOM_COMPONENT, RANDOM_COMPONENT))
		StatType.ENTITY_SPEED:
			spawner_stats.entity_speed *= (1.0 + randf_range(-RANDOM_COMPONENT, RANDOM_COMPONENT))
	return

# adds a random component to all stats
func randomize_stats() -> void:
	evolve_progress += randf_range(0, evolve_progress_max)
	for stat : StatType in stat_types:
		randomize_stat(stat)
	return

func _set_evolve_progress(value : float) -> void:
	evolve_progress = value
	return

func _set_evolve_progress_max(value : float) -> void:
	evolve_progress_max = value
	evolve_progress = 0.0
	return
