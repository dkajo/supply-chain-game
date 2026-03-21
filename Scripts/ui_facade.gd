extends CanvasLayer

# --- Signals ---
signal start_button_pressed
signal stop_button_pressed
signal maintenance_button_pressed
signal speed_upgrade_button_pressed

# --- Game Over Functions -- 
func show_game_over():
	$GameOver.visible = true
	print("Game Over") # Debugging

func hide_game_over():
	$GameOver.visible = false
	print("Not Game Over") # Debugging

# --- Label Updates ---
func update_balance_label(balance):
	$HUD/BalanceLabel.text = "Balance: %d" % balance

func update_truck_load_label(load, capacity):
	$HUD/TruckLoadLabel.text = "Load: %d/%d" % [load, capacity]

func update_score_label(score):
	var label = $HUD/Score
	var s = str(score)
	if score >= 0:
		s = '+' + s
		label.add_theme_color_override("font_color", Color.WEB_GREEN)
	else:
		label.add_theme_color_override("font_color", Color.RED)
	label.visible = true
	label.text = s
	await get_tree().create_timer(0.8).timeout
	label.visible = false

# --- Button functions ---
func _on_start_button_pressed() -> void:
	emit_signal("start_button_pressed")

func _on_stop_button_pressed() -> void:
	emit_signal("stop_button_pressed")

func _on_maintenance_btn_pressed() -> void:
	emit_signal("maintenance_button_pressed")

func _on_speed_upgrade_btn_pressed() -> void:
	emit_signal("speed_upgrade_button_pressed")
