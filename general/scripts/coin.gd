extends Node2D

var power_up_type = "coin"
var actorData : ActorData
var initial_position : Vector2
var angle : float

func _ready():
	actorData = ActorData.new(1, TEAM.POWER_UP, WEAPON.NONE, 0)
	initial_position = position
	angle = int(position.x) / 8 * PI / 4

func _process(delta):
	angle += 2.5*delta
	if angle > 2*PI:
		angle -= 2*PI
	position.y = initial_position.y + sin(angle) * 3

func destroy():
	Global.play_sfx_by_name("pick_up_coin")
	queue_free()
