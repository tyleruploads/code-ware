extends Node2D

var buttons_pressed: int = 0

func _process(delta: float) -> void:
	if buttons_pressed == 18:
		if Global.minigames_done > Global.minigames_until_end:
			get_tree().change_scene_to_file("res://scenes/done_screen.tscn")
		else:
			get_tree().change_scene_to_file("res://Scenes/level_screen.tscn")
