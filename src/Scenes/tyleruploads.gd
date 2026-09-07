extends Node2D
@onready var player: CharacterBody2D = $"../Player"
@onready var self_area = $Area2D
@onready var player_area = $"../Player/Area2D"

signal tyler_collected # Create signal, doesn't send yet

func _process(delta: float) -> void:
	if player_area.overlaps_area(self_area): # Triggers if player on tyler
		# This emits the signal that the tyler has been collected to minigame_1.gd
		emit_signal("tyler_collected")
		queue_free() # Removed, since it got collected
