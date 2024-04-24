extends Node2D

var actorData : ActorData

# Called when the node enters the scene tree for the first time.
func _ready():
	actorData = ActorData.new(9999, TEAM.ENVIRONMENT, WEAPON.NONE, 0)

func _on_area_2d_area_entered(area):
	if area.get_parent() == Global.player:
		Global.play_sfx_by_name("secret")
		queue_free()
