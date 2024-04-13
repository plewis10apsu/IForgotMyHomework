extends Control

func _ready():
	$AnimationPlayer.play("RESET")

func _process(_delta):
	pause_game()

func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")

func pause():
	get_tree().paused = true
	$AnimationPlayer.play("blur")

func pause_game():
	if Input.is_action_just_pressed("escape") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("escape") and get_tree().paused:
		resume()

func _on_resume_button_pressed():
	$PanelContainer/Panel/MarginContainer/VBoxContainer/VBoxContainer/VBoxContainer2/ResumeButton.release_focus()
	resume()

func _on_restart_button_pressed():
	$PanelContainer/Panel/MarginContainer/VBoxContainer/VBoxContainer/VBoxContainer2/RestartButton.release_focus()
	resume()
	get_tree().reload_current_scene()

func _on_main_menu_button_pressed():
	$PanelContainer/Panel/MarginContainer/VBoxContainer/VBoxContainer/VBoxContainer2/MainMenuButton.release_focus()
	resume()
	Global.change_level("res://menus/Main_Menu/main_menu.tscn")

func _on_quit_button_pressed():
	get_tree().quit()
