extends Node2D

# 20% chance of a product being defect.
@export_range (0.0, 1.0, 0.01) var defect_chance := 0.6

# --- Maintenance ---
@export var maintenance_cost := 50
@export var maintenance_improvement := 0.5 # Improves defect chance by 50%

# --- Getters & Setters ---
func get_maintenance_cost() -> int:
	return maintenance_cost

# --- Signals ---
signal maintenance_applied()

# --- Functions ---
func roll_is_defect (rng: RandomNumberGenerator) -> bool:
	return rng.randf() < defect_chance

func apply_maintenance() -> void:
	defect_chance *= maintenance_improvement
	print("Defect chance: ", defect_chance)
	emit_signal("maintenance_applied")
