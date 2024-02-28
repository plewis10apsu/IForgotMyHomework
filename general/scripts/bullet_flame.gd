extends Node2D

const SPEED = 400 #units per second
var team
var aim_vector : Vector2
var weapon_type
var time_alive = 0 #in seconds
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") / 2
var damage_on_touch = 1

func _ready():
	$".".velocity += aim_vector * SPEED
	
func explicit_init(shooter_IN, aim_vector_IN:Vector2):
	team = shooter_IN.team
	weapon_type = shooter_IN.weapon_type
	aim_vector = aim_vector_IN

func _physics_process(delta):
	time_alive += delta
	$".".velocity.y += gravity * delta
	if($".".is_on_floor()):
		$".".velocity.x = 0
	if($".".velocity.x == 0 and $".".velocity.y < 0):
		$".".velocity.y = 0
	$".".move_and_slide()
	$Polygon2D2.scale.x *= (-1)
	if time_alive > 1:
		queue_free()
