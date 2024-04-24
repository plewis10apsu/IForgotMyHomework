extends CharacterBody2D

var walk_speed = 20.0 #pixels per second
@export var turns_at_ledges = true
@export var is_facing_right : bool = true
var actorData : ActorData
var position_x_last_frame : float
var is_in_floor_backup : bool = false
var ledge_sensor_overlapping_bodies
var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")
var needs_to_blink_white = false
var death_pop_scene = preload("res://general/scenes/death_pop.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	actorData = ActorData.new(50, TEAM.ENEMY, WEAPON.NONE, 1)
	position_x_last_frame = 0
	if !is_facing_right:
		$AnimatedSprite2D.scale.x = abs($AnimatedSprite2D.scale.x) * (-1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if actorData.hp <= 0:
		Global.score += 50
		#DIE
		var new_pop = death_pop_scene.instantiate()
		Global.bullet_parent.add_child(new_pop)
		new_pop.global_position = $AnimatedSprite2D.global_position
		new_pop.global_position.y += 4
		queue_free()
	if needs_to_blink_white:
		needs_to_blink_white = false
		$AnimatedSprite2D.modulate = Color(5,5,5,5) #Make it white
	else:
		$AnimatedSprite2D.modulate = Color(1,1,1,1)

func _physics_process(delta):
	#GRAVITY
	velocity.y += gravity * delta
	#MOVE AND TURN AROUND
	if(is_on_floor()):
		var hasnt_moved : bool = (position.x == position_x_last_frame)
		var needs_ledge_turn : bool = (turns_at_ledges and !$AnimatedSprite2D/LedgeSensor.get_overlapping_bodies().size())
		if(hasnt_moved or needs_ledge_turn):
			flip()
		#Move
		velocity.x = walk_speed * (1 if is_facing_right else (-1))
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
		$AnimatedSprite2D.scale.x = abs($AnimatedSprite2D.scale.x) * (-1)
	else:##not right yet
		#Switch to right
		is_facing_right = true
		$AnimatedSprite2D.scale.x = abs($AnimatedSprite2D.scale.x)

func _on_area_2d_area_entered(area):
	var other = area.get_parent()
	var is_friendly = (actorData.team == other.actorData.team)
	var is_hazardous_actor
	if(other.actorData != null) and other.actorData.hazard_level>0:
		is_hazardous_actor = true
	else:
		is_hazardous_actor = false
	if is_hazardous_actor and !is_friendly:
		#HIT!
		actorData.hp -= other.actorData.hazard_level
		needs_to_blink_white = true;
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
