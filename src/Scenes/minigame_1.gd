extends Node2D

@export var minigame_name: String = "Orb Collection Platformer"
@export var prompt: String = "COLLECT!"
@export var description: String = "Gather 7 tyleruploads orbs in 25s using Arrow Keys & Spacebar."

var tylers_collected = 0

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	if tylers_collected == 7:
		if Global.minigames_done > 2:
			get_tree().change_scene_to_file("res://scenes/done_screen.tscn")
		else:
			get_tree().change_scene_to_file("res://Scenes/level_screen.tscn")
		
func tyler_collect() -> void:
	tylers_collected += 1
	return
