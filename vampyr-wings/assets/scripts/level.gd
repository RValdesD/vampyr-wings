extends Node2D

@onready var canvas_modulate: CanvasModulate = $CanvasModulate
@onready var dialogue_label: RichTextLabel = $CanvasLayer/DialogueLabel

@export var dim_duration: float = 5.0
@export var toggle_duration: float = 1.5

var is_dimming := false
var dim_progress := 0.0
var is_dimmed := false  # lighting state tracker

var dialogue_lines := [
	"Careful, creatures lurk here...",
	"Press L to use your echolocation and reveal them",
]
var current_line := 0
var showing_dialogue := false


func _ready():
	dialogue_label.visible = false
	await get_tree().create_timer(0.5).timeout
	start_dimming()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("lightreset"):
		toggle_lighting()

	if is_dimming:
		dim_progress += delta / dim_duration
		dim_progress = clamp(dim_progress, 0.0, 1.0)
		canvas_modulate.color = Color(1, 1, 1).lerp(Color(0, 0, 0), dim_progress)
		
		if dim_progress >= 1.0:
			is_dimming = false
			is_dimmed = true
			show_first_dialogue()  # when the world is fully dimmed

	if showing_dialogue and (Input.is_action_just_pressed("ui_accept")):
		show_next_dialogue()


func start_dimming():
	is_dimming = true
	dim_progress = 0.0
	is_dimmed = false


func toggle_lighting():
	var tween = create_tween()
	
	if is_dimmed:
		tween.tween_property(canvas_modulate, "color", Color.WHITE, toggle_duration)
		is_dimmed = false
	else:
		tween.tween_property(canvas_modulate, "color", Color.BLACK, toggle_duration)
		is_dimmed = true
	
	is_dimming = false
	dim_progress = 0.0


func show_first_dialogue():
	dialogue_label.visible = true
	dialogue_label.bbcode_text = dialogue_lines[current_line]
	showing_dialogue = true


func show_next_dialogue():
	current_line += 1
	if current_line < dialogue_lines.size():
		dialogue_label.bbcode_text = dialogue_lines[current_line]
	else:
		# No more lines → hide text
		dialogue_label.visible = false
		showing_dialogue = false
