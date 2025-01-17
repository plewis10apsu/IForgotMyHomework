extends Node2D

@export var enemy_scenes: Array[PackedScene] = []
@export var large_enemy_scenes: Array[PackedScene] = []
@onready var player_spawn_pos = $PlayerSpawnPos
@onready var laser_container = $LaserContainer
@onready var timer = $EnemySpawnTimer
@onready var largeTimer = $LargeEnemySpawnTimer
@onready var enemy_container = $EnemyContainer
@onready var hud = $UILayer/HUD
@onready var parallaxB = $ParallaxBackground
@onready var laser_sound = $SFX/LaserSound
@onready var hit_sound = $SFX/HitSound
@onready var explode_sound = $SFX/ExplodeSound

var player = null
var score := 0:
	set(value):
		score = value
		hud.score = score
var high_score
var scroll_speed = 100
var level_timer : Timer

func _ready():
	Global.play_music_by_name_plus_volume("voyage", -6)
	Global.current_level = get_tree().current_scene
	Global.current_level_path = "res://level_2/SpaceShooterLevel/scenes/game.tscn"
	Global.clear_bullets()
	score = Global.score
	player = get_tree().get_first_node_in_group("player")
	assert(player!= null)
	player.global_position = player_spawn_pos.global_position
	player.laser_shot.connect(_on_player_laser_shot)
	player.killed.connect(_on_player_killed)
	
	# Level timer, time until next level is loaded
	level_timer = Timer.new()
	add_child(level_timer)
	level_timer.timeout.connect(func (): $TransitionsLayer/Transitions.set_next_animation(true))
	level_timer.wait_time = 60
	level_timer.start()
	Global.level_timer = level_timer

func _process(delta):
	if Input.is_key_pressed(KEY_END) and Global.cheats_enabled:
		level_timer.wait_time = 0.01
		level_timer.start()
	#NOTE(Jim): ^ Just adding a skip key for debug purposes.
	if timer.wait_time > 0.4:
		timer.wait_time -= delta * 0.009 #Increase/Decrease difficulty
	elif timer.wait_time < 0.4:
		timer.wait_time = 0.4
	
	#
	parallaxB.scroll_offset.y += delta * scroll_speed
	if parallaxB.scroll_offset.y >= 1080:
		parallaxB.scroll_offset.y = 0
	

func _on_player_laser_shot(laser_scene, location):
	var laser = laser_scene.instantiate()
	laser.global_position = location
	laser_container.add_child(laser)
	if !Global.sfx_muted:
		laser_sound.play()

func _on_enemy_spawn_timer_timeout():
	var e = enemy_scenes.pick_random().instantiate() #Create a new instance of an enemy
	# Hacky code warning!
	if e.name == "MedEnemy":
		e.particle_amount = 64
	if e.name == "Enemy":
		e.particle_amount = 32
	e.global_position =  Vector2(randf_range(40,1880),-50) #Random pointing float x value range, y
	e.killed.connect(_on_enemy_killed)
	e.hit.connect(_on_enemy_hit)
	enemy_container.add_child(e) #Add enemy as a child of the scene

func _on_large_enemy_spawn_timer_timeout():
	var largeE = large_enemy_scenes.pick_random().instantiate() #Create a new instance of an enemy
	largeE.particle_amount = 128
	largeE.global_position =  Vector2(randf_range(40,1880),-270) #Random pointing float x value range, y
	largeE.killed.connect(_on_enemy_killed)
	largeE.hit.connect(_on_enemy_hit)
	enemy_container.add_child(largeE) #Add enemy as a child of the scene


func _on_enemy_killed(points):
	if !Global.sfx_muted:
		hit_sound.play()
	#score += points
	#if score > high_score:
		#high_score = score
	Global.score += points

func _on_enemy_hit():
	if !Global.sfx_muted:
		hit_sound.play()

func _on_player_killed():
	if !Global.sfx_muted:
		explode_sound.play()
	Global.reload_current_scene()
