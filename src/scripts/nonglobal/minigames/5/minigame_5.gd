extends Node2D

@export var minigame_name: String = "Click Very Fast!"
@export var prompt: String = "CLICK!"
@export var description: String = "Click as fast as you can on the red circle in" \
		+ "the middle! Get at least 100 clicks in 20 seconds"

var required_clicks: int = 100
var clicks: int = 0

@onready var click_button = $Button
@onready var timer: Label = $Timer
@onready var score_node: RichTextLabel = $Score
@onready var click_noise: AudioStreamPlayer2D = $"Sounds/click"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.minigames_done = 5
	click_button.pressed.connect(button_pressed)


func button_pressed() -> void:
	clicks += 1
	score_node.text = "{clicks}/{req_clicks} Clicks".format(
		{ "clicks": str(clicks).pad_zeros(2), "req_clicks": required_clicks }
	)

	click_noise.play()

	if clicks >= required_clicks:
		var tree := Engine.get_main_loop() as SceneTree
		if is_inside_tree() and get_tree():
			get_tree().change_scene_to_file("res://Scenes/other/level_screen.tscn")
		elif tree:
			tree.change_scene_to_file("res://Scenes/other/level_screen.tscn")
		else:
			printerr("Could not access SceneTree to change scene!")

		return
