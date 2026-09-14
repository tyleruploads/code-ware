extends Node2D

@export var minigame_name: String = "Hit the Circles"
@export var prompt: String = "CLICK!"
@export var description: String = "Zero your balance of circles in 17 seconds by clicking on any circle whenever you see it pop up!"

@onready var exampleCircle = $Circle
@onready var timer: Label = $timer
@onready var score_node: RichTextLabel = $score

var balance: int = -15
var wait_to_spawn: float = 0.5

func _process(delta: float) -> void:
	if balance == 0:
		if Global.minigames_done > Global.minigames_until_end:
			get_tree().change_scene_to_file("res://scenes/done_screen.tscn")
		else:
			get_tree().change_scene_to_file("res://Scenes/level_screen.tscn")
			
	# Handle timing
	if wait_to_spawn <= 0:
		make_circle()
		wait_to_spawn = randf_range(0.4, 0.8)
	else:
		wait_to_spawn -= delta

func make_circle():
	var circle = exampleCircle.duplicate()
	
	circle.pressed.connect(_on_circle_pressed.bind(circle))
	
	# Lets move the button to a random place!
	var screen_size = get_viewport_rect().size
	var button_size = circle.size
	
	# Get random coordinates
	var random_x = randf_range(0, screen_size.x - button_size.x)
	var random_y = randf_range(0, screen_size.y - button_size.y)
	
	circle.position = Vector2(random_x, random_y)
	
	get_parent().add_child(circle)
	circle.show()
	
	# Make circle dissapear when its time
	get_tree().create_timer(randf_range(1, 1.4)).timeout.connect(circle.queue_free)

func _on_circle_pressed(circle):
	balance += 1
	score_node.text = str(balance)
	circle.queue_free()
