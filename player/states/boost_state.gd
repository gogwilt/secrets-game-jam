extends State

@export var player: Player
@export var falling_state: State
@export var ground_state: State

func enter(prev_state: String, data:= {}) -> void:
	$Timer.start()
	var direction := Input.get_axis("move_left", "move_right")
	var unit_direction := 0 if direction == 0 else 1 if direction > 0 else -1
	player.velocity.x = Player.BOOST_SPEED * unit_direction
	player.velocity.y = 0
	
func exit() -> void:
	$Timer.stop()
	
func physics_update(delta: float) -> void:
	player.move_and_slide()
	
func update(delta: float) -> void:
	pass

func handle_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("jump"):
		player.velocity.y = Player.JUMP_VELOCITY
		finished.emit(falling_state.name)
		return

func _on_timer_timeout() -> void:
	if player.is_on_floor():
		finished.emit(ground_state.name)
	else:
		finished.emit(falling_state.name)
