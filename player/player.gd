class_name Player extends CharacterBody2D

signal layers_switched(active_layer: Dimension)

enum Dimension { MAIN, SUB }
var active_layer: Dimension = Dimension.MAIN

const GRAVITY = 1000.0

const JUMP_VELOCITY = -300.0

const GROUND_INITIAL_SPEED = 200.0
const GROUND_MOVE_ACCELERATION = 1000.0
const GROUND_DECELERATION = 5000.0

const AIR_INITIAL_SPEED = 100.0
const AIR_MOVE_ACCELERATION = 200.0
const AIR_DECELERATION = 500.0

# Top speeds CAN be broken, if you start with this velocity.
const GROUND_TOP_SPEED = 1000.0
const AIR_TOP_SPEED = 500.0

func _ready() -> void:
	_on_active_layer_updated()

func _on_active_layer_updated() -> void:
	if active_layer == Dimension.MAIN:
		set_collision_mask_value(1, true)
		set_collision_mask_value(2, false)
		%AlternateLevelDetector.set_collision_mask_value(1, false)
		%AlternateLevelDetector.set_collision_mask_value(2, true)
	else:
		set_collision_mask_value(2, true)
		set_collision_mask_value(1, false)
		%AlternateLevelDetector.set_collision_mask_value(2, false)
		%AlternateLevelDetector.set_collision_mask_value(1, true)


func _physics_process(delta: float) -> void:
	if ((Input.is_action_pressed("swap_layers") and active_layer == Dimension.MAIN)
		or
		(not Input.is_action_pressed("swap_layers") and active_layer == Dimension.SUB)
		):
		# Try to switch layers
		if not %AlternateLevelDetector.has_overlapping_bodies():
			active_layer = Dimension.SUB if active_layer == Dimension.MAIN else Dimension.MAIN
			_on_active_layer_updated()
			layers_switched.emit(active_layer)
