extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().current_scene.fail.connect(_on_fail)
	
func _on_fail() -> void:
	show()
	await get_tree().create_timer(0.5, false).timeout
	hide()
