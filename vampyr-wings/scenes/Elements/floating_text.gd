extends Node2D

@export var float_distance := 0      # How many pixels upward
@export var float_speed := 0           # Pixels per second
@export var fade_time := 0.5            # Fade duration

@onready var lbl: Label = $Label

var target_y := 0

func _ready():
	target_y = global_position.y - float_distance
	fade_out()

func set_text(value: String) -> void:
	lbl.text = value


func _process(delta: float) -> void:
	# Move upward
	if global_position.y > target_y:
		global_position.y -= float_speed * delta


func fade_out() -> void:
	var tween = create_tween()
	tween.tween_property(lbl, "modulate:a", 0.0, fade_time)
	tween.tween_callback(Callable(self, "queue_free"))
