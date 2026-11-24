extends CanvasLayer
@onready var retry_button: Button = $VBoxContainer/VBoxContainer/Retry_Button
@onready var menu_button: Button = $VBoxContainer/VBoxContainer/Menu_Button
@onready var quit_button: Button = $VBoxContainer/VBoxContainer/Quit_Button

func _ready():
	retry_button.pressed.connect(_on_retry_pressed)
	menu_button.pressed.connect(_on_menu_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func show_menu():
	visible = true
	get_tree().paused = true  # Pausa el juego

func _on_retry_pressed():
	get_tree().paused = false
	LevelManager.go_to_scene(LevelManager.levels[LevelManager.curr].resource_path) 

func _on_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/Interface/main_menu.tscn")
	
func _on_quit_pressed():
	get_tree().paused = false
	get_tree().quit()

	
