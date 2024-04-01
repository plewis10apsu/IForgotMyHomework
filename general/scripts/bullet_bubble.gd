extends Node2D

const SPEED : float = 100.0 #units per second
const MAX_LIFETIME : float = 0.75
const FRICTION : float = 0.6
var actorData : ActorData
var aim_vector : Vector2
var time_alive : float = 0.0 #in seconds
var rng = RandomNumberGenerator.new()
var prev_position : Vector2 #where this bubble was at the start of the previous frame

func explicit_init(shooter_IN, aim_vector_IN:Vector2):
	actorData = ActorData.new(
		1, #HP_MAX
		shooter_IN.actorData.team,
		shooter_IN.actorData.weapon_type,
		1 #hazard_level
	)
	prev_position = position
	aim_vector = aim_vector_IN

func _process(delta):
	print()
	time_alive += delta
	if time_alive > MAX_LIFETIME:
		queue_free()
	var velocity = (position - prev_position) * FRICTION
	prev_position = position #update previous before moving, for use next frame
	#move
	position += velocity #TODO: Add random noise

func hit_something():
	queue_free()
