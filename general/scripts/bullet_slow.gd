extends Area2D

const SPEED = 100 #units per second
var team
var aim_vector : Vector2
var weapon_type
var time_alive = 0 #in seconds
var damage_on_touch = 1

func explicit_init(shooter_IN, aim_vector_IN:Vector2):
	team = shooter_IN.team
	weapon_type = shooter_IN.weapon_type
	aim_vector = aim_vector_IN

func _process(delta):
	time_alive += delta
	position += aim_vector * SPEED * delta
	if time_alive > 6:
		queue_free()