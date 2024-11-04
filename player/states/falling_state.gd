extends State

@export var player: Player
@export var ground_state: State

const DOUBLE_JUMPS = 1
var double_jumps_remaining: int

func enter(prev_state: String, data:= {}) -> void:
	double_jumps_remaining = DOUBLE_JUMPS
	
func exit() -> void:
	pass
	
func physics_update(delta: float) -> void:
	# Gravity
	if Input.is_action_pressed("jump"):
		player.velocity.y += Player.GRAVITY / 2 * delta
	else:
		player.velocity.y += Player.GRAVITY * delta
	
	if player.is_on_floor():
		finished.emit(ground_state.name)
		return

	var direction := Input.get_axis("move_left", "move_right")
	var unit_direction := 0 if direction == 0 else 1 if direction > 0 else -1
	var is_switching_direction = direction and (
		(player.velocity.x > 0 and direction < 0) or
		(player.velocity.x < 0 and direction > 0)
	)
	if direction and (abs(player.velocity.x) < Player.AIR_INITIAL_SPEED):
		# Starting to move from near motionless
		player.velocity.x = direction * Player.AIR_INITIAL_SPEED
	elif direction and not is_switching_direction:
		# Accelerating in same direction
		if abs(player.velocity.x) > Player.AIR_TOP_SPEED:
			# Keep velocity the same if player is higher than top speed
			pass
		else:
			player.velocity.x = move_toward(player.velocity.x, unit_direction * Player.AIR_TOP_SPEED, Player.AIR_MOVE_ACCELERATION * delta)
	elif direction and is_switching_direction:
		# Player wants to shift in other direction
		player.velocity.x = move_toward(player.velocity.x, unit_direction * Player.AIR_TOP_SPEED, Player.AIR_DECELERATION * delta)
	else:
		# No input, so quickly decelerate
		player.velocity.x = move_toward(player.velocity.x, 0, Player.AIR_DECELERATION * delta)


	player.move_and_slide()
	
func update(delta: float) -> void:
	if Input.is_action_just_pressed("jump") and double_jumps_remaining > 0:
		double_jumps_remaining -= 1
		player.velocity.y = Player.JUMP_VELOCITY
