extends CanvasLayer

# --- Signals ---
signal start_button_pressed
signal stop_button_pressed
signal maintenance_button_pressed

# --- Game Over Functions -- 
func show_game_over():
	$GameOver.visible = true
	print("Game Over") # Debugging

func hide_game_over():
	$GameOver.visible = false
	print("Not Game Over") # Debugging

# --- HUD Functions --
func update_balance_label(balance):
	$HUD/BalanceLabel.text = "Balance: %d" % balance

func _on_start_button_pressed() -> void:
	emit_signal("start_button_pressed")

func _on_stop_button_pressed() -> void:
	emit_signal("stop_button_pressed")

func _on_maintenance_btn_pressed() -> void:
	emit_signal("maintenance_button_pressed")
