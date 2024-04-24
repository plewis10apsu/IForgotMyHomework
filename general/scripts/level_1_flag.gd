extends Node2D

var actorData : ActorData
var sprite
var active = false
var cheat_ended : bool = false
@onready var emitter = $BulletEmitter

# Called when the node enters the scene tree for the first time.
func _ready():
	actorData = ActorData.new(999, TEAM.PLAYER, WEAPON.BUBBLE, 0)
	sprite = $sprite

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_key_pressed(KEY_END) and Global.cheats_enabled and !cheat_ended:
		cheat_ended = true
		end_level()
	if active:
		emitter.shoot(self, Vector2(0,1))
		position.y -= 30*delta

func _on_area_2d_area_entered(area):
	print(area.get_parent())
	if area.get_parent() == Global.player:
		end_level()
		
func end_level():
	#NOTE(Jim): Wrapped this in a function for the cheat button.
	Global.player.state = PLAYERSTATE.DEAD
	Global.player.visible = false
	sprite.frame = 2
	var timer = Timer.new()
	active = true
	add_child(timer)
	timer.timeout.connect(func ():
		$"../TransitionsLayer2/Transitions".set_next_animation(true))
	timer.wait_time = 2
	timer.start()
