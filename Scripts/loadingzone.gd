extends Area2D

@onready var truck = get_parent().get_node("Truck")
@onready var level = get_parent()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("product"):
		if truck.can_accept_product():
			truck.load_product(area)
		else:
			level.scrap(area)
		area.queue_free()
