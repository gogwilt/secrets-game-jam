extends CanvasLayer

signal level_selected(level_name: String)

func _ready() -> void:
	$Level1.grab_focus()

func _on_level_1_pressed() -> void:
	level_selected.emit("level_1")


func _on_level_2_pressed() -> void:
	level_selected.emit("level_2")


func _on_level_3_pressed() -> void:
	level_selected.emit("level_3")


func _on_level_4_pressed() -> void:
	level_selected.emit("level_4")
