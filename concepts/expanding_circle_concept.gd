extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%PortalLight.texture_scale = 0
	%SubLayer.collision_enabled = false
	%MainLayer.collision_enabled = true


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("swap_layers"):
		$PortalAnimationPlayer.play("expand_portal")
		%SubLayer.collision_enabled = true
		%MainLayer.collision_enabled = false
	elif Input.is_action_just_released("swap_layers"):
		$PortalAnimationPlayer.play("collapse_portal")
		%SubLayer.collision_enabled = false
		%MainLayer.collision_enabled = true
