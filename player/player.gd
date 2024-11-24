class_name Player extends CharacterBody2D

signal layers_switched(active_layer: Dimension)
signal boost_charged
signal boost_used

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
	_on_boost_charge_update()
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
	_on_boost_charge_update()
	boost_used.emit()
	
func end_boost() -> void:
	%BoostEffect.emitting = false
	
func _on_boost_charge_update() -> void:
	$BoostIndicator2.visible = dimension_boost_charged
	$AnimationPlayer.play("boost_charged")
	
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
