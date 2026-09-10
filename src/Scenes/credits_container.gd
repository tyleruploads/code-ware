extends VBoxContainer

@export var scroll_speed: float = 150.0 # PPS (Pixels Per Second)
@export var start_delay: float = 3

# Get the node with the script containing credits text attached to it
@export var data_node: CreditsText

var duplicate_box: VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Enable BBCode and set text
	$RichTextLabel.bbcode_enabled = true
	$RichTextLabel.text = data_node.credits_text
	
	# Wait one frame for layout to finish calculation
	await get_tree().process_frame
	
	# Create copy of container to follow right under
	duplicate_box = self.duplicate()
	# Strip script from duplicate (no infinite stacking!)
	duplicate_box.set_script(null)
	get_parent().add_child.call_deferred(duplicate_box)
	
	# Put duplicate box right under original
	duplicate_box.position.y = size.y
	
	start_loop()

func start_loop() -> void:
	var total_height: float = size.y
	var duration: float = total_height / scroll_speed
	
	# Reset positions
	position.y = 0
	duplicate_box.position.y = total_height
	
	# Animate both containers
	var tween: Tween = create_tween()
	tween.tween_property(self, "position:y", -total_height, duration)
	tween.parallel().tween_property(duplicate_box, "position:y", 0.0, duration)
	
	# Restart this function!
	tween.tween_callback(start_loop)
