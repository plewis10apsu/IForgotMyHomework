extends Node2D

const SPEED : float = 750.0 #units per second
const MAX_LIFETIME : float = 5.0
var actorData : ActorData
var aim_vector : Vector2
var time_alive : float = 0.0 #in seconds

func explicit_init(shooter_IN, aim_vector_IN:Vector2):
	actorData = ActorData.new(
		1, #HP_MAX
		shooter_IN.actorData.team,
		shooter_IN.actorData.weapon_type,
		1 #hazard_level
	)
	aim_vector = aim_vector_IN

func _process(delta):
	time_alive += delta
	position += aim_vector * SPEED * delta
	if time_alive > MAX_LIFETIME:
		queue_free()

func hit_something():
	queue_free()
