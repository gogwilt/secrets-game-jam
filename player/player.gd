class_name Player extends CharacterBody2D

signal layers_switched

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
