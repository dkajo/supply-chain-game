extends Area2D

const CAPACITY_UPGRADE_BASE_COST := 20
const CAPACITY_UPGRADE_COST_GROWTH := 1.30

var _capacity: int = 4
var capacity_upgrade := 1
var capacity_upgrade_level: int = 0
var _load: int = 0
var is_full: bool = false
@export var speed := 200
@export var travel_time := 8.0

enum State { AVAILABLE, AWAY }
var state: State = State.AVAILABLE

signal product_entered # Create a signal
signal capacity_upgrade_applied()
signal truck_returned

@onready var travel_timer: Timer = $TravelTimer
var start_position = Vector2(1500, 800)

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

func get_capacity_upgrade_cost() -> int:
	return round(CAPACITY_UPGRADE_BASE_COST * pow(CAPACITY_UPGRADE_COST_GROWTH, capacity_upgrade_level))

# Detects if an area2d node enters the trucks collision area
func load_product(product) -> void: 
	load += 1
	emit_signal("product_entered", product) # Added area to emit the area to the signal function so properties can be used

func _ready():
	position = start_position
	if not travel_timer.timeout.is_connected(_on_travel_timer_timeout):
		travel_timer.timeout.connect(_on_travel_timer_timeout)

func _process(delta: float): # Only want the truck to move when capacity is full
	if state == State.AWAY:
		position += Vector2(1.0, 0) * speed * delta

func _on_travel_timer_timeout() -> void:
	reset_truck()
	emit_signal ("truck_returned")

func can_accept_product() -> bool: # Returns true if the truck can accept products
	return state == State.AVAILABLE and load < capacity

func reset_truck(): # Resets truck to it's starting position
	position = start_position
	load = 0
	is_full = false
	state = State.AVAILABLE

func reset_truck_upgrades() -> void:
	_capacity = 4
	capacity_upgrade_level = 0

func apply_capacity_upgrade() -> void:
	capacity += capacity_upgrade
	capacity_upgrade_level += 1
	print("Capacity increased to: ", capacity)
	emit_signal("capacity_upgrade_applied")

func get_stats() -> Dictionary:
	return {
		"Load capacity": capacity,
	}
