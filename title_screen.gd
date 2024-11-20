extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("boost_charged")
	if %CluedomancerSaveState.has_save_data():
		%Continue.grab_focus()
	else:
		%NewGame.grab_focus()
		%Continue.disabled = true

func _on_new_game_pressed() -> void:
	$VBoxContainer.visible = false
	$Node2D.visible = false
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	Dialogic.start("intro")
	get_viewport().set_input_as_handled()
	
func _on_timeline_ended() -> void:
	go_to_main()


func _on_continue_pressed() -> void:
	go_to_main()
	
func go_to_main() -> void:
	get_tree().change_scene_to_file("res://main.tscn")
