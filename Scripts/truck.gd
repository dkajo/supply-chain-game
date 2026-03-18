extends Area2D

var _capacity: int = 4
var _load: int = 0
var is_full: bool = false
@export var speed := 200
@export var travel_time := 8.0

enum State { AVAILABLE, AWAY }
var state: State = State.AVAILABLE

signal product_entered # Create a signal

@onready var travel_timer: Timer = $TravelTimer
var start_position = Vector2(420, 30)

# Setters/Getters
var capacity: int:
	get:
		return _capacity
	set(value):
		_capacity = value

var load: int:
	get:
		return _load
	set(value):
		_load = value
		if _load >= _capacity:
			is_full = true
			state = State.AWAY
			travel_timer.start(travel_time)
			print("Truck is full!")

# Detects if an area2d node enters the trucks collision area
func _on_area_entered(area: Area2D) -> void: 
	if area.is_in_group("product") and state == State.AVAILABLE:
		load += 1
		emit_signal("product_entered", area) # Added area to emit the area to the signal function so properties can be used
		area.queue_free() # Removes product
	else:
		print ("Truck is full and cannot accept more products")
		area.queue_free() # Removes product

func _ready():
	position = start_position
	travel_timer.timeout.connect(_on_travel_timer_timeout)

func _process(delta: float): # Only want the truck to move when capacity is full
	if state == State.AWAY:
		position += Vector2(1.0, 0) * speed * delta

func _on_travel_timer_timeout() -> void:
	position = start_position
	load = 0
	is_full = false
	state = State.AVAILABLE
	print ("Truck Returned")
