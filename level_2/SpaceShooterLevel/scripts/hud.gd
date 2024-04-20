extends Control

@onready var score = $Score:
	set(value):
		score.text = "Score: " + Global.get_current_score_as_string()

func _process(_delta):
	score.text = "Score: " + Global.get_current_score_as_string()
