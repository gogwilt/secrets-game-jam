extends CanvasLayer

signal level_selected(level_name: String)
@export var save_state: CluedomancerSaveState

const NUM_LEVELS := 4

func _ready() -> void:
	save_state.save_data_updated.connect(_update_level_data)
	_update_level_data()
	
func _update_level_data() -> void:
	var next_level_idx: int
	var next_level_button: Button
	for i in range(1, NUM_LEVELS + 1):
		var level_data = save_state.get_level_data("level_" + str(i))
		var level = find_child("Level" + str(i), false)
		if level_data.complete:
			level.find_child("CardBack", false).visible = false
			level.disabled = false
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
			
	if next_level_button:
		next_level_button.grab_focus()
	else:
		$Level1.grab_focus()
	


func _on_level_1_pressed() -> void:
	level_selected.emit("level_1")


func _on_level_2_pressed() -> void:
	level_selected.emit("level_2")


func _on_level_3_pressed() -> void:
	#level_selected.emit("level_3")
	pass


func _on_level_4_pressed() -> void:
	#level_selected.emit("level_4")
	pass
