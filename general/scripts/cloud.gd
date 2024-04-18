extends Node2D

var actorData : ActorData

# Called when the node enters the scene tree for the first time.
func _ready():
	pass#actorData = ActorData.new(1, TEAM.PLAYER, WEAPON.NONE, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x -= 40*delta

func _on_area_2d_hidden():
	queue_free()
