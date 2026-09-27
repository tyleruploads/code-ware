extends Node2D

var time: float = 0.0 # Updated each delta of _process

@onready var lives_container: HBoxContainer = $LivesContainer
@onready var live_1: TextureRect = $LivesContainer/Life1
@onready var live_2: TextureRect = $LivesContainer/Life2
@onready var live_3: TextureRect = $LivesContainer/Life3
@onready var live_4: TextureRect = $LivesContainer/Life4
@onready var live_5: TextureRect = $LivesContainer/Life5
@onready var level: RichTextLabel = $Level
@onready var timer_node: RichTextLabel = $Timer
@onready var prompt: RichTextLabel = $Prompt
@onready var description: RichTextLabel = $Description


func _ready() -> void:
	# The following if statements also execute the functions
	if await handle_resets():
		return
	if await handle_lives():
		return


func _process(_delta: float) -> void:
	timer_node.text = str(snapped(time, 0.1))


## Handles fake resets after death or full resets if necessary
## Returns a bool representing if the scene was changed and a return statement is necessary
func handle_resets() -> bool:
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

		await timer(10.0)
		get_tree().change_scene_to_file("res://Scenes/minigames/minigame_1.tscn")
		return true

	return false


## The main part of the programs execution
## Returns true if a scene change was invoked
func handle_lives() -> bool:
	if Global.lives <= 0:
		lives_container.hide()

		level.text = "N/A"
		prompt.text = "???"
		description.text = "Ready? Set?"

		await timer(5.0)
		get_tree().change_scene_to_file("res://Scenes/end/death_scene.tscn")
		return true

	lives_container.show()
	var children = lives_container.get_children()
	for i in range(children.size()):
		children[i].visible = i < Global.lives

	if Global.minigames_done < Global.minigames_until_end:
		var new_scene_path := "res://Scenes/minigames/minigame_{x}.tscn".format(
			{ "x": Global.minigames_done + 1 }
		)
		var new_scene_instance = load(new_scene_path).instantiate()

		level.text = "Level {level}: {name}".format(
			{ "level": str(Global.minigames_done + 1), "name": new_scene_instance.minigame_name }
		)
		prompt.text = new_scene_instance.prompt
		description.text = new_scene_instance.description

		new_scene_instance.queue_free()

		await timer(5.0)
		Global.minigames_done += 1

		get_tree().change_scene_to_file(new_scene_path)
		return true

	level.text = ""
	prompt.text = "GAME COMPLETE"
	description.text = "The end is infinite :D!"

	# Reset game
	Global.minigames_done = 0

	await timer(3.0)
	get_tree().change_scene_to_file("res://Scenes/end/finish_screen.tscn")
	return true


func timer(start_time: float):
	# Once it reaches zero, it will go to next scene
	time = start_time

	while time > 0.001:
		await get_tree().create_timer(0.1).timeout
		time -= 0.1
	time = 0.0
	timer_node.text = "0.0"

	return
