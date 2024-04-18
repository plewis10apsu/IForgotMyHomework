extends CharacterBody2D

const WALK_SPEED = 20.0 #pixels per second
@export var turns_at_ledges = true
@export var is_facing_right : bool = true
var actorData : ActorData
var position_x_last_frame : float
var is_in_floor_backup : bool = false
var ledge_sensor_overlapping_bodies
var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")

# Called when the node enters the scene tree for the first time.
func _ready():
	actorData = ActorData.new(100, TEAM.ENEMY, WEAPON.NONE, 1)
	position_x_last_frame = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if actorData.hp <= 0:	
		#DIE
		queue_free()

func _physics_process(delta):
	#GRAVITY
	velocity.y += gravity * delta
	#MOVE AND TURN AROUND
	if(is_on_floor()):
		if(position.x == position_x_last_frame):
			#We haven't moved, so we're against a wall. Flip!
			flip()
		if(!$AnimatedSprite2D/LedgeSensor.get_overlapping_bodies().size()):
			#We're at a ledge, and we turn at ledges. Flip!
			flip()
		#Move
		velocity.x = WALK_SPEED * (1 if is_facing_right else (-1))
		position_x_last_frame = position.x
	else:
		position_x_last_frame = 0 #Zeroing this out is a hacky way to avoid detecting x stillness while airborn
	#for o in ledge_sensor_overlapping_bodies:
		#print(o)
	move_and_slide()

func flip():
	if is_facing_right:
		#Switch to left
		is_facing_right = false
		print("R->L Scale before flip: " + str(scale.y))
		$AnimatedSprite2D.scale.x = abs($AnimatedSprite2D.scale.x) * (-1)
		print("R->L Scale after flip: " + str(scale.y))
	else:##not right yet
		#Switch to right
		is_facing_right = true
		print("L->R Scale before flip: " + str(scale.y))
		$AnimatedSprite2D.scale.x = abs($AnimatedSprite2D.scale.x)
		print("L->R Scale after flip: " + str(scale.y))

func _on_area_2d_area_entered(area):
	var other = area.get_parent()
	print("WALKER OVERLAPPED AREA: " + str(other))
	var is_friendly = (actorData.team == other.actorData.team)
	var is_hazardous_actor
	if(other.actorData != null) and other.actorData.hazard_level>0:
		is_hazardous_actor = true
	else:
		is_hazardous_actor = false
	if is_hazardous_actor and !is_friendly:
		#HIT!
		actorData.hp -= other.actorData.hazard_level
		other.hit_something()

func hit_something():
	pass

func _on_area_2d_2_area_exited(area):
	#print("SENSOR EXITED AREA!!!")
	#is_facing_right = !is_facing_right
	pass

func _on_area_2d_2_body_exited(body):
	pass # Replace with function body.

func _on_ledge_sensor_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	pass # Replace with function body.
