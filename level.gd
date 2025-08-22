extends Node2D

var product_scene: PackedScene = load("res://product.tscn") # Enable products to be instantiated within this scene
var balance: int = 0 # Score tracker

func _ready():
	# Connect to the product_loaded signal in truck.gd and call method in this script
	$Truck.product_entered.connect(_on_truck_loaded_product)

# Production timer controls production and is thereby the primary game engine
func _on_production_timer_timeout(): 
	var product = product_scene.instantiate() # Create an instance of a product
	add_child(product) # Attach node to scene tree

# Button Signals
func _on_start_button_pressed() -> void:
	$ProductionTimer.start()

func _on_stop_button_pressed() -> void:
	$ProductionTimer.stop()

# Fired when a product enters the truck, and simulates a product being sold
func _on_truck_loaded_product():
	balance += 1
	$UI/Control/BalanceLabel.text = "Balance: %d" % balance
