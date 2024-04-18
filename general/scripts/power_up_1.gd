extends Node2D

var actorData : ActorData

func _ready():
	actorData = ActorData.new(1, TEAM.POWER_UP, WEAPON.NONE, 1)
	
func hit_something():
	pass
