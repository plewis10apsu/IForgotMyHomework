extends CharacterBody2D

const JUMP_VELOCITY : float = -500.0 #pixels per frame (Thanks, Godot.)
const COYOTE_TIMER_MAX : float = 0.15 #seconds
const WALK_SPEED : float = 120.0 #units per second
const HURT_BLINK_RATE_MS : int = 30 #ms until hurt visibility toggles
const HURT_BLINK_DURATION_MS : int = 1500 #ms player will be invincible after being hurt
const HOVER_THRUST : float = 1800 #pixels per frame per second
var actorData : ActorData
var move_vector : Vector2 #for platforming movement input
var is_facing_right : bool = true
var is_on_floor_backup : bool = false #BUP we can use in functions other than _physics_process()
var state : int = PLAYERSTATE.PLAY # for _ready() state machine
var coyote_timer : float = COYOTE_TIMER_MAX #sec we can still jump after walking off a ledge
var invincible_timer_ms : int = 0 #set this=n to blink + be invincible for n miliseconds
var trigger_held_timer_ms : int = 0 #miliseconds player has been holding the trigger
var has_shot_this_triggerpull : bool = false #Mostly for limiting single-shot weaps to one shot.
var ms_since_last_shot_this_triggerpull : float = 0.0 #It's a float for accurate conversion from delta.
var ammo : int = 0 #set this whenever you change the weapon type.
var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	#Make sprite face right (Left was default.)
	$Sprite.scale.x = abs($Sprite.scale.x) * -1
	#Set this as the Globally-recognized player
	if(Global.player):
		Global.player.queue_free()
	Global.player = self
	actorData = ActorData.new(3, TEAM.PLAYER, WEAPON.BUBBLE, 0)
	
func _process(delta):
	#Check for death
	if(state != PLAYERSTATE.DEAD and actorData.hp <= 0):
		#KILL PLAYER
		state = PLAYERSTATE.DEAD
		invincible_timer_ms = 0
		#Global.play_music_name("player_death")
	#Timers
	invincible_timer_ms = clamp(invincible_timer_ms-int(delta*1000), 0, 999999)
	#Hurt blinking (NOTE:(Jim) Feel free to ask me about the math for "its_blink_off_time"!)
	var its_blink_off_time = bool(invincible_timer_ms%(2*HURT_BLINK_RATE_MS) > HURT_BLINK_RATE_MS)
	visible = (false if (invincible_timer_ms>0 and its_blink_off_time) else true)
	#Logic state machine
	match state:
		PLAYERSTATE.PLAY:
			#SHOOT
			if Input.is_action_pressed("shoot"):
				trigger_held_timer_ms += delta*1000
				pull_trigger(delta)
			else:
				trigger_held_timer_ms = 0
				has_shot_this_triggerpull = false
				ms_since_last_shot_this_triggerpull = 0.0
		PLAYERSTATE.KNOCKBACK:
			pass
		PLAYERSTATE.DEAD:
			pass

func _physics_process(delta):
	is_on_floor_backup = is_on_floor()
	#Physics state machine
	match state:
		PLAYERSTATE.PLAY:
			#MOVE
			#(Decided not to normalize for now, since vectors like 1,1 make hover feel good.)
			move_vector = Vector2(0,0)
			if Input.is_action_pressed("move_left"):
				move_vector.x -= 1
			if Input.is_action_pressed("move_right"):
				move_vector.x += 1
			if Input.is_action_pressed("move_up"):
				move_vector.y -= 1
			if Input.is_action_pressed("move_down"):
				move_vector.y += 1
			if move_vector.x:
				#Movement input is non-neutral. Apply it (unless we're Bass-stopping).
				if Input.is_action_pressed("bass_stop"):
					velocity.x = 0
				else:
					velocity.x = move_vector.x * WALK_SPEED
				#Facing left or right?
				if move_vector.x > 0:
					is_facing_right = true
				elif move_vector.x < 0:
					is_facing_right = false
				else:
					#Neutral input, so keep facing same direction.
					pass
				#Flip sprite
				if is_facing_right:
					$Sprite.scale.x = abs($Sprite.scale.x) * (-1)
				else:
					$Sprite.scale.x = abs($Sprite.scale.x)
				#Play the walking animation
				if not $Sprite.is_playing() and is_on_floor():
					$Sprite.frame = 1
					$Sprite.play("default")
				if Input.is_action_pressed("bass_stop"):
					$Sprite.stop()
					$Sprite.frame = 0
			else:
				#Neutral movement input. Velocity decays.
				velocity.x = move_toward(velocity.x, 0, WALK_SPEED)
				#Stop the walking animation
				$Sprite.stop()
				$Sprite.frame = 0
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
			if not is_jumping and not is_on_floor():
				# The player is falling, so stop the walking animation
				$Sprite.stop()
				$Sprite.frame = 0
			if(is_jumping):
				#Gravity is doubled while rising, for a snappy jump.
				velocity.y += gravity * delta * 2
				#The player is rising, so stop the walking animation
				$Sprite.stop()
				$Sprite.frame = 1
			else:
				velocity.y += gravity * delta
			#EXTRA
			if Input.is_action_just_pressed("cheat"):
				actorData.hp += 3
			#PHYSICS BLACK BOX
			move_and_slide()
		PLAYERSTATE.KNOCKBACK:
			#PHYSICS BLACK BOX
			move_and_slide()
		PLAYERSTATE.DEAD:
			pass

func pull_trigger(delta):
	ms_since_last_shot_this_triggerpull += delta*1000 #(converting delta sec to ms)
	match actorData.weapon_type:
		WEAPON.DEFAULT:
			if !has_shot_this_triggerpull:
				var aim_vector = (Vector2.RIGHT if is_facing_right else Vector2.LEFT)
				$BulletEmitter.shoot(self, aim_vector)
				has_shot_this_triggerpull = true
				ms_since_last_shot_this_triggerpull = 0
		WEAPON.SLOW:
			if !has_shot_this_triggerpull:
				var aim_vector = (Vector2.RIGHT if is_facing_right else Vector2.LEFT)
				$BulletEmitter.shoot(self, aim_vector)
				has_shot_this_triggerpull = true
				ms_since_last_shot_this_triggerpull = 0
		WEAPON.MG:
			const mg_shoot_interval_ms = 75 #ms between shots
			if ms_since_last_shot_this_triggerpull > mg_shoot_interval_ms:
				var aim_vector = (Vector2.RIGHT if is_facing_right else Vector2.LEFT)
				$BulletEmitter.shoot(self, aim_vector)
				has_shot_this_triggerpull = true
				ms_since_last_shot_this_triggerpull = 0
		WEAPON.MAGNUM:
			const magnum_shoot_delay_ms = 500
			const magnum_blowback_force = 2000
			if !has_shot_this_triggerpull and ms_since_last_shot_this_triggerpull > magnum_shoot_delay_ms:
				var aim_vector = (Vector2.RIGHT if is_facing_right else Vector2.LEFT)
				$BulletEmitter.shoot(self, aim_vector)
				velocity.x += aim_vector.x * magnum_blowback_force * (-1)
				has_shot_this_triggerpull = true
				ms_since_last_shot_this_triggerpull = 0
		WEAPON.FLAME:
			const ft_shoot_interval_ms = 50 #ms between shots
			if ms_since_last_shot_this_triggerpull > ft_shoot_interval_ms:
				var aim_vector = Vector2(1 if is_facing_right else (-1), -0.2).normalized()
				$BulletEmitter.shoot(self, aim_vector)
				has_shot_this_triggerpull = true
				ms_since_last_shot_this_triggerpull = 0
		WEAPON.BUBBLE:
			const bubble_shoot_interval_ms = 15 #ms between shots
			if ms_since_last_shot_this_triggerpull > bubble_shoot_interval_ms:
				var aim_vector
				var walking_influence_vector #Increases horizontal aim angle while walking
				if move_vector.x or move_vector.y:
					if Input.is_action_pressed("bass_stop"):
						walking_influence_vector = Vector2(0,0)
					else:
						walking_influence_vector = Vector2(move_vector.x, 0)
					#There ismovement this frame. Aim with it.
					aim_vector = (move_vector + walking_influence_vector).normalized()
				else:
					#No movement this frame. Aim with player's L/R facing direction.
					aim_vector = (Vector2.RIGHT if is_facing_right else Vector2.LEFT)
				$BulletEmitter.shoot(self, aim_vector)
				has_shot_this_triggerpull = true
				ms_since_last_shot_this_triggerpull = 0
			#THRUST! (Chicken Run reference.)
			if !is_on_floor_backup and move_vector.y>0 and velocity.y>=0:
				velocity.y += move_vector.y * HOVER_THRUST * (-1) * delta

func _on_area_2d_area_entered(area):
	var other = area.get_parent()
	#print("PLAYER OVERLAPPED AREA: " + str(other))
	var is_friendly = ("actorData" in other) and (actorData.team == other.actorData.team)
	var is_hazardous_actor
	if ("actorData" in other) and other.actorData.hazard_level>0:
		is_hazardous_actor = true
	else:
		is_hazardous_actor = false
	if is_hazardous_actor and !is_friendly:
		#HIT!
		invincible_timer_ms = HURT_BLINK_DURATION_MS
		actorData.hp -= other.actorData.hazard_level
		other.hit_something()
