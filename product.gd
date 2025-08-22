extends Area2D

@export var speed := 200 # @export allows variable to be edited in node configuration panel, := set variable to the assigned datatype
	
func _ready():
	print('Product was added to the scene') # Debugging line
	
	# Set start position on screen 
	position = Vector2(-200, 180)
	
func _process(delta: float): # function runs every frame
	# Set moving speed, delta is used to adjust speed to realtime and not depend on the framerate.
	position += Vector2(1.0, -0.5) * speed * delta
