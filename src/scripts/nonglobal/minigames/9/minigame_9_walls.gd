@tool
extends StaticBody2D

@export var shape_color: Color = Color.WHITE:
	set(value):
		# Allows color to be changed automatically in editor
		shape_color = value
		queue_redraw()


func _ready() -> void:
	queue_redraw()


func _draw() -> void:
	for child in get_children():
		if child is CollisionShape2D and child.shape is RectangleShape2D:
			var rect_shape = child.shape as RectangleShape2D
			var size = rect_shape.size

			var draw_rect_position = child.position - (size / 2.0)
			var final_rect = Rect2(draw_rect_position, size)

			draw_rect(final_rect, shape_color)
