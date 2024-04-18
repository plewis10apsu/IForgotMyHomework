class_name MainMenu
extends Control

func _ready():
	Global.current_level = self
	$MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/LevelButton1.grab_focus()

func _on_play_button_pressed():
	Global.change_level("res://level_0/tilemap_level_test.tscn")

func _on_exit_button_pressed():
	get_tree().quit()

func _on_options_button_pressed():
	Global.change_level("res://menus/Options_Menu/options_menu.tscn")

func _on_help_button_pressed():
	$HelpPanel.popup_centered()

func _on_credits_button_pressed():
	$CreditsPanel.popup_centered()
