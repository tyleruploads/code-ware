extends Node2D
@onready var lives_container: HBoxContainer = $LivesContainer
@onready var live_1: TextureRect = $LivesContainer/Life1
@onready var live_2: TextureRect = $LivesContainer/Life2
@onready var live_3: TextureRect = $LivesContainer/Life3
@onready var live_4: TextureRect = $LivesContainer/Life4
@onready var live_5: TextureRect = $LivesContainer/Life5
@onready var level: RichTextLabel = $Level
@onready var timer: RichTextLabel = $Timer
@onready var prompt: RichTextLabel = $Prompt
@onready var description: RichTextLabel = $Description

var time: float = 0.0 # Updated each delta of _process

func _ready() -> void:
	# Handle resets
	
	if Global.full_reset == true:
		Global.reset = false
		Global.full_reset = false
		
		Global.minigames_done = 1
		Global.lives = 5
	
	if Global.reset_after_death == true:
		# First, change it back to false so this doesn't happen each time after first reset
		Global.reset_after_death = false
		
		level.text = "Level ???"
		prompt.text = "REPEAT!"
		description.text = "The end is never. Continue, until you meet the real, end."

		Global.minigames_done = 1
		Global.lives = 5
		
		await Timer(10.0)
		get_tree().change_scene_to_file("res://Scenes/minigame_1.tscn")
		return
	
	# Handle lives
	if Global.lives <= 0:
		lives_container.hide()

		level.text = "N/A"
		prompt.text = "???"
		description.text = "Ready? Set?"
		
		await Timer(5.0)
		get_tree().change_scene_to_file("res://Scenes/death_scene.tscn")
		return
	else:
		lives_container.show()
		var children = lives_container.get_children()
		for i in range(children.size()):
			children[i].visible = i < Global.lives
	
	if Global.minigames_done < Global.minigames_until_end:
		var new_scene_path := "res://Scenes/minigame_{x}.tscn".format({'x': Global.minigames_done + 1})
		var new_scene_instance = load(new_scene_path).instantiate()
		
		level.text = "Level " + str(Global.minigames_done + 1)
		prompt.text = new_scene_instance.prompt
		description.text = new_scene_instance.description
		
		new_scene_instance.queue_free()

		print(Global.minigames_done, " minigames done")
		await Timer(5.0)
		Global.minigames_done += 1
		get_tree().change_scene_to_file(new_scene_path)
	else:
		level.text = ""
		prompt.text = "GAME COMPLETE"
		description.text = "The end is infinite :D!"
		print("Game complete!")
		
		# Reset game
		Global.minigames_done = 0
		
		await Timer(3.0)
		get_tree().change_scene_to_file("res://Scenes/finish_screen.tscn")

func _process(delta: float) -> void: # runs every frame
	timer.text = str(snapped(time, 0.1))

func Timer(start_time: float):
	# Once it reaches zero, it will go to next scene
	
	time = start_time
	
	while time > 0.001:
		await get_tree().create_timer(0.1).timeout
		time -= 0.1
	time = 0.0
	timer.text = "0.0"
		
	return
