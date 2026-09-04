extends Node2D

var tylers_collected = 0

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	if tylers_collected == 5:
		if Global.minigames_done > 2:
			get_tree().change_scene_to_file("res://scenes/done_screen.tscn")
		else:
			get_tree().change_scene_to_file("res://Scenes/level_screen.tscn")
		
func tyler_collect() -> void:
	tylers_collected += 1
	return
