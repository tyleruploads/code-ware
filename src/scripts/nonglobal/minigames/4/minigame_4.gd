extends Node2D

@export var minigame_name: String = "Dodge the Flying Balls!"
@export var prompt: String = "DODGE!"
@export var description: String = "Don't get hit by the balls! Move left and right with your arrow keys!"

@onready var player: CharacterBody2D = $Player
@onready var exampleMeteor = $Meteor
@onready var timer: Label = $timer
@onready var health_node: RichTextLabel = $health

var health: float = 100.0
var wait_to_spawn: float = 0.5

func _ready() -> void:
	Global.minigames_done = 4

func _process(delta: float) -> void:
	# Handle spawning of meteors
	if wait_to_spawn <= 0:
		make_meteor()
		wait_to_spawn = randf_range(0.6, 1.0)
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


func make_meteor():
	var meteor = exampleMeteor.duplicate()
	
	# Get coordinates for meteor
	var radius = meteor.get_node("CollisionShape2D").shape.radius
	var obstacle_x = randf_range(0, get_viewport_rect().size.x - radius)
	var obstacle_y = -400
	
	meteor.position = Vector2(obstacle_x, obstacle_y)
	
	get_parent().add_child(meteor)
	meteor.show()
	 
	# Make it face the player
	meteor.look_at(player.global_position)
	
	# Make meteor fly to player
	var meteor_tween = meteor.create_tween()
	
	var time_till_hit = randfn(1, 2)
	meteor_tween.tween_property(meteor, "global_position", player.global_position, time_till_hit)
	
	meteor_tween.tween_callback(meteor.queue_free)
