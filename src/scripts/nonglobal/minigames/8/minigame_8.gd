extends Node2D

@export var minigame_name: String = "Choose the Boxes!"
@export var prompt: String = "CHOOSE!"
@export var description: String = "You have 30 seconds to match 20 boxes. When the color of the box in the center changes, click the box on the bottom that has its color!"

@onready var timer: Label = $timer
@onready var score_node: RichTextLabel = $score
@onready var center_button: Button = $"CenterButtonContainer/Button"

@onready var click_noise: AudioStreamPlayer2D = $"Sounds/click"

@onready var bottom_buttons = {
	"red": $"BottomButtonsContainer/Red",
	"green": $"BottomButtonsContainer/Green",
	"blue": $"BottomButtonsContainer/Blue",
	"yellow": $"BottomButtonsContainer/Yellow",
}

var color: String = "red"
var last_color: String = "red"

var score: int = 0
const SCORE_AIM: int = 20

var color_timer: Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for key in bottom_buttons:
		bottom_buttons[key].pressed.connect(_on_button_pressed.bind(key))
		
	# Make timer for changing colors
	color_timer = Timer.new()
	color_timer.wait_time = 2.0
	color_timer.one_shot = false
	color_timer.timeout.connect(change_color)
	add_child(color_timer)
	
	change_color()

func increment_score(num) -> void:
	score += num

	score_node.text = "{score}/{SCORE_AIM}".format({
		"score": score,
		"SCORE_AIM": SCORE_AIM
	})
	
	if score == SCORE_AIM:
		var tree := Engine.get_main_loop() as SceneTree
		if is_inside_tree() and get_tree():
			get_tree().change_scene_to_file("res://Scenes/other/level_screen.tscn")
			return
		elif tree:
			tree.change_scene_to_file("res://Scenes/other/level_screen.tscn")
			return
		else:
			printerr("Could not access SceneTree to change scene!")
			return
		
func change_color() -> void:
	var colors: Dictionary = {
		"red": Color.RED,
		"green": Color.GREEN,
		"blue": Color.BLUE,
		"yellow": Color.YELLOW,
	}
	
	while true:
		color = colors.keys().pick_random()
		
		if color != last_color:
			last_color = color
			break
	
	var new_style = StyleBoxFlat.new()
	new_style.bg_color = colors[color]
	
	center_button.add_theme_stylebox_override("normal", new_style)
	center_button.add_theme_stylebox_override("hover", new_style)
	center_button.add_theme_stylebox_override("pressed", new_style)
	
	color_timer.start()
	
func _on_button_pressed(color_pressed) -> void:
	if color_pressed == color:
		increment_score(1)
	else:
		increment_score(-1)

	click_noise.play()
	change_color()
	color_timer.start()
