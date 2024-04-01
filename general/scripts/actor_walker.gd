extends CharacterBody2D

@export var turns_at_ledges = true
var actorData : ActorData
var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")

# Called when the node enters the scene tree for the first time.
func _ready():
	actorData = ActorData.new(1, TEAM.ENEMY, WEAPON.NONE, 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if actorData.hp <= 0:	
		#DIE
		queue_free()

func _physics_process(delta):
	velocity.y += gravity * delta
	move_and_slide()

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
