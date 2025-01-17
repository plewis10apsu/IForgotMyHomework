extends Node2D

var actorData : ActorData
var hue : float
var power_up_type = "rainbow"

func _ready():
	actorData = ActorData.new(1, TEAM.POWER_UP, WEAPON.NONE, 0)
	hue = 0

func _process(delta):
	hue += 0.5*delta
	if hue > 1:
		hue -= 1
	$Sprite2D.modulate = Color.from_hsv(hue, 0.8, 1.0)

func hit_something():
	pass

func destroy():
	Global.play_sfx_by_name("heart_up")
	queue_free()
