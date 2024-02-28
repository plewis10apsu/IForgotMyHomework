extends CharacterBody2D

const MAX_HP = 3
const JUMP_VELOCITY = -500.0
const COYOTE_TIMER_MAX = 0.15 #seconds
const WALK_SPEED = 120.0 #units per second
const HURT_BLINK_RATE = 30 #miliseconds between hurt visibility toggles
var state = ACTORSTATE.PLAY
var team = TEAM.PLAYER
var weapon_type = WEAPON.DEFAULT
var hp = MAX_HP
var is_facing_right = true
var coyote_timer = COYOTE_TIMER_MAX
var invincible_timer_ms = 0 #set to n = invincible and blink for n miliseconds
var trigger_held_timer_ms = 0 #miliseconds player has been holding the trigger
var shots_since_trigger_held = 0 #used for math, like in the MG trigger pull logic
var ammo = 0 #set this whenever you change the weapon type.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	#Set this as the Globally-recognized player
	if(Global.player):
		Global.player.queue_free()
	Global.player = self
	
func _process(delta):
	#Check for death
	if(state != ACTORSTATE.DEAD and hp <= 0):
		#KILL PLAYER
		state = ACTORSTATE.DEAD
		invincible_timer_ms = 0
		Global.current_level.clear_player_bullets()
		Global.play_music_name("player_death")
	#Timers
	invincible_timer_ms = clamp(invincible_timer_ms-int(delta*1000), 0, 1)
	#Hurt blinking (NOTE:(Jim) Feel free to ask me about the math for "its_blink_off_time"!)
	var its_blink_off_time = bool(invincible_timer_ms%(2*HURT_BLINK_RATE) > HURT_BLINK_RATE)
	visible = (false if (invincible_timer_ms>0 and its_blink_off_time) else true)
	#Logic state machine
	match state:
		ACTORSTATE.PLAY:
			#SHOOT
			if Input.is_action_pressed("shoot"):
				trigger_held_timer_ms += delta*1000
				pull_trigger()
			else:
				trigger_held_timer_ms = 0
				shots_since_trigger_held = 0
		ACTORSTATE.KNOCKBACK:
			pass
		ACTORSTATE.DEAD:
			pass

func _physics_process(delta):
	#Physics state machine
	match state:
		ACTORSTATE.PLAY:
			#MOVE
			var direction = Input.get_axis("ui_left", "ui_right")
			if direction:
				#Movement input is non-neutral. Apply it.
				velocity.x = direction * WALK_SPEED
				#Facing left or right?
				if direction > 0:
					is_facing_right = true
				elif direction < 0:
					is_facing_right = false
				else:
					#Neutral input, so keep facing same direction.
					pass
				#Flip sprite
				##TODO: This only flips the sprite; doesn't change collision!
				if is_facing_right:
					$PhSprite.scale.x = abs($PhSprite.scale.x)
				else:
					$PhSprite.scale.x = abs($PhSprite.scale.x) * (-1)
			else:
				#Neutral movement input. Velocity decays.
				velocity.x = move_toward(velocity.x, 0, WALK_SPEED)
			#COYOTE TIMER
			if is_on_floor():
				#We're on the ground, so refill the timer.
				coyote_timer = COYOTE_TIMER_MAX
			else: 
				#We're in the air, so decrement.
				coyote_timer = clamp(coyote_timer-delta, 0, COYOTE_TIMER_MAX)
			#JUMPING AND GRAVITY
			if Input.is_action_just_pressed("jump") and coyote_timer > 0:
				velocity.y = JUMP_VELOCITY
				coyote_timer = 0
			var is_jumping = velocity.y<0
			if Input.is_action_just_released("jump") and !is_on_floor() and is_jumping:
				#When jump button is released, FALL immediately.
				#Note that velocity.y<0 means we are rising, because UP is negative in Godot.
				velocity.y = 0
			if(is_jumping):
				#Gravity is doubled while rising, for a snappy jump.
				velocity.y += gravity * delta * 2
			else:
				velocity.y += gravity * delta
			#EXTRA
			if Input.is_action_just_pressed("cheat"):
				hp += 3
			#PHYSICS BLACK BOX
			move_and_slide()
		ACTORSTATE.KNOCKBACK:
			#PHYSICS BLACK BOX
			move_and_slide()
		ACTORSTATE.DEAD:
			pass

func pull_trigger():
	match weapon_type:
		WEAPON.DEFAULT:
			if shots_since_trigger_held == 0:
				var aim_vector = (Vector2.RIGHT if is_facing_right else Vector2.LEFT)
				$BulletEmitter.shoot(self, aim_vector)
				shots_since_trigger_held += 1
		WEAPON.MG:
			const mg_shoot_delay_ms = 75 #ms between shots
			var total_shots_allowed = ceil(float(trigger_held_timer_ms)/mg_shoot_delay_ms)
			if shots_since_trigger_held < total_shots_allowed:
				var aim_vector = (Vector2.RIGHT if is_facing_right else Vector2.LEFT)
				$BulletEmitter.shoot(self, aim_vector)
				shots_since_trigger_held += 1
		WEAPON.MAGNUM:
			const magnum_shoot_delay_ms = 500
			const magnum_blowback_force = 2000
			if shots_since_trigger_held == 0 and trigger_held_timer_ms>magnum_shoot_delay_ms:
				var aim_vector = (Vector2.RIGHT if is_facing_right else Vector2.LEFT)
				$BulletEmitter.shoot(self, aim_vector)
				velocity.x += aim_vector.x * magnum_blowback_force * (-1)
				shots_since_trigger_held += 1
		WEAPON.FLAME:
			const ft_shoot_delay_ms = 50 #ms between shots
			var total_shots_allowed = ceil(float(trigger_held_timer_ms)/ft_shoot_delay_ms)
			if shots_since_trigger_held < total_shots_allowed:
				var aim_vector = Vector2(1 if is_facing_right else (-1), -0.2).normalized()
				$BulletEmitter.shoot(self, aim_vector)
				shots_since_trigger_held += 1

func _on_area_2d_area_entered(area):
	#TODO:(Jim) Make damage work
	#TODO:(Jim) Make damage work
	#TODO:(Jim) Make damage work
	#print("THAT'S A HIT!")
	#var other_actor = area
	#var other_hurts = other_actor.has("damage_on_touch")
	#var other_is_enemy = other_actor.team != team
	#if  other_hurts and other_is_enemy:
		#hp -= 1
		#invincible_timer_ms = 3000
	#area.queue_free()
	pass
