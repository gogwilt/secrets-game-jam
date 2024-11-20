class_name LevelPlayer extends Node2D

signal level_completed(level_name: String)

var current_level_name: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%PortalLight.texture_scale = 0
	
func load_level(level_name: String) -> void:
	current_level_name = level_name
	var level_scene = load("res://concepts/levels/" + level_name + ".tscn")
	for c in %LevelContainer.get_children():
		%LevelContainer.remove_child(c)
	var level: BaseLevel = level_scene.instantiate()
	%LevelContainer.add_child(level)
	level.connect("level_completed", _on_level_completed)
	%PortalLight.texture_scale = 0
	
func _on_level_completed() -> void:
	level_completed.emit(current_level_name)

func _on_player_layers_switched(active_layer: Player.Dimension) -> void:
	if active_layer == Player.Dimension.SUB:
		$PortalAnimationPlayer.play("expand_portal")
	else:
		$PortalAnimationPlayer.play("collapse_portal")
