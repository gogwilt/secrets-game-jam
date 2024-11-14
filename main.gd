extends Node2D

var level_player_scene = preload("res://concepts/level_player.tscn")

var level_player: LevelPlayer
var is_paused: bool = false
var current_level_name: String

func _ready() -> void:
	level_player = level_player_scene.instantiate()
	$LevelCompleteMenu.visible = false
	$PauseMenu.visible = false
	unpause() # In case level was paused before.

func _process(_delta: float) -> void:
	if not $LevelSelectMenu.visible and Input.is_action_just_pressed("pause"):
		if is_paused:
			unpause()
		else:
			pause()

func pause(show_pause_menu = true) -> void:
	is_paused = true
	get_tree().paused = true
	if show_pause_menu:
		$PauseMenu.visible = true
	
func unpause() -> void:
	is_paused = false
	get_tree().paused = false
	$PauseMenu.visible = false

func _on_level_select_menu_level_selected(level_name: String) -> void:
	print(level_name)
	if level_name == 'level_1':
		$LevelSelectMenu.visible = false
		Dialogic.timeline_ended.connect(_go_to_level_1)
		Dialogic.start("level_1_intro")
		get_viewport().set_input_as_handled()
	else:
		load_and_reset_level(level_name)
	
func _go_to_level_1() -> void:
	Dialogic.timeline_ended.disconnect(_go_to_level_1)
	load_and_reset_level('level_1')
	
func load_and_reset_level(level_name: String) -> void:
	add_child(level_player)
	level_player.load_level(level_name)
	current_level_name = level_name
	level_player.connect("level_completed", _on_level_completed)

	# Bug fix: await then unpause, because _on_level_completed will likely fire.
	# Without this, if you complete the level and then play it again, it will
	# be paused and the level complete menu will be showing.
	await get_tree().process_frame
	unpause()
	$LevelCompleteMenu.visible = false

	$LevelSelectMenu.visible = false
	
func go_to_main_menu() -> void:
	unpause()
	remove_child(level_player)
	$LevelCompleteMenu.visible = false
	$PauseMenu.visible = false
	$LevelSelectMenu.visible = true

func _on_level_completed() -> void:
	pause(false)
	$LevelCompleteMenu.visible = true

func _on_continue_button_pressed() -> void:
	if current_level_name == 'level_1':
		unpause()
		$LevelCompleteMenu.visible = false
		Dialogic.timeline_ended.connect(_disconnect_dialogic_and_go_to_main_menu)
		Dialogic.start("level_1_outro")
		get_viewport().set_input_as_handled()
	else:
		go_to_main_menu()

func _disconnect_dialogic_and_go_to_main_menu() -> void:
	Dialogic.timeline_ended.disconnect(_disconnect_dialogic_and_go_to_main_menu)
	go_to_main_menu()

func _on_restart_level_button_pressed() -> void:
	level_player.load_level(current_level_name)
	unpause()


func _on_back_to_level_select_button_pressed() -> void:
	go_to_main_menu()
