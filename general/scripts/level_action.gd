# Contains all of the things that every side scrolling action level must have.
# Menus can be considered "levels" as well, but they won't inherit from this.
extends Node2D

#Bullet parents for easy bullet clearing
var enemy_bullet_parent = Node.new()
var player_bullet_parent = Node.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	################################################################
	## WARNING: Scripts that extend this must call super._ready() ##
	################################################################
	add_child(enemy_bullet_parent)
	add_child(player_bullet_parent)

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
