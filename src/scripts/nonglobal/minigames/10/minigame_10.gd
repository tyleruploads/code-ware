extends Node

@export var minigame_name: String = "RGB Skills"
@export var prompt: String = "COLOR!"
@export var description: String = "Match the two colors in one minute with 80% or more accuracy!"

var target_color: Color
var guess_color: Color

@onready var timer: Label = $Timer
@onready var accuracy_node: RichTextLabel = $Accuracy

@onready var target_node: ColorRect = $ColorDisplays/RealColor
@onready var guess_node: ColorRect = $ColorDisplays/GuessColor

@onready var sliders: VBoxContainer = $Guessing
@onready var submit_button: Button = $Guessing/Submit

@onready var submit_noise: AudioStreamPlayer2D = $Sounds/Submit


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target_color = rand_color()
	target_node.color = target_color

	var start_values = get_worst_guess(target_color)

	var idx = 0
	for child in sliders.get_children():
		if child is HSlider:
			child.value_changed.connect(_on_color_changed)
			child.value = start_values[idx] * 255.0
			idx += 1

	_on_color_changed()

	submit_button.pressed.connect(_on_submit)


func rand_color() -> Color:
	var r = randi_range(50, 205)
	var g = randi_range(50, 205)
	var b = randi_range(50, 205)

	return Color8(r, g, b)


func update_accuracy_node(accuracy) -> void:
	var accuracy_color

	if abs(accuracy) >= 80:
		accuracy_color = "green"
	else:
		accuracy_color = "red"

	accuracy_node.bbcode_text = (
		"[color={color}][font_size=70]{accuracy}%[/font_size][/color]".format(
			{ "color": accuracy_color, "accuracy": str(abs(snappedf(accuracy, 0.01))) }
		)
	)

	return


func get_worst_guess(target: Color) -> Vector3:
	return Vector3(
		0.0 if target.r > 0.5 else 1.0,
		0.0 if target.g > 0.5 else 1.0,
		0.0 if target.b > 0.5 else 1.0,
	)


func get_accuracy(target: Color, guess: Color) -> float:
	var vec_target = Vector3(target.r, target.g, target.b)
	var vec_guess = Vector3(guess.r, guess.g, guess.b)

	var vec_worst = get_worst_guess(target)

	var max_distance = vec_target.distance_to(vec_worst)
	var current_distance = vec_target.distance_to(vec_guess)

	if max_distance == 0.0:
		return 100.0

	var accuracy = (1.0 - (current_distance / max_distance)) * 100.0
	return clamp(accuracy, 0.0, 100.0)


func _on_submit() -> void:
	var accuracy = get_accuracy(target_color, guess_color)
	update_accuracy_node(accuracy)

	submit_noise.play()

	timer.pause = true
	await get_tree().create_timer(3.0, false, false, true).timeout
	timer.pause = false
	timer.time = 0.0

	if accuracy >= 80.0:
		timer.fail = false


func _on_color_changed(_argument = "lalala") -> void:
	var idx = 0
	for child in sliders.get_children():
		if child is HSlider:
			guess_color[idx] = child.value / 255.0
			idx += 1

	guess_node.color = guess_color

	var accuracy = get_accuracy(target_color, guess_color)
