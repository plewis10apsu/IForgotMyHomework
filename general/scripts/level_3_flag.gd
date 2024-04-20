extends Node2D

var actorData : ActorData
var label : Label

# Called when the node enters the scene tree for the first time.
func _ready():
	actorData = ActorData.new(999, TEAM.PLAYER, WEAPON.NONE, 0)
	label = $Label
	label.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if label.visible:
		label.text = "Final score:\n" + Global.get_current_score_as_string()

func _on_area_2d_area_entered(area):
	print(area.get_parent())
	if area.get_parent() == Global.player:
		#Global.player.state = PLAYERSTATE.DEAD
		var timer = Timer.new()
		add_child(timer)
		label.visible = true
		timer.wait_time = 5
		timer.timeout.connect(func ():
			Global.submit_score_and_reset()
			$"../CanvasLayer2/Transitions".set_next_animation(true)
		)
		timer.start()
