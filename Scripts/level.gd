extends Node2D

const STARTING_BALANCE = 12

@onready var ui = $UiFacade

var product_scene: PackedScene = load("res://Scenes/product.tscn") # Enable products to be instantiated within this scene
var balance: int
var balance_highscore: int 

const DEFECT_GROWTH_INTERVAL := 10
const DEFECT_GROWTH_RATE := 1.50
const BASE_DEFECT_PENALTY := 2.0
 
var rng = RandomNumberGenerator.new()

# Added enum to hold game state
enum GameState { IDLE, RUNNING, GAME_OVER }
var game_state: GameState = GameState.IDLE

func is_game_running() -> bool:
	return game_state == GameState.RUNNING

func start_game(): # Controls what happens when the game starts
	ui.hide_game_over()
	game_state = GameState.RUNNING	
	reset_balance(STARTING_BALANCE)
	balance_highscore = STARTING_BALANCE
	$Truck.reset_truck()
	$Truck.reset_truck_upgrades()
	$Machine.reset_machine()
	update_truck_load_label($Truck.load, $Truck.capacity)
	update_balance_label(balance)
	update_defect_penalty_label(BASE_DEFECT_PENALTY)
	ui.update_quality_upgrade_button($Machine.get_quality_upgrade_cost())
	ui.update_speed_upgrade_button($Machine.get_speed_upgrade_cost())
	ui.update_capacity_upgrade_button($Truck.get_capacity_upgrade_cost())
	print("Game started")

func game_over(): # Controls what happens upon game over
	$Machine.stop_production()
	game_state = GameState.GAME_OVER
	ui.show_game_over()
	ui.show_stats(build_game_over_stats())
	# $UiFacade/GameOver.visible = true	

func _ready():
	rng.randomize()
	
	# --- Connect signals to functions ---
	ui.start_button_pressed.connect(_on_start_button_pressed)
	ui.stop_button_pressed.connect(_on_stop_button_pressed)
	ui.quality_upgrade_button_pressed.connect(_on_quality_upgrade_btn_pressed)
	ui.speed_upgrade_button_pressed.connect(_on_speed_upgrade_btn_pressed)
	ui.capacity_upgrade_button_pressed.connect(_on_capacity_upgrade_btn_pressed)
	
	$Machine.produce_product.connect(_on_produce_product)
	$Machine.quality_upgrade_applied.connect(_on_quality_upgrade_applied)
	$Machine.speed_upgrade_applied.connect(_on_speed_upgrade_applied)
	# Connect to the product_loaded signal in truck.gd and call method in this script
	$Truck.product_entered.connect(_on_truck_loaded_product)
	$Truck.capacity_upgrade_applied.connect(_on_capacity_upgrade_applied)
	$Truck.truck_returned.connect(_on_truck_returned)

func _on_produce_product():
	var product = product_scene.instantiate() # Create an instance of a product
	product.is_defect = $Machine.roll_is_defect(rng) # Defect or not decided by machine
	product.defect_value = get_current_defect_value(product.base_value)
	update_defect_penalty_label(get_current_defect_penalty())
	
	print("Current defect penalty: ", get_current_defect_penalty())
	print("Assigned defect value: ", product.defect_value)
	
	product.z_index = 2 # Render above conveyor belt (z_index 0) and machine (z_index 1)
	add_child(product) # Attach node to scene tree, adds product to level.

func build_game_over_stats() -> Array[Dictionary]:
	var stats: Array[Dictionary] = []
	
	stats.append({"label": 'Balance Highscore', "value": balance_highscore})

	for key in $Machine.get_stats().keys():
		stats.append({
			"label": key,
			"value": $Machine.get_stats()[key]
		})

	for key in $Truck.get_stats().keys():
		stats.append({
			"label": key,
			"value": $Truck.get_stats()[key]
		})

	return stats

# --- Money Helpers ---
func can_afford(price: int) -> bool:
	return balance >= price

func decrease_balance(value):
	balance -= value
	update_balance_label(balance)
	update_highscore(balance)
	if balance < 0:
		game_over()

func increase_balance(value):
	balance += value
	update_balance_label(balance)
	update_highscore(balance)
	if balance < 0:
		game_over()

func reset_balance(value):
	balance = value

func update_highscore(current_balance):
	if current_balance > balance_highscore:
		balance_highscore = current_balance

func scrap(product) -> void:
	var result = product.scrap_value - product.production_cost
	
	update_score_label(result)
	increase_balance(result) # optional scrap penalty
	
	update_truck_load_label($Truck.load, $Truck.capacity)

# --- Button Signals ---
func _on_start_button_pressed():
	# Game starts when Start button is pressed
	if !is_game_running():
		start_game()
	$Machine.start_production()

func _on_stop_button_pressed():
	$Machine.stop_production()

# --- Upgrades ---
func _on_quality_upgrade_btn_pressed() -> void:
	var cost = $Machine.get_quality_upgrade_cost()
	if can_afford(cost):
		decrease_balance(cost)
		$Machine.apply_quality_upgrade()
	else:
		print("Not enough balance")

func _on_speed_upgrade_btn_pressed() -> void:
	var cost = $Machine.get_speed_upgrade_cost()
	if can_afford(cost):
		decrease_balance(cost)
		$Machine.apply_speed_upgrade()
	else:
		print("Not enough balance")

func _on_capacity_upgrade_btn_pressed() -> void:
	var cost = $Truck.get_capacity_upgrade_cost()
	if can_afford(cost):
		decrease_balance(cost)
		$Truck.apply_capacity_upgrade()
	else:
		print("Not enough balance")

func _on_quality_upgrade_applied():
	ui.update_quality_upgrade_button($Machine.get_quality_upgrade_cost())

func _on_speed_upgrade_applied():
	ui.update_speed_upgrade_button($Machine.get_speed_upgrade_cost())

func _on_capacity_upgrade_applied():
	update_truck_load_label($Truck.load, $Truck.capacity)
	ui.update_capacity_upgrade_button($Truck.get_capacity_upgrade_cost())

func _on_truck_returned():
	update_truck_load_label($Truck.load, $Truck.capacity)

# Fired when a product enters the truck, and simulates a product being sold
func _on_truck_loaded_product(product): # Receive the product from the signal
	update_score_label(product.value - product.production_cost)
	increase_balance(product.value - product.production_cost)
	update_truck_load_label($Truck.load, $Truck.capacity)

func get_current_defect_penalty() -> int:
	var steps = floor($Machine.produced_count / DEFECT_GROWTH_INTERVAL)
	return round(BASE_DEFECT_PENALTY * pow(DEFECT_GROWTH_RATE, steps))

func get_current_defect_value(product_base_value: int) -> int:
	return product_base_value - get_current_defect_penalty()

# --- Label Updates ---
func update_score_label(score):
	ui.update_score_label(score)

func update_truck_load_label(load, capacity):
	ui.update_truck_load_label(load, capacity)

func update_balance_label(balance):
	ui.update_balance_label(balance)

func update_defect_penalty_label(defect_penalty):
	ui.update_defect_penalty_label(defect_penalty)
