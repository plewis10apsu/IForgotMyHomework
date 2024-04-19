extends "res://general/scripts/bullet_bubble.gd"

var hue : float
var initial_hue : float

func explicit_init(shooter_IN, aim_vector_IN:Vector2):
	super(shooter_IN, aim_vector_IN)
	actorData = ActorData.new(
		1, #HP_MAX
		shooter_IN.actorData.team,
		shooter_IN.actorData.weapon_type,
		3 #hazard_level
	)

func _process(delta):
	super(delta)
	modulate = Color.from_hsv(hue,0.65,1)
	hue += 1.5*delta
