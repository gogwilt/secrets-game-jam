class_name BoostState extends State

@export var player: Player
@export var falling_state: State
@export var ground_state: State

var count_boosts_in_air := 0

func enter(prev_state: String, data:= {"boost_charged": false}) -> void:
	
	var speed = Player.BOOST_SPEED_UNCHARGED
	var time = Player.BOOST_TIME_UNCHARGED
	if data.boost_charged:
		player.use_boost()
		speed = Player.BOOST_SPEED_CHARGED
		time = Player.BOOST_TIME_CHARGED
	else:
		count_boosts_in_air += 1
	
	$Timer.start(time)
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if direction.length_squared() > 0:
		player.velocity = speed * direction.normalized()
	else:
		player.velocity = Vector2(speed * player.current_direction, 0)

	if abs(player.velocity.angle_to(Vector2.UP)) < PI / 8:
		player.animate_boost_up()
	elif abs(player.velocity.angle_to(Vector2.DOWN)) < PI / 8:
		player.animate_boost_down()
	else:
		player.animate_boost()
	
func exit() -> void:
	$Timer.stop()
	player.end_boost()
	
func physics_update(delta: float) -> void:
	player.move_and_slide()
	
func update(delta: float) -> void:
	pass

func handle_input(event: InputEvent) -> void:
	
	# Allow jump during a boost. Jumping ends boost
	if Input.is_action_just_pressed("jump"):
		player.velocity.y = Player.JUMP_VELOCITY
		finished.emit(falling_state.name)
		return
		
	# Allow player to adjust direction while boosting
	# If player tries to go in the opposite direction, end boost
	# Weigh new direction less when delta is larger to create smooth feel
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction.length_squared() > 0:
		var angle = rad_to_deg(direction.angle_to(player.velocity))
		
		if abs(angle) > 120:
			player.velocity = Vector2(0,0)
		
		else:
			var weight = (180-abs(angle))/360
			var current_speed = player.velocity.length() 
			var current_direction = player.velocity.normalized()
			var blended_direction = current_direction.lerp(direction.normalized(), weight)
			player.velocity = blended_direction.normalized() * current_speed
		
	if player.velocity.length_squared() == 0:
		finished.emit(falling_state.name)

func _on_timer_timeout() -> void:
	if player.is_on_floor():
		finished.emit(ground_state.name)
	else:
		finished.emit(falling_state.name)
	
func can_boost() -> bool:
	return count_boosts_in_air < 2
	
func reset() -> void:
	count_boosts_in_air = 0
