extends Area2D

var capacity: int = 4 : set = _set_capacity, get = _get_capacity
var load: int : set = _set_load, get = _get_load
var is_full: bool

signal product_entered # Create a signal

# Getters & Setters
func _set_capacity(value: int) -> void:
	capacity += value

func _get_capacity() -> int:
	return capacity

func _set_load(value: int) -> void:
	load = value
	if load == capacity:
		is_full = true
		print ("Truck is full!") # Debugging

func _get_load() -> int:
	return load

# Detects if an area2d node enters the trucks collision area
func _on_area_entered(area: Area2D) -> void: 
	if area.is_in_group("product"):
		emit_signal("product_entered", area) # Added area to emit the area to the signal function so properties can be used
		area.queue_free() # Removes product
		load += 1
