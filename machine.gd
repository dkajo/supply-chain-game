extends Node2D

var produced_count := 0 # Counts the number of products produced.

# Chance of a product being defect.
@export_range (0.0, 1.0, 0.01) var defect_chance := 0.6

# --- Maintenance ---
@export var maintenance_cost := 50
@export var maintenance_improvement := 0.5 # Improves defect chance by 50%

# --- Production speed ---
@export var production_speed := 3 # Seconds to produce each product

# --- Getters & Setters ---
func get_maintenance_cost() -> int:
	return maintenance_cost

# --- Signals ---
signal maintenance_applied()
signal produce_product()

# --- Functions ---
func roll_is_defect (rng: RandomNumberGenerator) -> bool:
	return rng.randf() < defect_chance

func apply_maintenance() -> void:
	defect_chance *= maintenance_improvement
	print("Defect chance: ", defect_chance)
	emit_signal("maintenance_applied")

# --- Production ---
# Production timer controls production and is thereby the primary game engine
func _on_production_timer_timeout(): # Holds everything that needs to happen as a product is produced
	emit_signal("produce_product")
	produced_count += 1 # Increment after produced product.
	print("Prduct produced")

func start_production():
	$ProductionTimer.wait_time = production_speed
	$ProductionTimer.start()

func stop_production():
	$ProductionTimer.stop()
