extends Control

const DIGIT_TEXTURES := {
	0: preload("res://scenes/Interface/ScoreUI/score-0.png"),
	1: preload("res://scenes/Interface/ScoreUI/score-1.png"),
	2: preload("res://scenes/Interface/ScoreUI/score-2.png"),
	3: preload("res://scenes/Interface/ScoreUI/score-3.png"),
	4: preload("res://scenes/Interface/ScoreUI/score-4.png"),
	5: preload("res://scenes/Interface/ScoreUI/score-5.png"),
	6: preload("res://scenes/Interface/ScoreUI/score-6.png"),
	7: preload("res://scenes/Interface/ScoreUI/score-7.png"),
	8: preload("res://scenes/Interface/ScoreUI/score-8.png"),
	9: preload("res://scenes/Interface/ScoreUI/score-9.png"),
}

@onready var digit_nodes := $HBoxContainer.get_children()

func _ready():
	ScoreManager.score_changed.connect(_on_score_changed)
	_on_score_changed(ScoreManager.score)

func _on_score_changed(new_score):
	var width := digit_nodes.size()
	var score_str := "%0*d" % [width, new_score]

	for i in range(width):
		var digit = score_str[i].to_int()
		digit_nodes[i].texture = DIGIT_TEXTURES[digit]
