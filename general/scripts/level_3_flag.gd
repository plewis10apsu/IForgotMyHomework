extends Node2D

var actorData : ActorData
var label : Label
var level_is_ending : bool = false
var cheat_ended : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	actorData = ActorData.new(999, TEAM.PLAYER, WEAPON.NONE, 0)
	label = $Label
	label.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_key_pressed(KEY_END) and Global.cheats_enabled and !cheat_ended:
		cheat_ended = true
		end_level()
	if label.visible:
		label.text = "Final score:\n" + Global.get_current_score_as_string()

func _on_area_2d_area_entered(area):
	if !level_is_ending:
		print(area.get_parent())
		if area.get_parent() == Global.player:
			end_level()

func end_level():
	level_is_ending = true
	#NOTE(Jim): Wrapped this in a function for the cheat button.
	#Global.player.state = PLAYERSTATE.DEAD
	var timer = Timer.new()
	add_child(timer)
	label.visible = true
	timer.wait_time = 5
	timer.timeout.connect(func ():
		Global.submit_score_and_reset()
		$"../TransitionsLayer/Transitions".set_next_animation(true)
	)
	timer.start()
