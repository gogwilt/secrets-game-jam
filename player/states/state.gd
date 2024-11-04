class_name State extends Node

signal finished(next_state: String, data: Dictionary)

func enter(prev_state: String, data:= {}) -> void:
	pass
	
func exit() -> void:
	pass
	
func physics_update(delta: float) -> void:
	pass
	
func update(delta: float) -> void:
	pass
	
func handle_input(event: InputEvent) -> void:
	pass
