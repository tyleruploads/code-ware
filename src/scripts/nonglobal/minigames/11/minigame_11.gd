extends Node

const CHARS = [
	"a",
	"b",
	"c",
	"d",
	"e",
	"f",
	"g",
	"h",
	"i",
	"j",
	"k",
	"m",
	"n",
	"o",
	"p",
	"q",
	"r",
	"s",
	"t",
	"u",
	"v",
	"w",
	"x",
	"y",
	"z",
	"A",
	"B",
	"C",
	"D",
	"E",
	"F",
	"G",
	"H",
	"J",
	"K",
	"L",
	"M",
	"N",
	"P",
	"Q",
	"R",
	"T",
	"U",
	"V",
	"W",
	"X",
	"Y",
	"3",
	"4",
	"6",
	"7",
	"8",
	"9",
]
const TARGET_SCORE: int = 15

@export var minigame_name: String = "Type the Strings!"
@export var prompt: String = "TYPE!"
@export var description: String = """
Type 15 5-character strings into the entry box in less than one minute!
"""

var target_text: String
var target_len: int = 5

var score: int = 0

@onready var timer: Label = $Timer

@onready var score_node: RichTextLabel = $"ScoreNode"
@onready var text_node: RichTextLabel = $"ColorRect/TextNode"
@onready var line_edit: LineEdit = $"HBoxContainer/LineEdit"

@onready var submit_noise: AudioStreamPlayer2D = $Sounds/Submit

@onready var notice_color_node: ColorRect = $NoticeNode
@onready var notice_text_node: Label = $NoticeNode/TextNode


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	notice_color_node.hide()
	line_edit.edit() # Focuses on LineEdit automatically
	line_edit.text_changed.connect(_on_text_changed)

	generate_str(target_len)


func generate_str(length: int) -> void:
	var result: String = ""

	for i in range(length):
		result += CHARS.pick_random()

	target_text = result

	line_edit.clear()

	text_node.bbcode_text = """
[font_size=60][color=red]Write the string:[/color][/font_size]
[font_size=40][color=blue]{target_text}[/color][/font_size]
""".format({ "target_text": target_text })


func increment_score(num: int) -> void:
	score += num
	score_node.text = "{score}/{TARGET_SCORE}".format(
		{ "score": str(score), "TARGET_SCORE": str(TARGET_SCORE) }
	)

	if num > 0:
		make_notice(Color.GREEN, "Correct!", 0.5)
	else:
		make_notice(Color.RED, "Incorrect!", 2)

	if score == TARGET_SCORE:
		var tree := Engine.get_main_loop() as SceneTree

		if is_inside_tree() and get_tree():
			get_tree().change_scene_to_file("res://Scenes/other/level_screen.tscn")
		elif tree:
			tree.change_scene_to_file("res://Scenes/other/level_screen.tscn")
		else:
			printerr("Could not access SceneTree to change scene!")


func make_notice(color: Color, text: String, time: float) -> void:
	notice_color_node.show()
	notice_color_node.color = color

	notice_text_node.text = text
	notice_text_node.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	notice_text_node.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

	await get_tree().create_timer(time, false).timeout
	notice_color_node.hide()


func _on_text_changed(new_text: String) -> void:
	if new_text == target_text:
		increment_score(1)
		generate_str(target_len)
		return

	if len(new_text) == len(target_text):
		increment_score(0) # This is just to show the notice
		generate_str(target_len)
		return
