class_name Player extends CharacterBody2D

signal laser_shot(laser_scene, location)
signal killed

@export var speed = 300 #Player movement speed
@export var rate_of_fire = 0.25
@onready var muzzle = $Muzzle

var laser_scene = preload("res://level_2/SpaceShooterLevel/scenes/laser.tscn")
var shoot_cd := false

const HP_MAX : int = 5
const HURT_BLINK_RATE_MS : int = 30 #ms until hurt visibility toggles
const HURT_BLINK_DURATION_MS : int = 1500 #ms player will be invincible after being hurt
var hp : int = HP_MAX
var invincible_timer_ms : int = 0 #set this=n to blink + be invincible for n miliseconds
@onready var actorData : ActorData = ActorData.new(999, TEAM.PLAYER, WEAPON.BUBBLE_SHIP, 0)

func _ready():
	Global.player = self

func _process(delta):
	if Input.is_action_pressed("shoot"):
		if !shoot_cd:
			shoot_cd = true
			shoot()
			await get_tree().create_timer(rate_of_fire).timeout
			shoot_cd = false
	#Hurtblinking
	invincible_timer_ms = clamp(invincible_timer_ms-int(delta*1000), 0, 999999)
	var its_blink_off_time = bool(invincible_timer_ms%(2*HURT_BLINK_RATE_MS) > HURT_BLINK_RATE_MS)
	$Sprite2D.visible = (false if (invincible_timer_ms>0 and its_blink_off_time) else true)
	$BulletEmitter.shoot(self, Vector2(0,1))

func _physics_process(_delta):
	var direction = Vector2(Input.get_axis("move_left", "move_right"),
	Input.get_axis("move_up", "move_down"))
	velocity = direction * speed
	move_and_slide()
	
	global_position = global_position.clamp(Vector2.ZERO, get_viewport_rect().size)

func shoot():
	laser_shot.emit(laser_scene, muzzle.global_position)

func hurt():
	if !invincible_timer_ms:
		Global.play_sfx_by_name("bop_ouch")
		hp -= 1
		invincible_timer_ms = HURT_BLINK_DURATION_MS
		if hp <= 0:
			die()

func die():
	Global.score = Global.score_at_level_start
	killed.emit()
	queue_free()
