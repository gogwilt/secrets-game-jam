extends State

@export var player: Player
@export var ground_state: State
@export var boost_state: BoostState

func enter(prev_state: String, data:= {}) -> void:
	pass
	
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
	
	if direction == 0:
		# Decelerate
		player.velocity.x = move_toward(player.velocity.x, 0, Player.AIR_DECELERATION * delta)
	elif is_switching_direction:
		# Quickly decelerate
		player.velocity.x = move_toward(player.velocity.x, 0, 2 * Player.AIR_DECELERATION * delta)
	elif (abs(player.velocity.x) < Player.AIR_INITIAL_SPEED):
		# Starting to move from near motionless
		player.velocity.x = direction * Player.AIR_INITIAL_SPEED
	else:
		# Accelerating in same direction
		if abs(player.velocity.x) > Player.AIR_TOP_SPEED:
			# Keep velocity the same if player is higher than top speed
			pass
		else:
			player.velocity.x = move_toward(player.velocity.x, unit_direction * Player.AIR_TOP_SPEED, Player.AIR_MOVE_ACCELERATION * delta)

	if player.velocity.y < 0:
		player.animate_jump_up()
	else:
		player.animate_jump_down()

	player.move_and_slide()
	
func update(delta: float) -> void:
	if Input.is_action_just_pressed("boost") and boost_state.can_boost():
		finished.emit(boost_state.name,{"boost_charged": player.dimension_boost_charged})
