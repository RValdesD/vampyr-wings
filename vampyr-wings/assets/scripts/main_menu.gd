extends Control

@onready var start_button: Button = $PanelContainer/MarginContainer/VBoxContainer/StartButton
@onready var quit_button: Button = $PanelContainer/MarginContainer/VBoxContainer/QuitButton
@onready var credits_button: Button = $PanelContainer/MarginContainer/VBoxContainer/Credits_button

func _ready() -> void:
	start_button.pressed.connect(_on_start_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	credits_button.pressed.connect(_on_credits_pressed)

func _on_button_pressed() -> void:
	start_button.pressed.connect(_on_start_pressed)
	
func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/Gameplay/Tutorial.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_credits_pressed():
	get_tree().change_scene_to_file("res://scenes/Interface/credits_menu.tscn")
