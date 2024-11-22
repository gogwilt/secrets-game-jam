class_name CollectibleCard extends Area2D

signal card_collected(card: CollectibleCard)

enum CollectionStatus { UNCOLLECTED, PREVIOUSLY_COLLECTED, COLLECTED_THIS_RUN }

@export var collected: CollectionStatus = CollectionStatus.UNCOLLECTED:
	set(value):
		collected = value
		_update_card_visual()
@export var is_secret_world: bool = false:
	set(value):
		is_secret_world = value
		_update_card_visual()

func _ready() -> void:
	_update_card_visual()
	
func _update_card_visual() -> void:
	if collected == CollectionStatus.PREVIOUSLY_COLLECTED:
		$AnimationPlayer.play("previously_collected")
	elif collected == CollectionStatus.UNCOLLECTED:
		$AnimationPlayer.play("uncollected")
	else:
		$AnimationPlayer.play("collected")
		
	var material = $TarotBack.material as CanvasItemMaterial
	if is_secret_world:
		z_index = 0
		$TarotBack.light_mask = 2
		collision_mask = 2
		material.light_mode = CanvasItemMaterial.LIGHT_MODE_LIGHT_ONLY
		material.blend_mode = CanvasItemMaterial.BLEND_MODE_MIX
	else:
		z_index = -1
		$TarotBack.light_mask = 1
		material.light_mode = CanvasItemMaterial.LIGHT_MODE_UNSHADED
		material.blend_mode = CanvasItemMaterial.BLEND_MODE_MIX
		collision_mask = 1

func _on_body_entered(body: Node2D) -> void:
	var tarot_back = $TarotBack
	if body is Player:
		card_collected.emit(self)
