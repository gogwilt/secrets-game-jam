@tool
class_name PortraitDialogueBox extends Control

@export var portrait_image: Texture2D:
	set(new_image):
		portrait_image = new_image
		update_portrait()
@export var character_name: String:
	set(new_name):
		character_name = new_name
		update_labels()
@export_multiline var dialog: String:
	set(new_dialog):
		dialog = new_dialog
		update_labels()


func _ready() -> void:
	update_labels()
	update_portrait()

func update_labels():
	if character_name:
		$CharacterName.set_text(character_name)
	if dialog:
		$Text.set_text(dialog)
	queue_redraw()

func update_portrait():
	if portrait_image:
		$Portrait.texture = portrait_image
		queue_redraw()
