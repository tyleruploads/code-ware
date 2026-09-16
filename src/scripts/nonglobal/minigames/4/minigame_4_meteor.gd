extends Area2D

@onready var shape_cast_2d: ShapeCast2D = $ShapeCast2D
var last_position: Vector2

func _ready() -> void:
	last_position = global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var move_vector = global_position - last_position
	
	shape_cast_2d.target_position = shape_cast_2d.to_local(global_position + move_vector)
	shape_cast_2d.force_shapecast_update()
	
	if shape_cast_2d.is_colliding():
		for i in shape_cast_2d.get_collision_count():
			var body = shape_cast_2d.get_collider(i)
			if body and body.name == "Player":
				shape_cast_2d.enabled = false
				
				var scene = get_tree().current_scene
				
				scene.health -= 10
				queue_free()
	last_position = global_position
