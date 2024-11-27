extends Node2D

var level_player_scene = preload("res://concepts/level_player.tscn")

var level_player: LevelPlayer
var is_paused: bool = false
var current_level_name: String
var player: Player
var currently_playing_level: bool = false:
	set(value):
		currently_playing_level = value
		currently_playing_level_updated.emit()
var currently_in_level: bool = false:
	set(value):
		currently_in_level = value
		currently_in_level_updated.emit()
		
signal currently_playing_level_updated
signal currently_in_level_updated

func _ready() -> void:
	%CluedomancerSaveState.load_game()
	$LevelCompleteMenu.visible = false
	$PauseMenu.visible = false
	%MenuMusic.play()

func _process(_delta: float) -> void:
	if not $LevelSelectMenu.visible and currently_playing_level and Input.is_action_just_pressed("pause"):
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
	
const LEVELS_WITH_SCENES = ['level_1', 'level_2', 'level_3', 'level_4', 'level_5']

func _on_level_select_menu_level_selected(level_name: String) -> void:
	if LEVELS_WITH_SCENES.has(level_name):
		$LevelSelectMenu.visible = false
		%DialogueBackground.visible = true
		Dialogic.timeline_ended.connect(load_and_reset_level.bind(level_name), CONNECT_ONE_SHOT)
		Dialogic.start(level_name + "_intro")
		get_viewport().set_input_as_handled()
	else:
		load_and_reset_level(level_name)

func load_and_reset_level(level_name: String) -> void:
	if level_player:
		level_player.queue_free()
		remove_child(level_player)
	level_player = level_player_scene.instantiate()
	add_child(level_player)
	_disconnect_audio_to_player()
	player = get_tree().get_first_node_in_group("player")
	player.can_move = true
	_connect_audio_to_player()
	var level_info = %CluedomancerSaveState.get_level_data(current_level_name)
	level_player.load_level(level_name, level_info)
	current_level_name = level_name
	unpause()
	$LevelCompleteMenu.visible = false
	$LevelSelectMenu.visible = false
	%DialogueBackground.visible = false
	currently_playing_level = true
	currently_in_level = true

	# Connect once at the end, so that _on_level_completed doesn't accidentally fire	
	level_player.connect("level_completed", _on_level_completed, ConnectFlags.CONNECT_ONE_SHOT)

	
func go_to_main_menu() -> void:
	unpause()
	remove_child(level_player)
	$LevelCompleteMenu.visible = false
	$PauseMenu.visible = false
	$LevelSelectMenu.visible = true
	currently_playing_level = false
	currently_in_level = false

func _on_level_completed(_level_name, time_elapsed, collected_cards) -> void:
	player.can_move = false
	pause(false)
	%CluedomancerSaveState.on_level_complete(current_level_name, time_elapsed, collected_cards)
	%CluedomancerSaveState.save_game()
	var level_info = %CluedomancerSaveState.get_level_data(current_level_name)
	%CompletionTimes.text = _get_time_chart(time_elapsed, level_info.completion_times)
	$LevelCompleteMenu.visible = true
	currently_playing_level = false
	
	# Set up dialogic variables to show cards
	Dialogic.VAR.Card1 = collected_cards.has(0)
	Dialogic.VAR.Card2 = collected_cards.has(1)
	Dialogic.VAR.Card3 = collected_cards.has(2)
	
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
	var seconds_str = str(seconds).pad_decimals(2)
	if seconds < 10:
		seconds_str = "0" + seconds_str
	return minutes_str + ":" + seconds_str


func _on_continue_button_pressed() -> void:
	if LEVELS_WITH_SCENES.has(current_level_name):
		unpause()
		$LevelCompleteMenu.visible = false
		Dialogic.timeline_ended.connect(go_to_main_menu, CONNECT_ONE_SHOT)
		Dialogic.start(current_level_name + "_outro")
		get_viewport().set_input_as_handled()
	else:
		go_to_main_menu()

func _on_restart_level_button_pressed() -> void:
	load_and_reset_level(current_level_name)
	unpause()

func _on_retry_button_pressed() -> void:
	load_and_reset_level(current_level_name)

func _on_back_to_level_select_button_pressed() -> void:
	go_to_main_menu()

func _connect_audio_to_player() -> void:
	player.connect("dimension_switch_status_updated", _on_dimension_switch)
	
func _disconnect_audio_to_player() -> void:
	if not player:
		return
	player.disconnect("dimension_switch_status_updated", _on_dimension_switch)
	
func _on_dimension_switch(status: Player.DimensionSwitchStatus) -> void:
	var level_music_bus = AudioServer.get_bus_index("LevelMusic")
	if status == Player.DimensionSwitchStatus.MAIN_DIMENSION or status == Player.DimensionSwitchStatus.UNABLE_TO_SWITCH_TO_SECRET:
		AudioServer.set_bus_effect_enabled(level_music_bus, 0, false)
	else:
		AudioServer.set_bus_effect_enabled(level_music_bus, 0, true)


func _on_currently_in_level_updated() -> void:
	var level_music_bus = AudioServer.get_bus_index("LevelMusic")
	if currently_playing_level:
		# Play level music
		%LevelMusic.volume_db = 0.0
		%LevelMusic.play()
		# Fade out menu music
		var fade_menu = get_tree().create_tween()
		fade_menu.tween_property(%MenuMusic, "volume_db", -72.0, 1).set_ease(Tween.EASE_IN)
		await fade_menu.finished
		%MenuMusic.stop()
	else:
		# Play menu music
		%MenuMusic.volume_db = 0.0
		%MenuMusic.play()		
		# Fade out level music
		var fade_tween = get_tree().create_tween()
		fade_tween.tween_property(%LevelMusic, "volume_db", -72.0, 3).set_ease(Tween.EASE_IN)
		await fade_tween.finished
		%LevelMusic.stop()
