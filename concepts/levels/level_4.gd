extends BaseLevel


func _ready() -> void:
	super()
	$LevelCollapsePlayer.play("RESET")
	
func reset_level(reset_location: Marker2D) -> void:
	super(reset_location)
	$LevelCollapsePlayer.play("RESET")
	%AngryVoiceDialogue.visible = false

func _on_level_collapser_body_entered(body: Node2D) -> void:
	if not body is Player:
		return

	player.velocity = Vector2.ZERO
	player.can_move = false
	%AngryVoiceDialogue.visible = true
	%AngryVoiceDialogue/Timer.start()
	%AngryVoiceDialogue/DisablePlayerControlsTimer.start()
	$LevelCollapsePlayer.play("collapse_1")
	shake_camera(1.5)


func _on_timer_timeout() -> void:
	%AngryVoiceDialogue.visible = false


func _on_disable_player_controls_timer_timeout() -> void:
	player.can_move = true


func _on_level_collapser_2_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
		
	$LevelCollapsePlayer.play("collapse_2")
	shake_camera(0.5)
