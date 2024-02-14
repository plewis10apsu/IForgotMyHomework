extends Node

var Player
var CurrentLevel
var CurrentMusic
var enemy_bullet_parent = Node.new()
var player_bullet_parent = Node.new()
var boss_hp_bar
var destroy_timer_scene = load("res://scene_entities/destroy_timer.tscn")
var new_destroy_timer

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(enemy_bullet_parent)
	add_child(player_bullet_parent)

func level_start(new_level):
	#Each level scene will call this at the start of its script.
	#Level must pass itself as an argument.
	clear_enemy_bullets()
	Global.CurrentLevel = new_level

func play_music(new_music):
	if(CurrentMusic):
		CurrentMusic.stop()
		CurrentMusic.queue_free()
	new_music.reparent(Global)
	new_music.play()
	CurrentMusic = new_music

func clear_enemy_bullets():
	var bullets = enemy_bullet_parent.get_children()
	for now_bullet in bullets:
		now_bullet.queue_free()
		
func clear_player_bullets():
	var bullets = player_bullet_parent.get_children()
	for now_bullet in bullets:
		now_bullet.queue_free()

func self_destruct(target, seconds_in):
	new_destroy_timer = destroy_timer_scene.instantiate()
	new_destroy_timer.reparent(target)
	new_destroy_timer.seconds_remaining = seconds_in
