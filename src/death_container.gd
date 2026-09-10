extends Control

@export var scroll_speed: float = 150.0 # PPS (Pixels Per Second)
@export var start_delay: float = 5.0

@onready var label = $VBoxContainer/RichTextLabel
@onready var ContinueButton = $"../ContinueButton"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	
	var label: RichTextLabel = get_node_or_null("VBoxContainer/RichTextLabel") as RichTextLabel
	
	if label == null:
		printerr("CRITICAL: Could not find RichTextLabel at $VBoxContainer/RichTextLabel")
		return
	
	label.custom_minimum_size.y = 6164.0
	
	await get_tree().process_frame
	await get_tree().process_frame

	start_loop()

func start_loop() -> void:
	var total_height: float = 6164.0
	var duration: float = total_height / scroll_speed
	
	# Reset position
	$VBoxContainer.position.y = 0
	
	await get_tree().process_frame
	await get_tree().process_frame
	
	# Wait!
	await get_tree().create_timer(2.0).timeout
	
	# Animate both containers
	var tween: Tween = create_tween()
	tween.tween_property($VBoxContainer, "position:y", -total_height, duration)
	
	tween.finished.connect(_offer_restart)

func _offer_restart():
	$"../Node2D".show()
	await get_tree().create_timer(3).timeout
	ContinueButton.show()
