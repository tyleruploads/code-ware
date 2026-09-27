extends CharacterBody2D

@export var speed: float = 300.0

var was_colliding: bool = false

@onready var bump_sound: AudioStreamPlayer2D = $"../Sounds/Bump"


func _physics_process(_delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")

	velocity = input_dir * speed
	move_and_slide()

	# Check if player hit a wall
	if get_slide_collision_count() > 0:
		if not was_colliding:
			bump_sound.play()
			was_colliding = true
	else:
		was_colliding = false
