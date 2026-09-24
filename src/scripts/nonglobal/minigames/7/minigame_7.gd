extends Node2D

@export var minigame_name: String = "Pick the Lock"
@export var prompt: String = "PICK!"
@export var description: String = "Pick the lock by pressing the spacebar once the slider gets to the green rectangle! It's much easier to pick it from the left side!"

@onready var timer: Label = $timer
@onready var green_box: ColorRect = $SliderBg/HSlider/TargetZone
@onready var slider: HSlider = $SliderBg/HSlider
@onready var fail_notice: ColorRect = $FailNotice
@onready var score_node: RichTextLabel = $score
@onready var click_noise: AudioStreamPlayer2D = $"Sounds/click"

var movement_speed: float = 100.0
var moving_right: bool = true

var score: int = 0

const TARGET_MIN: float = 45.0
const TARGET_MAX: float = 55.0

const SCORE_AIM: int = 4

signal fail


func _ready() -> void:
	Global.minigames_done = 7
	
	slider.value = randf_range(0, 30)
	update_win_box_position()
	
func update_win_box_position() -> void:
	var total_range: float = slider.max_value - slider.min_value
	if total_range <= 0:
		return
		
	var min_pct: float = (TARGET_MIN - slider.min_value) / total_range
	var max_pct: float = (TARGET_MAX - slider.min_value) / total_range
	
	green_box.anchor_left = min_pct
	green_box.anchor_right = max_pct
	
	green_box.offset_left = 0
	green_box.offset_right = 0
	
	green_box.anchor_top = 0.0
	green_box.anchor_bottom = 1.0
	green_box.offset_top = 0.0
	green_box.offset_bottom = 0.0

func _process(delta: float) -> void:
	if moving_right:
		slider.value += movement_speed * delta
		if slider.value >= slider.max_value:
			slider.value = slider.max_value
			moving_right = false           
	else:
		slider.value -= movement_speed * delta
		if slider.value <= slider.min_value:
			slider.value = slider.min_value
			moving_right = true
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		check_for_win()
		click_noise.play()
		
func check_for_win() -> void:
	set_process(false)
	
	if slider.value >= TARGET_MIN and slider.value <= TARGET_MAX:
		increment_score(1)
	else:  
		fail.emit()
		print("Slider value: ", slider.value)
		
	set_process(true)

func increment_score(num: int) -> void:
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
