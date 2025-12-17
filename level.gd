extends Node2D

var product_scene: PackedScene = load("res://product.tscn") # Enable products to be instantiated within this scene
var balance: int = 100 # Score tracker
 
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	$UI/Control/BalanceLabel.text = "Balance: %d" % balance
	
	$Machine.produce_product.connect(_on_produce_product)
	# Connect to the product_loaded signal in truck.gd and call method in this script
	$Truck.product_entered.connect(_on_truck_loaded_product)

func _on_produce_product():
	var product = product_scene.instantiate() # Create an instance of a product
	balance -= product._get_production_cost() # Reduces balance by the production cost
	product.is_defect = $Machine.roll_is_defect(rng) # Defect or not decided by machine
	
	add_child(product) # Attach node to scene tree, adds product to level.
	$UI/Control/BalanceLabel.text = "Balance: %d" % balance

# --- Money Helpers ---
func can_afford(price: int) -> bool:
	return balance >= price

func spend(price: int) -> void:
	balance -= price
	$UI/Control/BalanceLabel.text = "Balance: %d" % balance

# --- Button Signals ---
func _on_start_button_pressed():
	$Machine.start_production()

func _on_stop_button_pressed():
	$Machine.stop_production()

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
	
