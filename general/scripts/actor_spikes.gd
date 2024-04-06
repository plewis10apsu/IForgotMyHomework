extends Node2D

var actorData : ActorData

func _ready():
	actorData = ActorData.new(999, TEAM.ENEMY, WEAPON.NONE, 1)
	
func hit_something():
	pass
