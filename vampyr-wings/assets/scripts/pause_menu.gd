extends CanvasLayer


@onready var continue_button: Button = $PanelContainer/MarginContainer/VBoxContainer/Continue_button
@onready var main_menu_button: Button = $PanelContainer/MarginContainer/VBoxContainer/MainMenuButton
@onready var quit_button: Button = $PanelContainer/MarginContainer/VBoxContainer/QuitButton
@onready var retry_button: Button = $PanelContainer/MarginContainer/VBoxContainer/Retry_button

func _ready() -> void:
	main_menu_button.pressed.connect(_on_main_menu_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	retry_button.pressed.connect(_on_retry_pressed)
	continue_button.pressed.connect(_on_continue_pressed)
	visible = false
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_tree().paused = not get_tree().paused
		visible = get_tree().paused
		
func _on_continue_pressed():
	get_tree().paused = not get_tree().paused
	visible = get_tree().paused
	
func _on_retry_pressed():
	get_tree().paused = false
	LevelManager.go_to_scene(LevelManager.levels[LevelManager.curr].resource_path) 
	
func _on_main_menu_pressed() -> void:
		visible = false
		get_tree().paused = false
		get_tree().change_scene_to_file("res://scenes/Interface/main_menu.tscn")
		
func _on_quit_pressed() -> void:
	get_tree().quit()
