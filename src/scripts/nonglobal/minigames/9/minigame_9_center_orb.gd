extends Area2D

@onready var player: CharacterBody2D = $"../Player"
@onready var player_area = $"../Player/Area2D"

signal maze_finished

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(_incoming_area: Node2D) -> void:
	maze_finished.emit()
	queue_free()
