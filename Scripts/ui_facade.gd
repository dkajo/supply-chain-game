extends CanvasLayer

const STATS_TEXT_COLOR := Color(0.176471, 0.294118, 0.372549, 1)
const STATS_TITLE_SIZE := 44
const STATS_ROW_SIZE := 30

@onready var stats_rows: VBoxContainer = $GameOver/Statistics/Rows

# --- Signals ---
signal start_button_pressed
signal stop_button_pressed
signal quality_upgrade_button_pressed
signal speed_upgrade_button_pressed
signal capacity_upgrade_button_pressed

# --- Game Over Functions -- 
func show_game_over():
	$GameOver.visible = true
	# show_stats()
	print("Game Over") # Debugging

func hide_game_over():
	$GameOver.visible = false
	print("Not Game Over") # Debugging

# --- Label Updates ---
func update_balance_label(balance):
	$HUD/BalanceLabel.text = "Balance: %d" % balance

func update_truck_load_label(load, capacity):
	$HUD/TruckLoadLabel.text = "Load: %d/%d" % [load, capacity]

func update_defect_penalty_label(defect_penalty):
	$HUD/DefectPenalty.text = "Defect Penalty: %d" % defect_penalty

func update_score_label(score):
	var label = $HUD/Score
	var s = str(score)
	if score >= 0:
		s = '+' + s
		label.add_theme_color_override("font_color", Color("#7bc96f"))
	else:
		label.add_theme_color_override("font_color", Color("#e57373"))

	# Reset position and opacity before animating
	label.position.y = 320.0
	label.modulate.a = 1.0
	label.visible = true
	label.text = s

	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(label, "position:y", 285.0, 0.65)
	tween.tween_property(label, "modulate:a", 0.0, 0.65)
	tween.chain().tween_callback(func(): label.visible = false)

func update_quality_upgrade_button(cost: int) -> void:
	$HUD/QualityUpgradeBtn.text = "Quality Upgrade \n " + str(cost)

func update_speed_upgrade_button(cost: int) -> void:
	$HUD/SpeedUpgradeBtn.text = "Speed Upgrade \n " + str(cost)

func update_capacity_upgrade_button(cost: int) -> void:
	$HUD/CapacityUpgradeBtn.text = "Capacity Upgrade \n " + str(cost)

func show_stats(stats: Array[Dictionary]) -> void:
	for child in stats_rows.get_children():
		stats_rows.remove_child(child)
		child.queue_free()

	stats_rows.add_child(_make_stat_label("Final Stats", STATS_TITLE_SIZE, HORIZONTAL_ALIGNMENT_CENTER))

	var divider := HSeparator.new()
	var divider_style := StyleBoxLine.new()
	divider_style.color = STATS_TEXT_COLOR
	divider_style.thickness = 3
	divider.add_theme_stylebox_override("separator", divider_style)
	stats_rows.add_child(divider)

	for stat in stats:
		var row := HBoxContainer.new()
		var name_label := _make_stat_label(str(stat["label"]), STATS_ROW_SIZE)
		name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(name_label)
		row.add_child(_make_stat_label(str(stat["value"]), STATS_ROW_SIZE, HORIZONTAL_ALIGNMENT_RIGHT))
		stats_rows.add_child(row)

func _make_stat_label(text: String, font_size: int, alignment := HORIZONTAL_ALIGNMENT_LEFT) -> Label:
	var label := Label.new()
	label.text = text
	label.horizontal_alignment = alignment
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", STATS_TEXT_COLOR)
	return label

# --- Button functions ---
func _on_start_button_pressed() -> void:
	emit_signal("start_button_pressed")

func _on_stop_button_pressed() -> void:
	emit_signal("stop_button_pressed")

# --- Upgrades ---
func _on_quality_upgrade_btn_pressed() -> void:
	emit_signal("quality_upgrade_button_pressed")

func _on_speed_upgrade_btn_pressed() -> void:
	emit_signal("speed_upgrade_button_pressed")

func _on_capacity_upgrade_btn_pressed() -> void:
	emit_signal("capacity_upgrade_button_pressed")
