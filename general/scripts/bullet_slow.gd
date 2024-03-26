extends Node2D

const SPEED : float = 100.0 #units per second
var actorData : ActorData
var aim_vector : Vector2
var time_alive : float = 0 #in seconds

func explicit_init(shooter_IN, aim_vector_IN:Vector2):
	actorData = ActorData.new(
		1,
		shooter_IN.actorData.team,
		shooter_IN.actorData.weapon_type,
		1
	)
	aim_vector = aim_vector_IN

func _process(delta):
	time_alive += delta
	position += aim_vector * SPEED * delta
	if time_alive > 6:
		queue_free()

func hit_something():
	queue_free()
