class_name BaseLevel extends Node2D

signal level_completed

@export var player_start_position: Marker2D
@export var level_end_area: Area2D
@export var level_valid_area: Area2D
@export var collected_cards: Array = []
@export var camera_limit_bottom: int = 10000000

const SHAKE_MAGNITUDE = 5.0

var player: Player
var collected_this_run: Array = []
var camera: Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	assert(player)
	if player_start_position:
		player.position = player_start_position.position
		player.velocity = Vector2.ZERO
	if level_end_area:
		# Player is on layer 3, so it doesn't interfere with dimension switch collision detection
		level_end_area.set_collision_mask_value(3, true)
		level_end_area.connect("body_entered", _on_level_end_area_body_entered, ConnectFlags.CONNECT_ONE_SHOT)
	if level_valid_area:
		level_valid_area.set_collision_mask_value(3, true)
		level_valid_area.connect("body_exited", _on_level_valid_area_body_exited)
		
	camera = get_tree().get_first_node_in_group("player_camera")
	camera.limit_bottom = camera_limit_bottom
		
	collected_this_run = []
	var cards = get_tree().get_nodes_in_group("collectible_cards")
	for i in range(cards.size()):
		var card: CollectibleCard = cards[i]
		card.connect("card_collected", _on_card_collected.bind(i))
	_update_collected_cards()
		
func _update_collected_cards() -> void:
	var cards = get_tree().get_nodes_in_group("collectible_cards")
	for i in range(cards.size()):
		var card: CollectibleCard = cards[i]
		if collected_this_run.has(i):
			card.collected = CollectibleCard.CollectionStatus.COLLECTED_THIS_RUN
		elif collected_cards.has(i):
			card.collected = CollectibleCard.CollectionStatus.PREVIOUSLY_COLLECTED
		# TODO Not sure why this is necessary, but cards don't initialize properly in levels
		card._update_card_visual()

func _on_level_end_area_body_entered(body: Node2D) -> void:
	if body is Player:
		level_completed.emit()
		
func _on_level_valid_area_body_exited(body: Node2D) -> void:
	if body is Player and player_start_position:
		player.position = player_start_position.position
		player.velocity = Vector2.ZERO

func _on_card_collected(card: CollectibleCard, index: int) -> void:
	player.grant_boost_charge()
	if not collected_this_run.has(index):
		collected_this_run.append(index)
		if not collected_cards.has(index):
			collected_cards.append(index)
			collected_cards.sort()
		_update_collected_cards()

var shake_timer: SceneTreeTimer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if shake_timer:
		camera.offset = Vector2(randf_range(-SHAKE_MAGNITUDE, SHAKE_MAGNITUDE), randf_range(-SHAKE_MAGNITUDE, SHAKE_MAGNITUDE))
	else:
		camera.offset = Vector2.ZERO

func shake_camera(duration: float) -> void:
	shake_timer = get_tree().create_timer(duration)
	await shake_timer.timeout
	shake_timer = null
