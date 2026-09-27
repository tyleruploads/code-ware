extends Node

@export var minigame_name: String = "The Maze"
@export var prompt: String = "MAZE!"
@export var description: String = "Get to the center of the maze in 30 seconds!"

@onready var player: CharacterBody2D = $Player
@onready var center_orb = $CenterOrb
@onready var timer: Label = $Timer


func _ready() -> void:
	center_orb.maze_finished.connect(_on_maze_finish)


func _on_maze_finish() -> void:
	var tree := Engine.get_main_loop() as SceneTree
	if is_inside_tree() and get_tree():
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/other/level_screen.tscn")
	elif tree:
		tree.call_deferred("change_scene_to_file", "res://Scenes/other/level_screen.tscn")
	else:
		printerr("Could not access SceneTree to change scene!")

	return
