class_name LifeUI
extends CanvasLayer

var max_life := 6
var current_life := 6

@export var tex_full: Texture2D
@export var tex_half: Texture2D
@export var tex_empty: Texture2D

@onready var hearts := [
	$MarginContainer/HBoxContainer/Heart1,
	$MarginContainer/HBoxContainer/Heart2,
	$MarginContainer/HBoxContainer/Heart3
]

func _ready() -> void:
	add_to_group("life_ui")
	update_hearts()

func damage(amount: int):
	current_life = clamp(current_life - amount, 0, max_life)
	update_hearts()

func update_hearts():
	var life = current_life

	for i in range(3):
		if life >= 2:
			hearts[i].texture = tex_full
		elif life == 1:
			hearts[i].texture = tex_half
		else:
			hearts[i].texture = tex_empty

		life -= 2
