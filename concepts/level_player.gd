class_name LevelPlayer extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%PortalLight.texture_scale = 0
	
func load_level(level_name: String) -> void:
	var level_scene = load("res://concepts/levels/" + level_name + ".tscn")
	for c in %LevelContainer.get_children():
		%LevelContainer.remove_child(c)
	var level = level_scene.instantiate()
	%LevelContainer.add_child(level)

func _on_player_layers_switched(active_layer: Player.Dimension) -> void:
	if active_layer == Player.Dimension.SUB:
		$PortalAnimationPlayer.play("expand_portal")
	else:
		$PortalAnimationPlayer.play("collapse_portal")
