extends CanvasLayer

signal level_selected(level_name: String)
@export var save_state: CluedomancerSaveState

const NUM_LEVELS := 4

var next_level_button: Button

func _ready() -> void:
	save_state.save_data_updated.connect(_update_level_data)
	_update_level_data()
	_focus_next_level()
	
func _update_level_data() -> void:
	next_level_button = $Level1
	var next_level_idx: int = NUM_LEVELS
	var count_complete_levels = 0
	for i in range(1, NUM_LEVELS + 1):
		var level_data = save_state.get_level_data("level_" + str(i))
		var level = find_child("Level" + str(i), false)
		if level_data.complete:
			level.find_child("CardBack", false).visible = false
			level.disabled = false
			count_complete_levels += 1
		else:
			level.find_child("CardBack", false).visible = false
			level.disabled = false
			next_level_idx = i
			next_level_button = level
			break
	for i in range(next_level_idx + 1, NUM_LEVELS + 1):
		var level = find_child("Level" + str(i), false)
		level.find_child("CardBack", false).visible = true
		level.disabled = true

	var secret_level = $Level5
	if count_complete_levels >= 4:
		var secret_level_data = save_state.get_level_data("level_5")
		secret_level.visible = true
		secret_level.disabled = false
	else:
		secret_level.visible = false
		secret_level.disabled = true

func _focus_next_level() -> void:
	if next_level_button:
		next_level_button.grab_focus()
	else:
		$Level1.grab_focus()
	


func _on_level_1_pressed() -> void:
	level_selected.emit("level_1")


func _on_level_2_pressed() -> void:
	level_selected.emit("level_2")


func _on_level_3_pressed() -> void:
	level_selected.emit("level_3")


func _on_level_4_pressed() -> void:
	level_selected.emit("level_4")

func _on_level_5_pressed() -> void:
	level_selected.emit("level_5")


func _on_visibility_changed() -> void:
	if visible:
		_focus_next_level()
