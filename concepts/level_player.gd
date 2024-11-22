class_name LevelPlayer extends Node2D

signal level_completed(level_name: String, time_elapsed: float)

var current_level_name: String
var time_elapsed: float
var run_started: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%PortalLight.texture_scale = 0
	load_level("level_2") # Just for testing
	
func load_level(level_name: String) -> void:
	current_level_name = level_name
	var level_scene = load("res://concepts/levels/" + level_name + ".tscn")
	for c in %LevelContainer.get_children():
		%LevelContainer.remove_child(c)
	var level: BaseLevel = level_scene.instantiate()
	%LevelContainer.add_child(level)
	level.connect("level_completed", _on_level_completed)
	%PortalLight.texture_scale = 0
	time_elapsed = 0
	run_started = true
	
func _on_level_completed() -> void:
	run_started = false
	level_completed.emit(current_level_name, time_elapsed)

func _on_player_layers_switched(active_layer: Player.Dimension) -> void:
	if active_layer == Player.Dimension.SUB:
		$PortalAnimationPlayer.play("expand_portal")
	else:
		$PortalAnimationPlayer.play("collapse_portal")

func _process(delta: float) -> void:
	if run_started:
		time_elapsed += delta
		var minutes = floor(time_elapsed / 60)
		var minutes_str = str(minutes)
		if minutes < 10:
			minutes_str = "0" + str(minutes)
		var seconds = time_elapsed - minutes * 60
		var seconds_str = str(time_elapsed).pad_decimals(2)
		if seconds < 10:
			seconds_str = "0" + seconds_str
		%TimeDisplay.text = minutes_str + ":" + seconds_str
