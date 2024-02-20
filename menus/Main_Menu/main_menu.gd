extends Control

func _ready():
	Global.current_level = self

func _on_start_button_pressed():
	Global.change_level("res://level_0/scenes/level_0.tscn")


func _on_options_button_pressed():
	Global.change_level("res://menus/Options_Menu/options_menu.tscn")


func _on_quit_button_pressed():
	get_tree().quit()
