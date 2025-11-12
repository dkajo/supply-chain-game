extends Node2D

var product_scene: PackedScene = load("res://product.tscn") # Enable products to be instantiated within this scene
var balance: int = 0 # Score tracker
var produced_count := 0 # Counts the number of prroducts produced.
@export var production_limit := 10 # Limit how many to produce before stopping.
 
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	# Connect to the product_loaded signal in truck.gd and call method in this script
	$Truck.product_entered.connect(_on_truck_loaded_product)

# Production timer controls production and is thereby the primary game engine
func _on_production_timer_timeout(): # Holds everything that needs to happen as a product is produced
	# Check production limit before producing the next product
	if produced_count >= production_limit:
		$ProductionTimer.stop()
		return
	 
	var product = product_scene.instantiate() # Create an instance of a product
	product.is_defect = $Machine.roll_is_defect(rng) # Defect or not decided by machine
	
	add_child(product) # Attach node to scene tree, adds product to level.
	produced_count += 1 # Increment after produced product.
	

# --- Money Helpers ---
func can_afford(price: int) -> bool:
	return balance >= price

func spend(price: int) -> void:
	balance -= price
	$UI/Control/BalanceLabel.text = "Balance: %d" % balance

# --- Button Signals ---
func _on_start_button_pressed() -> void:
	produced_count = 0 # Reset the produced count
	balance = 0 # Reset the balance
	$UI/Control/BalanceLabel.text = "Balance: %d" % balance
	$ProductionTimer.start()

func _on_stop_button_pressed() -> void:
	$ProductionTimer.stop()

func _on_maintenance_btn_pressed() -> void:
	if can_afford($Machine.get_maintenance_cost()):
		spend($Machine.get_maintenance_cost())
		$Machine.apply_maintenance()
	else:
		print("Not enough balance")

# Fired when a product enters the truck, and simulates a product being sold
func _on_truck_loaded_product(product): # Receive the product from the signal
	balance += product.value
	$UI/Control/BalanceLabel.text = "Balance: %d" % balance
	
