extends Node2D

@export var minigame_name: String = "Unintelligent Arrows"
@export var prompt: String = "DODGE!"
@export var description: String = "Don't get hit by the unintelligent (and fast) arrows! Don't stay near the edges!"

@onready var player: CharacterBody2D = $Player
@onready var exampleArrow = $Arrow
@onready var timer: Label = $timer
@onready var health_node: RichTextLabel = $health
@onready var shoot_noise: AudioStreamPlayer2D = $"Sounds/shoot"
@onready var hit_noise: AudioStreamPlayer2D = $"Sounds/hit"

var health: float = 100.0
var wait_to_spawn: float = 0.25

func _ready() -> void:
	Global.minigames_done = 6

func _process(delta: float) -> void:
	# Handle spawning of arrows
	if wait_to_spawn <= 0:
		make_arrow()
		wait_to_spawn = randf_range(1.0, 1.5)
	else:
		wait_to_spawn -= delta
		
	# Handle health
	health_node.text = str(health) + "%"
	
	if health <= 0:
		Global.minigames_done -= 1
		Global.lives -= 1
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

func generate_arrow_vals(arrow):
	var reaction_time: float = 0.45 # Seconds
	var arrow_speed: float = 600.0
	
	var min_distance: float = arrow_speed * reaction_time
	
	var screen_width: float = get_viewport_rect().size.x
	var max_distance: float = max(min_distance + 100.0, screen_width * 0.4)
	
	var window_size = get_viewport_rect().size
	
	# Get coordinates for arrow
	var length = arrow.get_node("CollisionShape2D").shape.size.x
	var height = arrow.get_node("CollisionShape2D").shape.size.y
	
	var player_pos = player.get_child(0).global_position

	# Determine the offset direction for arrow position, 50/50 +/-
	var x_sign := 1.0 if randf() > 0.5 else -1.0
	var y_sign := 1.0 if randf() > 0.5 else -1.0
	
	var random_angle: float = randf_range(0, 6.28318530718) # Two PI
	var target_distance: float = randf_range(min_distance, max_distance)
	var offset := Vector2.RIGHT.rotated(random_angle) * target_distance
	
	var margin: float = 32.0
	var arrow_x: float = clamp(player_pos.x + offset.x, margin, window_size.x - margin)
	var arrow_y: float = clamp(player_pos.y + offset.y, margin, window_size.y - margin)
	
	var arrow_pos: Vector2 = Vector2(arrow_x, arrow_y)
	var actual_distance: float = arrow_pos.distance_to(player_pos)
	
	var time_till_hit: float = actual_distance / arrow_speed
	if actual_distance < min_distance:
		time_till_hit = reaction_time
	
	return {
		"arrow_pos": arrow_pos,
		"time_till_hit": time_till_hit
	}
	

func make_arrow():
	var arrow = exampleArrow.duplicate()
	
	arrow.name = "Duplicate Arrow"
	
	var vals = generate_arrow_vals(arrow)
	var arrow_pos = vals["arrow_pos"]
	var time_till_hit = vals["time_till_hit"]

	arrow.global_position = arrow_pos
	 
	var target_dest: Vector2 = player.global_position
	var dir: Vector2 = (target_dest - arrow_pos).normalized()
	
	var far_dest: Vector2 = arrow_pos + dir * 1500
	var flight_time: float = 1500.0 / 600
	
	var arrow_tween = arrow.create_tween()
	
	arrow_tween.tween_interval(0.2) # This makes it wait for 0.2s first
	shoot_noise.play()
	arrow_tween.tween_property(arrow, "global_position", far_dest, flight_time)
	
	arrow_tween.tween_callback(arrow.queue_free)
	
	arrow.arrow_hit.connect(_on_arrow_hit)

	get_parent().add_child(arrow)
	arrow.look_at(target_dest)
	arrow.show()

func _on_arrow_hit() -> void:
	health -= 2.5
	hit_noise.play()
