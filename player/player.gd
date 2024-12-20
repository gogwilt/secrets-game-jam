class_name Player extends CharacterBody2D

# DEPRECATED: Use dimension_switch_status_updated instead
signal layers_switched(active_layer: Dimension)
signal dimension_switch_status_updated(new_status: DimensionSwitchStatus)
signal boost_charged
signal boost_used
signal boost_state_reset

enum Dimension { MAIN, SUB }
var active_layer: Dimension = Dimension.MAIN

var dimension_boost_charged: bool = false

var current_direction: int = 1

# Whether player inputs move the character (false when a level is completed)
var can_move: bool = true

const GRAVITY = 1500.0

const JUMP_VELOCITY = -400.0

const GROUND_INITIAL_SPEED = 100.0
const GROUND_MOVE_ACCELERATION = 500.0
const GROUND_DECELERATION = 2500.0

const AIR_INITIAL_SPEED = 100.0
const AIR_MOVE_ACCELERATION = 100.0
const AIR_DECELERATION = 100.0

# Top speeds CAN be broken, if you start with this velocity.
const GROUND_TOP_SPEED = 500.0
const AIR_TOP_SPEED = 300.0

const BOOST_SPEED_CHARGED = 500.0
const BOOST_SPEED_UNCHARGED = 500.0
const BOOST_TIME_CHARGED = 0.5
const BOOST_TIME_UNCHARGED = 0.15

enum DimensionSwitchStatus { MAIN_DIMENSION, SECRET_DIMENSION, UNABLE_TO_SWITCH_TO_MAIN, UNABLE_TO_SWITCH_TO_SECRET }
var dimension_switch_status: DimensionSwitchStatus = DimensionSwitchStatus.MAIN_DIMENSION:
	set(value):
		var status_updated = dimension_switch_status != value
		dimension_switch_status = value
		if status_updated:
			dimension_switch_status_updated.emit(value)

func _ready() -> void:
	_on_active_layer_updated()
	layers_switched.connect(_track_layer_switch_for_boost)

func _on_active_layer_updated() -> void:
	if active_layer == Dimension.MAIN:
		set_collision_mask_value(1, true)
		set_collision_layer_value(1, true)
		set_collision_mask_value(2, false)
		set_collision_layer_value(2, false)
		%AlternateLevelDetector.set_collision_mask_value(1, false)
		%AlternateLevelDetector.set_collision_mask_value(2, true)
	else:
		set_collision_mask_value(2, true)
		set_collision_layer_value(2, true)
		set_collision_mask_value(1, false)
		set_collision_layer_value(1, false)
		%AlternateLevelDetector.set_collision_mask_value(2, false)
		%AlternateLevelDetector.set_collision_mask_value(1, true)

func _physics_process(delta: float) -> void:
	if can_move and ((Input.is_action_pressed("swap_layers") and active_layer == Dimension.MAIN)
		or
		(not Input.is_action_pressed("swap_layers") and active_layer == Dimension.SUB)
		):
		# Try to switch layers
		var overlapping_bodies = %AlternateLevelDetector.get_overlapping_bodies()
		if overlapping_bodies.size() == 0 or (overlapping_bodies.size() == 1 and overlapping_bodies[0] is Player):
			active_layer = Dimension.SUB if active_layer == Dimension.MAIN else Dimension.MAIN
			_on_active_layer_updated()
			layers_switched.emit(active_layer)
			dimension_switch_status = DimensionSwitchStatus.MAIN_DIMENSION if active_layer == Dimension.MAIN else DimensionSwitchStatus.SECRET_DIMENSION
		else:
			dimension_switch_status = DimensionSwitchStatus.UNABLE_TO_SWITCH_TO_MAIN if active_layer == Dimension.SUB else DimensionSwitchStatus.UNABLE_TO_SWITCH_TO_SECRET
	else:
		dimension_switch_status = DimensionSwitchStatus.MAIN_DIMENSION if active_layer == Dimension.MAIN else DimensionSwitchStatus.SECRET_DIMENSION

	var direction := Input.get_axis("move_left", "move_right") if can_move else 0.0
	var unit_direction := 0 if direction == 0 else 1 if direction > 0 else -1
	if unit_direction and current_direction != unit_direction:
		current_direction = unit_direction
		$AnimatedSprite2D.scale *= Vector2(-1, 1)

func _track_layer_switch_for_boost(layer: Dimension) -> void:
	if layer == Dimension.SUB:
		%BoostChargeTimer.start()
	else:
		%BoostChargeTimer.stop()

func _on_boost_charge_timer_timeout() -> void:
	grant_boost_charge()
	
func grant_boost_charge() -> void:
	dimension_boost_charged = true
	$AnimationPlayer.play("boost_charged_completed")
	_update_num_boosts_indicator()
	boost_charged.emit()
	
var boost_effect_img: Texture2D
var boost_effect_img_flip: Texture2D
	
func use_boost() -> void:
	dimension_boost_charged = false
	# Instantiate boost direction image textures
	if not boost_effect_img_flip:
		boost_effect_img = %BoostEffect.texture
		var img = boost_effect_img.get_image()
		img.flip_x()
		boost_effect_img_flip = ImageTexture.create_from_image(img)
	if current_direction >= 0:
		%BoostEffect.texture = boost_effect_img
	else:
		%BoostEffect.texture = boost_effect_img_flip
	%BoostEffect.emitting = true
	boost_used.emit()
	_update_num_boosts_indicator()
	
func end_boost() -> void:
	%BoostEffect.emitting = false
	if not dimension_boost_charged:
		$AnimationPlayer.play("boost_charged")
	
func _update_num_boosts_indicator() -> void:
	var boost_indicators = get_tree().get_nodes_in_group("num_boost_indicator")
	var num_available = %BoostState.num_boosts_available()
	for i in range(boost_indicators.size()):
		boost_indicators[i].visible = i < num_available
	
func animate_idle() -> void:
	$AnimatedSprite2D.play("default")
	$AnimatedSprite2D.rotation = 0

func animate_jump_up() -> void:
	$AnimatedSprite2D.play("jump_up")
	$AnimatedSprite2D.rotation = 0
	
func animate_jump_down() -> void:
	$AnimatedSprite2D.play("jump_down")
	$AnimatedSprite2D.rotation = 0
	
func animate_run() -> void:
	$AnimatedSprite2D.play("run")
	$AnimatedSprite2D.rotation = 0
	
func animate_boost() -> void:
	$AnimatedSprite2D.play("boost")
	$AnimatedSprite2D.rotation = 0
	
func animate_boost_up() -> void:
	$AnimatedSprite2D.play("boost")
	if current_direction > 0:
		$AnimatedSprite2D.rotation = PI / 2 * 3
	else:
		$AnimatedSprite2D.rotation = PI / 2
	
func animate_boost_down() -> void:
	$AnimatedSprite2D.play("boost")
	if current_direction > 0:
		$AnimatedSprite2D.rotation = PI / 2
	else:
		$AnimatedSprite2D.rotation = PI / 2 * 3


func _on_boost_state_reset() -> void:
	_update_num_boosts_indicator()
