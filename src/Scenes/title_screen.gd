extends Node2D
@onready var v_text_label = $Version


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var version: String = ProjectSettings.get_setting("application/config/version")
	v_text_label.text = version


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/level_screen.tscn")


func _on_extras_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/extras.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
