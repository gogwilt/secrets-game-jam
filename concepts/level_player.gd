class_name LevelPlayer extends Node2D

signal level_completed(level_name: String, time_elapsed: float, collected_cards: Array)

var current_level_name: String
var time_elapsed: float
var run_started: bool
var level: BaseLevel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%PortalLight.texture_scale = 0
	load_level("level_2") # Just for testing
	
func load_level(level_name: String, level_info: Dictionary = {}) -> void:
	current_level_name = level_name
	var level_scene = load("res://concepts/levels/" + level_name + ".tscn")
	for c in %LevelContainer.get_children():
		%LevelContainer.remove_child(c)
	level = level_scene.instantiate()
	if level_info.has("collected_cards"):
		level.collected_cards = level_info.collected_cards
	%LevelContainer.add_child(level)
	level.connect("level_completed", _on_level_completed)
	%PortalLight.texture_scale = 0
	time_elapsed = 0
	run_started = true
	
func _on_level_completed() -> void:
	run_started = false
	level_completed.emit(current_level_name, time_elapsed, level.collected_cards)
	
var portal_tween: Tween

func _on_player_dimension_switch_status_updated(new_status: Player.DimensionSwitchStatus) -> void:
	if new_status == Player.DimensionSwitchStatus.SECRET_DIMENSION:
		if portal_tween:
			portal_tween.stop()
			portal_tween = null
		$PortalAnimationPlayer.play("expand_portal")
		return
		
	$PortalAnimationPlayer.stop(true)
	if portal_tween:
		portal_tween.stop()
	portal_tween = get_tree().create_tween()

	if new_status == Player.DimensionSwitchStatus.MAIN_DIMENSION:
		portal_tween.tween_property(%PortalLight, "texture_scale", 0, 0.2).set_ease(Tween.EASE_IN)
	elif new_status == Player.DimensionSwitchStatus.UNABLE_TO_SWITCH_TO_MAIN:
		portal_tween.tween_property(%PortalLight, "texture_scale", 0.2, 0.2).set_ease(Tween.EASE_IN)
	elif new_status == Player.DimensionSwitchStatus.UNABLE_TO_SWITCH_TO_SECRET:
		portal_tween.tween_property(%PortalLight, "texture_scale", 0.1, 0.2).set_ease(Tween.EASE_IN)

func _process(delta: float) -> void:
	if run_started:
		time_elapsed += delta
		var minutes = floor(time_elapsed / 60)
		var minutes_str = str(minutes)
		if minutes < 10:
			minutes_str = "0" + str(minutes)
		var seconds = time_elapsed - minutes * 60
		var seconds_str = str(seconds).pad_decimals(2)
		if seconds < 10:
			seconds_str = "0" + seconds_str
		%TimeDisplay.text = minutes_str + ":" + seconds_str
