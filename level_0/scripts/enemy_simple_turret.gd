extends Node2D

const shoot_interval = 3 #seconds
var time_until_shoot = shoot_interval
var shoot_interval_progress = 0.0 #Normalized 0~1
var new_lightness = 0.0 #0~255, based on interval progress
var bullet_scene = load("res://general/scenes/bullet_enemy_simple.tscn")
var new_bullet
var shots = 0
const max_shots = 3
var distance_from_player
const active_radius = 200 #Unit proximity from player required to be active

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Handle shoot timer
	time_until_shoot -= delta
	time_until_shoot = clamp(time_until_shoot, 0, shoot_interval)
	shoot_interval_progress = 1 - time_until_shoot / shoot_interval
	#Handle color
	new_lightness = shoot_interval_progress * 255
	$EmitterShape.color = Color(shoot_interval_progress,shoot_interval_progress,shoot_interval_progress)
	#Handle shooting
	if time_until_shoot <= 0:
		#We're gonna try to shoot now, so reset shoot time.
		time_until_shoot = shoot_interval
		distance_from_player = Vector2(position - Global.player.position).length()
		if( distance_from_player <= active_radius and Global.player.is_alive):
			#Make a bullet
			$BulletSpawnPoint.add_child(bullet_scene.instantiate())
			shots+=1
	#Free/destroy
	if(shots>=max_shots):
		queue_free()
