extends BaseLevel

var tutorial_layer: CanvasLayer

func _ready() -> void:
	super()
	var using_controller = Input.get_connected_joypads().size() > 0
	$TutorialKeyboard.visible = not using_controller
	$TutorialController.visible = using_controller
	hide_instructions()

func show_instructions(name: String) -> void:
	for child in $TutorialKeyboard.get_children():
		child.visible = child.name == name
	for child in $TutorialController.get_children():
		child.visible = child.name == name

func hide_instructions() -> void:
	show_instructions("")

func _on_movement_instructions_body_entered(body: Node2D) -> void:
	if body is Player:
		show_instructions("Movement")


func _on_movement_instructions_body_exited(body: Node2D) -> void:
	if body is Player:
		hide_instructions()


func _on_dimension_instructions_body_entered(body: Node2D) -> void:
	if body is Player:
		show_instructions("SwitchDimensions")


func _on_dimension_instructions_body_exited(body: Node2D) -> void:
	if body is Player:
		hide_instructions()
		


func _on_boost_instructions_body_entered(body: Node2D) -> void:
	if body is Player:
		show_instructions("DimensionBoost")


func _on_boost_instructions_body_exited(body: Node2D) -> void:
	if body is Player:
		hide_instructions()
