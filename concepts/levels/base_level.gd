class_name BaseLevel extends Node2D

signal level_completed

@export var player_start_position: Marker2D
@export var level_end_area: Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player: Player = get_tree().get_first_node_in_group("player")
	if player and player_start_position:
		player.position = player_start_position.position
		player.velocity = Vector2.ZERO
	if level_end_area:
		# Player is on layer 3, so it doesn't interfere with dimension switch collision detection
		level_end_area.set_collision_mask_value(3, true)
		level_end_area.connect("body_entered", _on_level_end_area_body_entered, ConnectFlags.CONNECT_ONE_SHOT)

func _on_level_end_area_body_entered(body: Node2D) -> void:
	if body is Player:
		level_completed.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
