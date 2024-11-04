extends State

@export var player: Player
@export var falling_state: State

func enter(prev_state: String, data:= {}) -> void:
	pass
	
func exit() -> void:
	pass
	
func physics_update(delta: float) -> void:
	if not player.is_on_floor():
		finished.emit(falling_state.name)
		return

	var direction := Input.get_axis("move_left", "move_right")
	var unit_direction := 0 if direction == 0 else 1 if direction > 0 else -1
	var is_switching_direction = direction and (
		(player.velocity.x > 0 and direction < 0) or
		(player.velocity.x < 0 and direction > 0)
	)
	if direction and (abs(player.velocity.x) < Player.GROUND_INITIAL_SPEED):
		# Starting to move from near motionless
		player.velocity.x = direction * Player.GROUND_INITIAL_SPEED
	elif direction and not is_switching_direction:
		# Accelerating in same direction
		if abs(player.velocity.x) > Player.GROUND_TOP_SPEED:
			# Keep velocity the same if player is higher than top speed
			pass
		else:
			player.velocity.x = move_toward(player.velocity.x, unit_direction * Player.GROUND_TOP_SPEED, Player.GROUND_MOVE_ACCELERATION * delta)
	elif direction and is_switching_direction:
		# Sticky floor if player wants to stop suddenly
		player.velocity.x = 0 # move_toward(player.velocity.x, direction * Player.GROUND_TOP_SPEED, Player.GROUND_DECELERATION * delta)
	else:
		# No input, so quickly decelerate
		player.velocity.x = move_toward(player.velocity.x, 0, Player.GROUND_DECELERATION * delta)

	player.move_and_slide()
	
func update(delta: float) -> void:
	pass

func handle_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("jump"):
		player.velocity.y = Player.JUMP_VELOCITY
		finished.emit(falling_state.name)
		return
