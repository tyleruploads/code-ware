extends Node2D
@onready var assets_list = $"HBoxContainer/Assets List"
@onready var asset_rect = $"HBoxContainer/Asset View/TextureRect"
@onready var asset_text = $"HBoxContainer/Asset View/RichTextLabel"

var assets: Array[Dictionary] = [
	{"n": "Title Screen Image", "p": "res://assets/other/title-screen-bg.svg"},
	{"n": "Game Icon Image", "p": "res://assets/icon/icon.png"},
	{"n": "Mountain Bridge Image", "p": "res://assets/minigame-bgs/mountain-bridge.svg"},
	{"n": "Eyes in Rectangles", "p": "res://assets/minigame-bgs/eyes-in-rectangles.svg"},
]

func _ready() -> void:
	await get_tree().process_frame
	
	
	for asset in assets:
		make_button(asset)
		
	var first_btn = assets_list.get_child(0)
	first_btn.pressed.emit()
	
func make_button(asset: Dictionary):
	var button = Button.new()
	
	button.text = asset["n"]
	
	button.pressed.connect(func():
		asset_rect.texture = load(asset["p"])
		asset_text.text = "{n}: {p}".format({
			"n": asset["n"], "p": asset["p"]
		})
	)
	
	button.custom_minimum_size = Vector2(200, 50)
	
	assets_list.add_child(button)

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/extras/extras.tscn")
