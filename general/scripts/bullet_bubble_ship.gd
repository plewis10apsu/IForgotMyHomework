extends "res://general/scripts/bullet_bubble.gd"

func explicit_init(shooter_IN, aim_vector_IN:Vector2):
	super(shooter_IN, aim_vector_IN)
	actorData = ActorData.new(
		1, #HP_MAX
		shooter_IN.actorData.team,
		shooter_IN.actorData.weapon_type,
		2 #hazard_level
	)

func _process(delta):
	super(delta)
	position.y += 300*delta

func play_pop_sound():
	pass
