extends Control

@onready var rich_text_label: RichTextLabel = $RichTextLabel

var leaving := false

func _ready() -> void:

	rich_text_label.scroll_active = true
	rich_text_label.scroll_following = false


func _unhandled_input(event: InputEvent) -> void:
	if leaving:
		return
		
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP or event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			return
	
	if event.is_pressed():
		leave_to_menu()


func leave_to_menu() -> void:
	if leaving:
		return
	leaving = true
	
	get_tree().create_timer(0.01666).timeout.connect(_go_menu)


func _go_menu() -> void:
	get_tree().change_scene_to_file("res://scenes/Interface/main_menu.tscn")
