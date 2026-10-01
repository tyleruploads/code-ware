extends Node2D

const TARGET_SCORE = 35

@export var minigame_name: String = "Catch the Falling Orbs!"
@export var prompt: String = "CATCH!"
@export var description: String = "Catch 35 falling orbs in 45s! " \
		+ "Move left and right with your keyboard to capture!"

var score: int = 0
var wait_to_spawn: float = 0.5

@onready var player: CharacterBody2D = $Player
@onready var example_orb = $Orb
@onready var timer: Label = $Timer
@onready var score_node: RichTextLabel = $Score
@onready var throw_noise: AudioStreamPlayer2D = $"Sounds/Throw"
@onready var hit_noise: AudioStreamPlayer2D = $"Sounds/Hit"


func _process(delta: float) -> void:
	# Handle spawning of meteors
	if wait_to_spawn <= 0:
		make_meteor()
		wait_to_spawn = randf_range(0.6, 1.0)
	else:
		wait_to_spawn -= delta


func make_meteor():
	var orb = example_orb.duplicate()

	# Get coordinates for orb
	var radius = orb.get_node("CollisionShape2D").shape.radius
	var target_x = randf_range(0, get_viewport_rect().size.x - radius)
	var target_y = 1000

	var target_pos = Vector2(target_x, target_y)

	orb.position.x = target_x

	get_parent().add_child(orb)
	orb.show()

	var orb_tween = orb.create_tween()

	var time_till_hit = 1
	orb_tween.tween_property(orb, "global_position", target_pos, time_till_hit)

	orb_tween.tween_callback(orb.queue_free)

	orb.orb_collect.connect(_on_orb_collect)

	throw_noise.play()


func _on_orb_collect() -> void:
	score += 1
	hit_noise.play()

	score_node.text = "{score}/{TARGET_SCORE}".format(
		{ "score": score, "TARGET_SCORE": TARGET_SCORE }
	)

	# End game if at target score
	if score == TARGET_SCORE:
		var tree := Engine.get_main_loop() as SceneTree

		if is_inside_tree() and get_tree():
			get_tree().change_scene_to_file("res://Scenes/other/level_screen.tscn")
		elif tree:
			tree.change_scene_to_file("res://Scenes/other/level_screen.tscn")
		else:
			printerr("Could not access SceneTree to change scene!")
