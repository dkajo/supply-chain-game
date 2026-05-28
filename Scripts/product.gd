extends Area2D

# @export allows variable to be edited in node configuration panel, := set variable to the assigned datatype
@export var speed := 200
@export var base_value := 10 # Added value attribute to dynamically change the value depending on other product properties
@export var defect_value := 4 # Sale value if the product is defect 
@export var scrap_value := 2 # Value to use upon scrapping product
@export var production_cost := 6
@export var is_defect := false : set = _set_defect # Defines a setter function to the property.

var value: int : get = _get_value # Defines a getter function for the variable

func _get_value() -> int:
	return defect_value if is_defect else base_value

func _get_production_cost() -> int:
	return production_cost

func _set_defect(value: bool) -> void:
	is_defect = value
	# Displays overlay sprite if the product is defect
	$DefectMarker.visible = is_defect 
	
func _ready():
	# Set start position on screen 
	position = Vector2(0, 380)

func _process(delta: float): # function runs every frame
	# Set moving speed, delta is used to adjust speed to realtime and not depend on the framerate.
	position += Vector2(1.0, 0) * speed * delta
