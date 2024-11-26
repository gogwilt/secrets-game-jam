extends BaseLevel


func _ready() -> void:
	super()
	$LevelCollapsePlayer.play("RESET")
	
func reset_level(reset_location: Marker2D) -> void:
	super(reset_location)
	$LevelCollapsePlayer.play("RESET")


func _on_area_1_collapes_trigger_body_entered(body: Node2D) -> void:
	if not (body is Player):
		return
		
	$LevelCollapsePlayer.play("area1")


func _on_trigger_area_5_body_entered(body: Node2D) -> void:
	if not (body is Player):
		return
		
	$LevelCollapsePlayer.play("area5")

var in_boost_area = false

func _on_boost_area_body_entered(body: Node2D) -> void:
	if body is Player:
		in_boost_area = true


func _on_boost_area_body_exited(body: Node2D) -> void:
	if body is Player:
		in_boost_area = false


func _physics_process(delta: float) -> void:
	if in_boost_area:
		player.dimension_boost_charged = true
