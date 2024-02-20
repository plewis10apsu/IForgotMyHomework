# Contains all of the things that every side scrolling action level must have.
# Menus can be considered "levels" as well, but they won't inherit from this.
extends Node2D

#Bullet parents for easy bullet clearing
var enemy_bullet_parent = Node.new()
var player_bullet_parent = Node.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	############################################################
	## WARNING: DON'T OVERRIDE THIS! Put level-specific ready ##
	## code in your override of _unique_level_ready_stuff()   ##
	############################################################
	add_child(enemy_bullet_parent)
	add_child(player_bullet_parent)
	_unique_level_ready_stuff()

func _unique_level_ready_stuff():
	##This must be overridden by level scenes that inherit from this!
	var accept_dialogue = AcceptDialog.new()
	add_child(accept_dialogue)
	accept_dialogue.title = "Oh noes!"
	accept_dialogue.dialog_text = ("Your level must override _unique_level_ready_stuff().")
	accept_dialogue.dialog_autowrap = true
	accept_dialogue.get_ok_button().text = "Ok."
	accept_dialogue.popup_centered()

func clear_enemy_bullets():
	print("Level has cleared enemy bullets.")
	var bullets = enemy_bullet_parent.get_children()
	for now_bullet in bullets:
		now_bullet.queue_free()
		
func clear_player_bullets():
	print("Level has cleared player bullets.")
	var bullets = player_bullet_parent.get_children()
	for now_bullet in bullets:
		now_bullet.queue_free()
