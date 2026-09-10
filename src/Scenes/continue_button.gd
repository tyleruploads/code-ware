extends TextureButton

func _pressed() -> void:
	Global.reset_after_death = true;
	
	hide()
	await get_tree().create_timer(3).timeout
	
	$"../Node2D".hide()

	await get_tree().create_timer(3).timeout
	
	get_tree().change_scene_to_file("res://Scenes/level_screen.tscn")
