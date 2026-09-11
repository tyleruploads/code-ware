extends Node

var minigames_done = 0
var lives = 5
var minigames_until_end = 2
var reset_after_death: bool = false # When it is time to restart, set to true
var full_reset: bool = false # Actual reset, without the fluff
var paused: bool = false

func _enter_tree() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event: InputEvent) -> void:
	# Check if input is a key press (not a release or any other input)
	if event is InputEventKey and event.pressed and not event.echo:
		print("Input")
		match event.physical_keycode:
			KEY_R:
				# R for Reset, reloads the current scene
				get_tree().reload_current_scene()
			KEY_ESCAPE:
				# Pauses or unpauses the game
				paused = !paused
				get_tree().paused = paused
