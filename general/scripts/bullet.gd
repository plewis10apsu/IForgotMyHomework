## Parent of all sorts of bullets that can be shot during gameplay.
extends Node2D

var team
var aim_vector
var weapon_type
var time_alive #in seconds

func _init(shooter_IN, aim_vector_IN):
	team = shooter_IN.team
	weapon_type = shooter_IN.weapon_type
	aim_vector = aim_vector_IN
	# Move to a bullet parent in the level
	if(team == TEAM.PLAYER):
		reparent(Global.current_level.player_bullet_parent)
	elif(team == TEAM.ENEMY):
		reparent(Global.current_level.enemy_bullet_parent)

func _on_impact():
	## Called by whatever this bullet hit.
	## Usually we just queue_free() here.
	## Persistent bullets like flames don't, though.
	push_error("ERROR: You must override _on_impact in all children of bullet.tscn!")
	push_error("ERROR: You must override _on_impact in all children of bullet.tscn!")
	push_error("ERROR: You must override _on_impact in all children of bullet.tscn!")
	push_error("ERROR: You must override _on_impact in all children of bullet.tscn!")
	push_error("ERROR: You must override _on_impact in all children of bullet.tscn!")
	push_error("ERROR: You must override _on_impact in all children of bullet.tscn!")
	push_error("ERROR: You must override _on_impact in all children of bullet.tscn!")
	push_error("ERROR: You must override _on_impact in all children of bullet.tscn!")
	push_error("ERROR: You must override _on_impact in all children of bullet.tscn!")
	push_error("ERROR: You must override _on_impact in all children of bullet.tscn!")
	push_error("ERROR: You must override _on_impact in all children of bullet.tscn!")
	push_error("ERROR: You must override _on_impact in all children of bullet.tscn!")
	
