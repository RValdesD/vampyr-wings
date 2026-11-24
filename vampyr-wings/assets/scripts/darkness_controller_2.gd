extends Node2D

@export var darkness_strength := 1.0  
@onready var canvas_modulate: CanvasModulate = $CanvasModulate

func _ready():
	canvas_modulate.color = Color(0, 0, 0, darkness_strength)
