extends Node2D
@onready var timer : Label = %timer

var time : float

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	Timer(5.0)
	pass

# Called every frame
# Delta is elapsed time since previous frame
func _process(delta: float) -> void:
	if is_instance_valid(timer):
		timer.text = str(snapped(time, 0.10)) # Rounds to the tenths place
	else:
		print("timer is not an instance")
	
func Timer(start_time: float) -> void:
	time = start_time
	while time > 0.001:
		await get_tree().create_timer(0.10).timeout
		time -= 0.10
