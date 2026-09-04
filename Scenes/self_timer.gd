extends Label

var time : float = 0.0

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	Timer(13.0)
	pass

# Called every frame
# Delta is elapsed time since previous frame
func _process(delta: float) -> void:
	Timer(11.0)
	
func Timer(start_time: float) -> void:
	time = start_time
	
	var tree := Engine.get_main_loop() as SceneTree
	
	while time > 0.001:
		await get_tree().create_timer(0.10).timeout
		time -= 0.10
		text = str(time)
		
	time = 0.0
	text = "0.0"
	print("Timer finished")
	
	Global.minigames_done -= 1
	Global.lives -= 1
	
	if is_inside_tree() and get_tree():
		get_tree().change_scene_to_file("res://Scenes/level_screen.tscn")
	elif tree:
		tree.change_scene_to_file("res://Scenes/level_screen.tscn")
	else:
		printerr("Could not access SceneTree to change scene!")
