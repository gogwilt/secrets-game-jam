extends Node2D

var level_player_scene = preload("res://concepts/level_player.tscn")

var level_player: LevelPlayer

func _ready() -> void:
	level_player = level_player_scene.instantiate()


func _on_level_select_menu_level_selected(level_name: String) -> void:
	add_child(level_player)
	level_player.load_level(level_name)
	$LevelSelectMenu.visible = false
