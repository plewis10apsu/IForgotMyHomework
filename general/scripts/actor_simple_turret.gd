extends Node2D

const shoot_interval = 2 #seconds
var time_until_shoot = shoot_interval
var shoot_progress = 0.0 #Normalized 0~1
var new_lightness = 0.0 #0~255, based on interval progress
var actorData : ActorData
var new_bullet
var shots = 0
const max_shots = 10
var distance_from_player
const active_radius = 200 #Unit proximity from player required to be active

func _ready():
	actorData = ActorData.new(3, TEAM.ENEMY, WEAPON.SLOW, 0)

func _process(delta):
	#Handle shoot timer
	time_until_shoot = clamp(time_until_shoot-delta, 0, shoot_interval)
	shoot_progress = 1 - float(time_until_shoot) / shoot_interval
	#Handle color
	new_lightness = shoot_progress * 255
	$EmitterShape.color = Color(shoot_progress, shoot_progress, shoot_progress)
	#Handle shooting
	if time_until_shoot <= 0:
		#We're gonna try to shoot now, so reset shoot time.
		time_until_shoot = shoot_interval
		distance_from_player = Vector2(position - Global.player.position).length()
		#Make a bullet
		var aim_vector = Global.point_at_player_from($BulletEmitter)
		$BulletEmitter.shoot(self, aim_vector)
		#$BulletEmitter.shoot(self, Vector2.LEFT)
		shots+=1
	#Free/destroy
	if(shots>=max_shots):
		queue_free()
