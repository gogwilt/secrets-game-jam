extends Node2D

var is_main_in_foreground = true

func _ready() -> void:
	is_main_in_foreground = true
	_set_layer_to_foreground($SubLayerParallax, %SubLayer)
	_set_layer_to_background($MainLayerParallax, %MainLayer)

func swap_layers() -> void:
	if is_main_in_foreground:
		_set_layer_to_background($SubLayerParallax, %SubLayer)
		_set_layer_to_foreground($MainLayerParallax, %MainLayer)
		is_main_in_foreground = false
	else:
		_set_layer_to_foreground($SubLayerParallax, %SubLayer)
		_set_layer_to_background($MainLayerParallax, %MainLayer)
		is_main_in_foreground = true

func _set_layer_to_background(parallax: Parallax2D, layer: TileMapLayer) -> void:
	parallax.scroll_scale = Vector2(0.9, 0.9)
	parallax.scroll_offset = Vector2(0, 0)
	parallax.scale = Vector2(0.9, 0.9)
	parallax.z_index = -1
	layer.collision_enabled = false

func _set_layer_to_foreground(parallax: Parallax2D, layer: TileMapLayer) -> void:
	parallax.scroll_scale = Vector2(1, 1)
	parallax.scroll_offset = Vector2(0, 0)
	parallax.scale = Vector2(1, 1)
	parallax.z_index = 0
	layer.collision_enabled = true


func _on_player_layers_switched() -> void:
	swap_layers()
