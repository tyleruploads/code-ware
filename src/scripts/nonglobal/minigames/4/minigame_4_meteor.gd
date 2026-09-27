extends Area2D

signal meteor_hit

var last_position: Vector2

@onready var shape_cast_2d: ShapeCast2D = $ShapeCast2D


func _ready() -> void:
	last_position = global_position


func _process(_delta: float) -> void:
	var move_vector = global_position - last_position

	shape_cast_2d.target_position = shape_cast_2d.to_local(global_position + move_vector)
	shape_cast_2d.force_shapecast_update()

	if shape_cast_2d.is_colliding():
		for i in shape_cast_2d.get_collision_count():
			var body = shape_cast_2d.get_collider(i)
			if body and body.name == "Player":
				shape_cast_2d.enabled = false

				meteor_hit.emit()

				queue_free()
	last_position = global_position
