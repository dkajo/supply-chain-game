extends Node2D

const STARTING_PRODUCTION_SPEED := 3
const STARTING_DEFECT_CHANCE := 0.9
const QUALITY_UPGRADE_BASE_COST := 10
const QUALITY_UPGRADE_COST_GROWTH := 1.20
const QUALITY_REDUCTION := 0.1
const SPEED_UPGRADE_BASE_COST := 10
const SPEED_UPGRADE_COST_GROWTH := 1.20
const SPEED_REDUCTION := 0.25
var produced_count := 0 # Counts the number of products produced.

# Chance of a product being defect.
@export_range (0.0, 1.0, 0.01) var defect_chance := 0.9

# --- Maintenance ---
var quality_upgrade_level: int = 0
@export var quality_upgrade_cost := QUALITY_UPGRADE_BASE_COST
# @export var quality_upgrade_multiplier := 0.5 -- TO be removed

# --- Production speed ---
var speed_upgrade_level: int = 0
@export var speed_upgrade_cost := 10
@export var speed_upgrade_muliplier := 0.5 # Speed gets upgraded by 50% with each click of a button
@export var production_speed := 3 # Seconds to produce each product

# --- Getters & Setters ---
func get_quality_upgrade_cost() -> int:
	return round(QUALITY_UPGRADE_BASE_COST * pow(QUALITY_UPGRADE_COST_GROWTH, quality_upgrade_level))

func get_speed_upgrade_cost() -> int:
	return round(SPEED_UPGRADE_BASE_COST * pow(SPEED_UPGRADE_COST_GROWTH, speed_upgrade_level))

# --- Signals ---
signal quality_upgrade_applied()
signal speed_upgrade_applied()
signal produce_product()

# --- Functions ---
func roll_is_defect (rng: RandomNumberGenerator) -> bool:
	return rng.randf() < defect_chance

func apply_quality_upgrade() -> void:
	defect_chance = max(0.0, defect_chance - QUALITY_REDUCTION)
	quality_upgrade_level += 1
	print("Defect chance: ", defect_chance)
	emit_signal("quality_upgrade_applied")

func apply_speed_upgrade() -> void:
	production_speed = max(0.2, production_speed - SPEED_REDUCTION)
	speed_upgrade_level += 1
	print("Production speed: ", production_speed)
	emit_signal("speed_upgrade_applied")

# --- Production ---
# Production timer controls production and is thereby the primary game engine
func _on_production_timer_timeout(): # Holds everything that needs to happen as a product is produced
	emit_signal("produce_product")
	produced_count += 1 # Increment after produced product.
	print("Product produced")

func start_production():
	$ProductionTimer.wait_time = production_speed
	$ProductionTimer.start()

func stop_production():
	$ProductionTimer.stop()

# --- Other ---
func reset_machine():
	production_speed = STARTING_PRODUCTION_SPEED
	defect_chance = STARTING_DEFECT_CHANCE
	quality_upgrade_cost = QUALITY_UPGRADE_BASE_COST
	quality_upgrade_level = 0
	speed_upgrade_level = 0
	produced_count = 0

func get_stats() -> Dictionary:
	return {
		"# Produced": produced_count,
		"Speed": production_speed, 
		"Quality": str((1 - defect_chance) * 100) + "%" # Formats quality as a percentage
	}
