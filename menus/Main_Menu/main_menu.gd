extends Control

func _ready():
	Global.current_level = self

func _on_play_button_pressed():
	Global.change_level("res://level_0/tilemap_level_test.tscn")


func _on_exit_buttion_pressed():
	get_tree().quit()


func _on_options_button_pressed():
	Global.change_level("res://menus/Options_Menu/options_menu.tscn")

