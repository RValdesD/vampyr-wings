extends Area2D

@export var score_amount := 300
var floating_scene := preload("res://scenes/Elements/FloatingText.tscn")

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):
		ScoreManager.add_score(300)

		var ft = preload("res://scenes/Elements/FloatingText.tscn").instantiate()
		get_tree().current_scene.add_child(ft) # Or get_parent()

		ft.global_position = global_position + Vector2(-20, -20)
		ft.set_text("+300")  # This calls your label

		var label = ft.get_node("Label")
		var custom_font = preload("res://assets/Typesetting/antiquity-print.ttf") as Font
		label.add_theme_font_override("font", custom_font)
		var timer = Timer.new()
		
		timer.wait_time = 1.0
		timer.one_shot = true
		timer.connect("timeout", Callable(ft, "queue_free"))
		ft.add_child(timer)
		timer.start()
		queue_free()
		
