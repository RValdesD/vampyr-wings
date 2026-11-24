extends CanvasLayer

@onready var main_menu_button: Button = $PanelContainer/VBoxContainer/VBoxContainer/Menu_Button
@onready var quit_button: Button = $PanelContainer/VBoxContainer/VBoxContainer/Quit_Button

func _ready():
	# Ocultamos el menú al inicio
	visible = true
	
	main_menu_button.pressed.connect(_on_main_menu_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
# Funcion para mostrar el menu cuando el jugador gana, hay que
# conectarla en el codigo del nivel ?
func show_menu():
	visible = true
	get_tree().paused = true  # Pausa el juego


func _on_main_menu_pressed() -> void:
		visible = false
		get_tree().paused = false
		get_tree().change_scene_to_file("res://scenes/Interface/main_menu.tscn")
		
func _on_quit_pressed() -> void:
	get_tree().quit()

	
