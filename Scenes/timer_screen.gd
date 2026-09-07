extends Node2D
@onready var lives_container: HBoxContainer = $LivesContainer
@onready var live_1: TextureRect = $LivesContainer/Life1
@onready var live_2: TextureRect = $LivesContainer/Life2
@onready var live_3: TextureRect = $LivesContainer/Life3
@onready var live_4: TextureRect = $LivesContainer/Life4
@onready var live_5: TextureRect = $LivesContainer/Life5
@onready var level: RichTextLabel = $Level
@onready var timer: RichTextLabel = $Timer

var time: float = 0.0 # Updated each delta of _process

func _ready() -> void:
	if Global.minigames_done < Global.minigames_until_end:
		level.text = "Level " + str(Global.minigames_done + 1)
		print(Global.minigames_done, " minigames done")
		await Timer(5.0)
		Global.minigames_done += 1
		get_tree().change_scene_to_file("res://Scenes/minigame_" + str(Global.minigames_done) + ".tscn")
	else:
		level.text = "Game complete! Heading home."
		print("Game complete! Heading home.")
		
		# Reset game
		Global.minigames_done = 0
		
		await Timer(5.0)
		get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")

func _process(delta: float) -> void: # runs every frame
	if Global.lives <= 0:
		lives_container.hide()
	else:
		lives_container.show()
		var children = lives_container.get_children()
		for i in range(children.size()):
			children[i].visible = i < Global.lives

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
