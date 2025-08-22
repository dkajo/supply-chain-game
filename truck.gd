extends Area2D

signal product_entered # Create a signal

# Detects if an area2d node enters the trucks collision area
func _on_area_entered(area: Area2D) -> void: 
	if area.is_in_group("product"):
		emit_signal("product_entered")
		area.queue_free() # Removes product
