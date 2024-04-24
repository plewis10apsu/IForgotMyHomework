extends Node2D

const WALK_SPEED = 20.0 #pixels per second
@export var is_facing_right : bool = true
var actorData : ActorData
var position_x_last_frame : float
var needs_to_blink_white = false
var death_pop_scene = preload("res://general/scenes/death_pop.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	actorData = ActorData.new(25, TEAM.ENEMY, WEAPON.NONE, 1)
	position_x_last_frame = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if actorData.hp <= 0:
		Global.score += 35
		#DIE
		var new_pop = death_pop_scene.instantiate()
		Global.bullet_parent.add_child(new_pop)
		new_pop.global_position = $AnimatedSprite2D.global_position
		new_pop.global_position.y += 2
		queue_free()
	if needs_to_blink_white:
		needs_to_blink_white = false
		$AnimatedSprite2D.modulate = Color(5,5,5,5) #Make it white
	else:
		$AnimatedSprite2D.modulate = Color(1,1,1,1)

func _physics_process(delta):
	#NO GRAVITY
	#Move
	position.x += WALK_SPEED * (1 if is_facing_right else (-1)) * delta

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
