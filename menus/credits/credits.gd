extends Node2D

var credits_text : Label


# Called when the node enters the scene tree for the first time.
func _ready():
	credits_text = $credits_text
	credits_text.position.y += 1080 + 100

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	credits_text.position.y -= 100 * delta
	if Input.is_action_just_pressed("escape"):
		Global.change_level("res://menus/Main_Menu/main_menu.tscn")
	

func _on_visible_on_screen_notifier_2d_screen_exited():
	Global.change_level("res://menus/Main_Menu/main_menu.tscn")

