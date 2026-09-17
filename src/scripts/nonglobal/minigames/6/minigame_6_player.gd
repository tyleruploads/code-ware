extends CharacterBody2D


func _physics_process(delta: float) -> void:
	# Handle jump.
	if Input.is_action_pressed("move_up"):
		position.y += -30
		
	if Input.is_action_pressed("move_down"):
		position.y += 30
		
	if Input.is_action_pressed("move_left"):
		position.x += -30
		
	if Input.is_action_pressed("move_right"):
		position.x += 30
		
	var size = get_child(0).shape.size

	var viewport_size = get_viewport_rect().size
	
	var min_y = 0.5 * size.y
	var max_y = viewport_size.y - (0.5 * size.y)
	
	var min_x = 0.5 * size.x
	var max_x = viewport_size.x - (0.5 * size.x)

	position.y = clamp(position.y, min_y, max_y)
	position.x = clamp(position.x, min_x, max_x)
