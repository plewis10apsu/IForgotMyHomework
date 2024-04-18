extends Node2D

var actorData : ActorData

const CYCLE_HEIGHT : int = 30 # Pixels
const CYCLE_SPEED : float = 2 # Pi radians per second
var cycle_angle : float = 0
var initial_position : Vector2

func _ready():
	initial_position = position
	actorData = ActorData.new(1, TEAM.PLAYER, WEAPON.NONE, 0)

func _process(delta):
	# Update the angle
	cycle_angle += CYCLE_SPEED * delta
	if cycle_angle > PI*2:
		cycle_angle -= PI*2
	
	# Move the platform!
	position.y = initial_position.y + sin(cycle_angle) * CYCLE_HEIGHT
