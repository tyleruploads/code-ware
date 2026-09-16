extends Node2D

@export var minigame_name: String = "Click Very Fast!"
@export var prompt: String = "CLICK!"
@export var description: String = "Click as fast as you can on the red circle in the middle! Get at least 100 clicks in 20 seconds"

@onready var clickButton = $ClickButton
@onready var timer: Label = $timer
@onready var scoreNode: RichTextLabel = $ClickScore

var required_clicks: int = 100
var clicks: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	clickButton.pressed.connect(buttonPressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func buttonPressed() -> void:
	clicks += 1
	scoreNode.text = "{clicks}/{req_clicks} Clicks".format({
		"clicks": str(clicks).pad_zeros(2),
		"req_clicks": required_clicks
	})
	
	if clicks >= required_clicks:
		var tree := Engine.get_main_loop() as SceneTree
		if is_inside_tree() and get_tree():
			get_tree().change_scene_to_file("res://Scenes/level_screen.tscn")
			return
		elif tree:
			tree.change_scene_to_file("res://Scenes/level_screen.tscn")
			return
		else:
			printerr("Could not access SceneTree to change scene!")
			return
