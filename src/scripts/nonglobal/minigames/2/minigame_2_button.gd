extends TextureButton

@onready var parent = $".."
@onready var click_sound: AudioStreamPlayer2D = $"../../Sounds/Click"


func _ready():
	pressed.connect(_on_pressed)

	# Lets move the button to a random place!
	var screen_size = get_viewport_rect().size
	var button_size = size

	# Get random coordinates
	var random_x = randf_range(0, screen_size.x - button_size.x)
	var random_y = randf_range(0, screen_size.y - button_size.y)

	position = Vector2(random_x, random_y)


func _on_pressed() -> void:
	var tree = get_tree().current_scene

	hide()
	tree.buttons_pressed += 1
	click_sound.play()
