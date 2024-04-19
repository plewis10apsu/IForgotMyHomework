extends Node2D

var actorData : ActorData

# Called when the node enters the scene tree for the first time.
func _ready():
	actorData = ActorData.new(999, TEAM.PLAYER, WEAPON.NONE, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass





func _on_area_2d_area_entered(area):
	print(area.get_parent())
	print("Is area player? "+str(area.get_parent() == Global.player))
	if area.get_parent() == Global.player:
		$sprite.frame = 1
		Global.player.state = PLAYERSTATE.DEAD
		Global.player.visible = false
		var timer = Timer.new()
		add_child(timer)
		timer.wait_time = 2
		timer.timeout.connect(func (): $"../TransitionLayer/Transitions".set_next_animation(true))
		timer.start()
