extends Node2D

var actorData : ActorData
var health_up : int = 1 # How much health to give the play on pick up

func _ready():
	actorData = ActorData.new(1, TEAM.POWER_UP, WEAPON.NONE, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass