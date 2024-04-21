extends Node2D

@onready var progress_bar = $ColorRect
var bar_initial_position : Vector2
var bar_initial_height: float
var wait_time : float


func _ready():
	bar_initial_position = progress_bar.position
	bar_initial_height = progress_bar.size.y
	wait_time = 0

func _process(delta):
	if wait_time == 0:
		if Global.level_timer != null:
			wait_time = Global.level_timer.get_wait_time()
	else:
		progress_bar.size.y = round(bar_initial_height * (1-Global.level_timer.time_left/wait_time))
		progress_bar.position.y = bar_initial_position.y + (bar_initial_height - progress_bar.size.y)
