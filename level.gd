extends Node2D

const STARTING_BALANCE = 10

var product_scene: PackedScene = load("res://product.tscn") # Enable products to be instantiated within this scene
var balance: int # Score tracker
 
var rng = RandomNumberGenerator.new()

# Added enum to hold game state
enum GameState { IDLE, RUNNING, GAME_OVER }
var game_state: GameState = GameState.IDLE

func is_game_running() -> bool:
	return game_state == GameState.RUNNING

func start_game(): # Controls what happens when the game starts
	game_state = GameState.RUNNING
	update_balance(STARTING_BALANCE)
	print("Game started")

func game_over(): # Controls what happens upon game over
	$Machine.stop_production()
	game_state = GameState.GAME_OVER
	print("Game Over")

func _ready():
	rng.randomize()
	
	$Machine.produce_product.connect(_on_produce_product)
	# Connect to the product_loaded signal in truck.gd and call method in this script
	$Truck.product_entered.connect(_on_truck_loaded_product)

func _on_produce_product():
	var product = product_scene.instantiate() # Create an instance of a product
	product.is_defect = $Machine.roll_is_defect(rng) # Defect or not decided by machine
	
	add_child(product) # Attach node to scene tree, adds product to level.

# --- Money Helpers ---
func can_afford(price: int) -> bool:
	return balance >= price

func spend(price: int) -> void:
	balance -= price
	$UI/Control/BalanceLabel.text = "Balance: %d" % balance

# --- Button Signals ---
func _on_start_button_pressed():
	# Game starts when Start button is pressed
	if !is_game_running():
		start_game()
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
	update_balance(product.value - product.production_cost)
	# balance += product.value
	# $UI/Control/BalanceLabel.text = "Balance: %d" % balance

func update_balance(input_value):
	balance += input_value
	$UI/Control/BalanceLabel.text = "Balance: %d" % balance
	if balance < 0:
		game_over()
