extends Node2D

const STARTING_PRODUCTION_SPEED := 3
const STARTING_DEFECT_CHANCE := 0.9
var produced_count := 0 # Counts the number of products produced.

# Chance of a product being defect.
@export_range (0.0, 1.0, 0.01) var defect_chance := 0.9

# --- Maintenance ---
@export var quality_upgrade_cost := 10
@export var quality_upgrade_multiplier := 0.5 # Improves defect chance by 50%

# --- Production speed ---
@export var speed_upgrade_cost := 10
@export var speed_upgrade_muliplier := 0.5 # Speed gets upgraded by 50% with each click of a button
@export var production_speed := 3 # Seconds to produce each product

# --- Getters & Setters ---
func get_quality_upgrade_cost() -> int:
	return quality_upgrade_cost

func get_speed_upgrade_cost() -> int:
	return speed_upgrade_cost

# --- Signals ---
signal quality_upgrade_applied()
signal speed_upgrade_applied()
signal produce_product()

# --- Functions ---
func roll_is_defect (rng: RandomNumberGenerator) -> bool:
	return rng.randf() < defect_chance

func apply_quality_upgrade() -> void:
	defect_chance *= quality_upgrade_multiplier
	print("Defect chance: ", defect_chance)
	emit_signal("quality_upgrade_applied")

func apply_speed_upgrade() -> void:
	production_speed *= speed_upgrade_muliplier
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
	produced_count = 0
