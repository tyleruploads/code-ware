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
		if child is CollisionPolygon2D:
			var polygon_points = child.polygon
			if polygon_points.size() > 0:
				var adjusted_points = PackedVector2Array()
				for point in polygon_points:
					adjusted_points.append(point + child.position)
					
				var colors = PackedColorArray([shape_color])
				
				draw_polygon(adjusted_points, colors)
