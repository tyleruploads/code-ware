extends Node2D

@export var minigame_name: String = "Unintelligent Arrows"
@export var prompt: String = "DODGE!"
@export var description: String = "Don't get hit by the unintelligent (and fast) arrows! They can only go in one direction. Don't stay still."

@onready var player: CharacterBody2D = $Player
@onready var exampleArrow = $Arrow
@onready var timer: Label = $timer
@onready var health_node: RichTextLabel = $health

var health: float = 100.0
var wait_to_spawn: float = 0.25

func _ready() -> void:
	Global.minigames_done = 6

func _process(delta: float) -> void:
	# Handle spawning of arrows
	if wait_to_spawn <= 0:
		make_arrow()
		wait_to_spawn = randf_range(0.3, 0.35)
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


func make_arrow():
	var arrow = exampleArrow.duplicate()
	
	arrow.name = "Duplicate Arrow"
	
	var window_size = get_viewport_rect().size
	
	# Get coordinates for arrow
	var length = arrow.get_node("CollisionShape2D").shape.size.x
	var height = arrow.get_node("CollisionShape2D").shape.size.y
	
	var player_pos = player.get_child(0).global_position
	
	var min_distance = 1000
	
	var obstacle_x = randf_range(
		player_pos.x - min_distance,
		get_viewport_rect().size.x - player_pos.x + min_distance
	)
	var obstacle_y = randf_range(
		0, window_size.y - height
	)
	
	arrow.position = Vector2(obstacle_x, obstacle_y)
	
	get_parent().add_child(arrow)
	arrow.show()
	 
	# Make it face the player
	arrow.look_at(player.global_position)
	
	# Make arrow fly to player
	var arrow_tween = arrow.create_tween()
	
	var time_till_hit = randfn(1.0, 1.5)
	arrow_tween.tween_property(arrow, "global_position", player.global_position, time_till_hit)
	
	arrow_tween.tween_callback(arrow.queue_free)
