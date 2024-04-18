extends "res://general/scripts/bullet_bubble.gd"

var hue : float
var initial_hue : float

func explicit_init(shooter_IN, aim_vector_IN:Vector2):
	super(shooter_IN, aim_vector_IN)

func _process(delta):
	super(delta)
	modulate = Color.from_hsv(hue,0.65,1)
	hue += 1.5*delta
