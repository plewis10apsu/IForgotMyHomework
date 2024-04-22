class_name MainMenu
extends Control

var transitions_node : Transitions

func _ready():
	Global.current_level = self
	$MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/LevelButton1.grab_focus()
	transitions_node = $TransitionsLayer/Transitions
	$TransitionsLayer/Transitions.scene_to_load = null
	$TransitionsLayer/Transitions.set_next_animation(false)
	

func _on_exit_button_pressed():
	get_tree().quit()

func _on_options_button_pressed():
	$OptionsPanel/OptionsMenu/Panel/MarginContainer/VBoxContainer/HBoxContainer2/CloseButton.grab_focus()
	$OptionsPanel.popup_centered()
	
func _on_help_button_pressed():
	$HelpPanel/HelpMenu/Panel/MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer/CloseButton.grab_focus()
	$HelpPanel.popup_centered()

func _on_credits_button_pressed():
	$CreditsPanel/CreditsMenu/Panel/MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer/CloseButton.grab_focus()
	$CreditsPanel.popup_centered()

func _on_level_button_1_pressed():
	$TransitionsLayer/Transitions.set_next_animation(true)
	$TransitionsLayer/Transitions.scene_to_load = preload("res://level_0/tilemap_level_test.tscn")
	

func _on_level_button_2_pressed():
	$TransitionsLayer/Transitions.set_next_animation(true)
	$TransitionsLayer/Transitions.scene_to_load = preload("res://level_2/SpaceShooterLevel/scenes/game.tscn")

func _on_level_button_3_pressed():
	$TransitionsLayer/Transitions.set_next_animation(true)
	$TransitionsLayer/Transitions.scene_to_load = preload("res://level_3/moon_level.tscn")

func _on_close_button_pressed():
	$HelpPanel.visible = false
	$CreditsPanel.visible = false
	$OptionsPanel.visible = false

