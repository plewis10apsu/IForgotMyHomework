##TODO: Everything here is just hacky placeholder crap to get the level 0
##prototype boss working. Nuke this from orbit, and build something real!

extends Node2D

const max_hp = 50
var hp = max_hp
const shoot_interval = .5 #seconds
const wait_before_shooting = 4 #seconds after fight begins
var time_until_shoot = 0.0001
var shoot_interval_progress = 0.0 #Normalized 0~1
var new_lightness = 0.0 #0~255, based on interval progress
var bullet_scene = load("res://general/scenes/bullet_enemy_simple.tscn")
var new_bullet
var shots = 0
const max_shots = 25
var distance_from_player
const active_radius = 150 #Unit proximity from player required to be active
var has_fight_begun = false
var time_fighting = 0.0
var overlapping
var hurt_white = 0.0 #normalized 0~1, boss lights up when hurt
const hurt_white_decay_rate = 4 #1 = full decay in 1 second

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Handle hurtwhite
	hurt_white -= hurt_white_decay_rate * delta
	hurt_white = clamp(hurt_white,0,1)
	$HurtwhiteShape.modulate.a = hurt_white
	#Begin fight if player is in radius
	distance_from_player = Vector2(position - Global.player.position).length()
	if( distance_from_player <= active_radius ):
		if !has_fight_begun:
			Global.play_music_name("boss_0")
			$"../DefaultCamera/BossHP".visible=true
			has_fight_begun = true
	if has_fight_begun:
		time_fighting += delta
	#Handle shoot timer
	if time_fighting > wait_before_shooting:
		time_until_shoot -= delta
	time_until_shoot = clamp(time_until_shoot, 0, shoot_interval)
	shoot_interval_progress = 1 - time_until_shoot / shoot_interval
	#Handle color
	new_lightness = shoot_interval_progress * 255
	$EmitterShape.color = Color(shoot_interval_progress,shoot_interval_progress,shoot_interval_progress)
	#Handle shooting
	if time_until_shoot <= 0 and Global.player:
		#We're gonna try to shoot now, so reset shoot time.
		time_until_shoot = shoot_interval
		if( has_fight_begun and Global.player.is_alive):
			#Make a bullet
			$EmitterShape/BulletSpawnPoint.add_child(bullet_scene.instantiate())
			shots+=1
	#Take damage from player
	if(has_fight_begun):
		overlapping = $Hitbox.get_overlapping_areas()
		for hurty_thing in overlapping:
			hurty_thing.get_parent().queue_free()
			hp -= 1
			hurt_white = 1
			$"../DefaultCamera/BossHP".scale.x = 1.0*hp/max_hp
			$pain_sound.play()
			break
	#Free/destroy
	#if(shots>=max_shots and Global.Player.is_alive):
	if( hp <= 0):
		#add_child(death_music.instantiate())
		Global.current_level.clear_enemy_bullets()
		$PhBlood.visible = true
		$PhBlood.reparent(Global.current_level)
		$"../BossPlatform".queue_free()
		Global.play_music_name("boss_0_death")
		queue_free()
