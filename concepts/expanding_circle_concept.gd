extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%PortalLight.texture_scale = 0

func _on_player_layers_switched(active_layer: Player.Dimension) -> void:
	if active_layer == Player.Dimension.SUB:
		$PortalAnimationPlayer.play("expand_portal")
	else:
		$PortalAnimationPlayer.play("collapse_portal")
