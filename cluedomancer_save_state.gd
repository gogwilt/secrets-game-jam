class_name CluedomancerSaveState extends Node

const SAVE_LOCATION = "user://cluedomancer_save.json"

const VERSION = "0.4"
var level_info: Array

signal save_data_updated

func save_game() -> void:
	var save_file = FileAccess.open(SAVE_LOCATION, FileAccess.WRITE)
	var json_string = _state_to_json()
	save_file.store_line(VERSION)
	save_file.store_line(json_string)
	
func load_game() -> void:
	if not FileAccess.file_exists(SAVE_LOCATION):
		level_info = []
		return
	var save_file = FileAccess.open(SAVE_LOCATION, FileAccess.READ)
	var version = save_file.get_line()
	if version != VERSION:
		level_info = []
		return
	var level_info_string = save_file.get_line()
	_load_state_from_json(level_info_string)
		
func has_save_data() -> bool:
	if not FileAccess.file_exists(SAVE_LOCATION):
		return false
	var save_file = FileAccess.open(SAVE_LOCATION, FileAccess.READ)
	var version = save_file.get_line()
	return version == VERSION
	
func on_new_game() -> void:
	level_info = []
	save_game()
	save_data_updated.emit()
	
func on_level_complete(level_name: String, time_elapsed: float, collected_cards: Array) -> void:
	var level_data: Dictionary
	for d: Dictionary in level_info:
		if d.name == level_name:
			level_data = d
			break
	if not level_data:
		level_data = {
			"name": level_name,
			"complete": true,
			"completion_times": [],
			"collected_cards": [],
		}
		level_info.append(level_data)

	# Modify level_data to include top awards, speed run time, etc
	level_data.completion_times.append(time_elapsed)
	level_data.completion_times.sort()
	level_data.collected_cards = collected_cards
	
	save_data_updated.emit()
	
func get_level_data(level_name: String) -> Dictionary:
	for d: Dictionary in level_info:
		if d.name == level_name:
			return d
	return {
		"name": level_name,
		"complete": false,
		"completion_times": [],
		"collected_cards": [],
	}

func _state_to_json() -> String:
	return JSON.stringify(level_info)

func _load_state_from_json(json_string: String) -> void:
	level_info = JSON.parse_string(json_string)
	save_data_updated.emit()
