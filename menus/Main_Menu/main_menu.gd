extends Control

func _ready():
	Global.current_level = self

func _on_start_button_pressed():
	Global.change_level("res://level_0/tilemap_level_test.tscn")

func _on_exit_button_pressed():
	get_tree().quit()

func _on_help_button_pressed():
	Global.change_level("res://menus/Options_Menu/options_menu.tscn")
