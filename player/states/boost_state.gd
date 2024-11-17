class_name BoostState extends State

@export var player: Player
@export var falling_state: State
@export var ground_state: State

var count_boosts_in_air := 0
var boost_charged := false

func enter(prev_state: String, data:= {"boost_charged": false}) -> void:
	if data.boost_charged:
		boost_charged = true
	
	var speed = Player.BOOST_SPEED_UNCHARGED
	var time = Player.BOOST_TIME_UNCHARGED
	if boost_charged:
		player.use_boost()
		speed = Player.BOOST_SPEED_CHARGED
		time = Player.BOOST_TIME_CHARGED
	
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
		
	count_boosts_in_air += 1
	
func exit() -> void:
	$Timer.stop()
	player.end_boost()
	
func physics_update(delta: float) -> void:
	player.move_and_slide()
	
func update(delta: float) -> void:
	pass

func handle_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("jump"):
		player.velocity.y = Player.JUMP_VELOCITY
		finished.emit(falling_state.name)
		return
		
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction.length_squared() > 0 and direction.angle_to(player.velocity) > PI / 2:
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
	boost_charged = false
