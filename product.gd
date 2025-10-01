extends Area2D

# @export allows variable to be edited in node configuration panel, := set variable to the assigned datatype
@export var speed := 200
@export var base_value := 10 # Added value attribute to dynamically change the value depending on other product properties
@export var defect_value := 4 # Which value to use if the product is defect
@export var is_defect := false : set = _set_defect # Defines a setter function to the property.

var value: int : get = _get_value

func _get_value() -> int:
	return defect_value if is_defect else base_value

func _set_defect(value: bool) -> void:
	is_defect = value
	# Displays overlay sprite if the product is defect
	$DefectMarker.visible = is_defect 
	
func _ready():
	print('Product was added to the scene') # Debugging line
	
	# Set start position on screen 
	position = Vector2(-300, 30)
	
func _process(delta: float): # function runs every frame
	# Set moving speed, delta is used to adjust speed to realtime and not depend on the framerate.
	position += Vector2(1.0, 0) * speed * delta
