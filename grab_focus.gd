extends Button

@export var menu_container: CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	menu_container.connect("visibility_changed", _on_owner_visibility_changed)

func _on_owner_visibility_changed() -> void:
	if menu_container.visible:
		grab_focus()
