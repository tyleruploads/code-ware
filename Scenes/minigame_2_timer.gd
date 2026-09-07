extends Label

var time : float = 0.0

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	Timer(10.0)
	pass

# Called every frame
# Delta is elapsed time since previous frame
func _process(delta: float) -> void:
	pass
	
func Timer(start_time: float) -> void:
	time = start_time
	
	var tree := Engine.get_main_loop() as SceneTree
	
	while time > 0.001:
		await get_tree().create_timer(0.10).timeout
		time -= 0.10
		text = str(snapped(time, 0.1))
		
	time = 0.0
	text = "0.0"
	print("Timer finished")
	
	Global.minigames_done -= 1
	Global.lives -= 1
	
	print("Subtracted one minigame and life")
	
	if is_inside_tree() and get_tree():
		get_tree().change_scene_to_file("res://Scenes/level_screen.tscn")
		return
	elif tree:
		tree.change_scene_to_file("res://Scenes/level_screen.tscn")
		return
	else:
		printerr("Could not access SceneTree to change scene!")
		return
