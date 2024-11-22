extends Node2D

var level_player_scene = preload("res://concepts/level_player.tscn")

var level_player: LevelPlayer
var is_paused: bool = false
var current_level_name: String
var player: Player

func _ready() -> void:
	%CluedomancerSaveState.load_game()
	$LevelCompleteMenu.visible = false
	$PauseMenu.visible = false

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
	if level_name == 'level_1':
		$LevelSelectMenu.visible = false
		Dialogic.timeline_ended.connect(_go_to_level_1)
		Dialogic.start("level_1_intro")
		get_viewport().set_input_as_handled()
	elif level_name == 'level_2':
		$LevelSelectMenu.visible = false
		Dialogic.timeline_ended.connect(_go_to_level_2)
		Dialogic.start("level_2_intro")
		get_viewport().set_input_as_handled()
	else:
		load_and_reset_level(level_name)
	
func _go_to_level_1() -> void:
	Dialogic.timeline_ended.disconnect(_go_to_level_1)
	load_and_reset_level('level_1')

func _go_to_level_2() -> void:
	Dialogic.timeline_ended.disconnect(_go_to_level_2)
	load_and_reset_level('level_2')
	
func load_and_reset_level(level_name: String) -> void:
	if level_player:
		level_player.queue_free()
		remove_child(level_player)
	level_player = level_player_scene.instantiate()
	add_child(level_player)
	player = get_tree().get_first_node_in_group("player")
	player.can_move = true
	level_player.load_level(level_name)
	current_level_name = level_name
	unpause()
	$LevelCompleteMenu.visible = false
	$LevelSelectMenu.visible = false

	# Connect once at the end, so that _on_level_completed doesn't accidentally fire	
	level_player.connect("level_completed", _on_level_completed, ConnectFlags.CONNECT_ONE_SHOT)

	
func go_to_main_menu() -> void:
	unpause()
	remove_child(level_player)
	$LevelCompleteMenu.visible = false
	$PauseMenu.visible = false
	$LevelSelectMenu.visible = true

func _on_level_completed(_level_name, time_elapsed) -> void:
	player.can_move = false
	pause(false)
	%CluedomancerSaveState.on_level_complete(current_level_name, time_elapsed)
	%CluedomancerSaveState.save_game()
	var level_info = %CluedomancerSaveState.get_level_data(current_level_name)
	%CompletionTimes.text = _get_time_chart(time_elapsed, level_info.completion_times)
	$LevelCompleteMenu.visible = true
	
func _get_time_chart(time_elapsed: float, completion_times: Array) -> String:
	var completion_time_text = ""
	var current_time_shown = false
	for i in range(min(10, completion_times.size())):
		var t = completion_times[i]
		var time_text = str(i + 1) + ". " + _format_time_elapsed(t)
		if time_elapsed == t and not current_time_shown:
			completion_time_text += "> " + time_text + " <\n"
			current_time_shown = true
		else:
			completion_time_text += time_text + "\n"
	return completion_time_text
	
func _format_time_elapsed(time_elapsed: float) -> String:
	var minutes = floor(time_elapsed / 60)
	var minutes_str = str(minutes)
	if minutes < 10:
		minutes_str = "0" + str(minutes)
	var seconds = time_elapsed - minutes * 60
	var seconds_str = str(time_elapsed).pad_decimals(2)
	if seconds < 10:
		seconds_str = "0" + seconds_str
	return minutes_str + ":" + seconds_str


func _on_continue_button_pressed() -> void:
	if current_level_name == 'level_1':
		unpause()
		$LevelCompleteMenu.visible = false
		Dialogic.timeline_ended.connect(_disconnect_dialogic_and_go_to_main_menu)
		Dialogic.start("level_1_outro")
		get_viewport().set_input_as_handled()
	elif current_level_name == 'level_2':
		unpause()
		$LevelCompleteMenu.visible = false
		Dialogic.timeline_ended.connect(_disconnect_dialogic_and_go_to_main_menu)
		Dialogic.start("level_2_outro")
		get_viewport().set_input_as_handled()
	else:
		go_to_main_menu()

func _disconnect_dialogic_and_go_to_main_menu() -> void:
	Dialogic.timeline_ended.disconnect(_disconnect_dialogic_and_go_to_main_menu)
	go_to_main_menu()

func _on_restart_level_button_pressed() -> void:
	load_and_reset_level(current_level_name)
	unpause()

func _on_retry_button_pressed() -> void:
	load_and_reset_level(current_level_name)

func _on_back_to_level_select_button_pressed() -> void:
	go_to_main_menu()
