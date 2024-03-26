extends Node2D

const SPEED : float = 400.0 #units per second
var actorData : ActorData
var aim_vector : Vector2
var time_alive : float = 0 #in seconds
var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity") / 2

func _ready():
	$".".velocity += aim_vector * SPEED
	
func explicit_init(shooter_IN, aim_vector_IN:Vector2):
	actorData = ActorData.new(
		1,
		shooter_IN.actorData.team,
		shooter_IN.actorData.weapon_type,
		1
	)
	aim_vector = aim_vector_IN

func _physics_process(delta):
	time_alive += delta
	$".".velocity.y += gravity * delta
	#Stop sliding along ground
	if($".".is_on_floor()):
		$".".velocity.x = 0
	#Prevent sliding up walls
	if($".".velocity.x == 0 and $".".velocity.y < 0):
		$".".velocity.y = 0
	$".".move_and_slide()
	$Polygon2D2.scale.x *= (-1)
	if time_alive > 1:
		queue_free()

func hit_something():
	pass
