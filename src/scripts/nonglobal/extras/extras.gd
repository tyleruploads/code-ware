extends Node2D

func _on_back_button_down() -> void:
	get_tree().change_scene_to_file("res://Scenes/other/title_screen.tscn")

func _on_gallery_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/extras/gallery.tscn")


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/extras/credits.tscn")
