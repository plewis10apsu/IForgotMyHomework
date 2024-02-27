extends CharacterBody2D

#Identity and stats
const MAX_HP = 3
const JUMP_VELOCITY = -500.0
const COYOTE_TIMER_MAX = 0.15 #seconds
const WALK_SPEED = 120.0 #Units per second
var team = 0
#State and action
enum {STATE_MOVE, STATE_KNOCKBACK, STATE_DEAD}
var state
var hp = MAX_HP
var is_alive = true
var is_facing_right = true
var coyote_timer = COYOTE_TIMER_MAX
var is_being_knocked_back = true
var blink_timer_ms = 0 #set this to n for n miliseconds of blinking I-frames
const blink_rate = 30 #miliseconds until blinking visibility toggles
var bullet_default = load("res://level_0/scenes/bullet_player_default.tscn")
var bullet_mg = load("res://level_0/scenes/bullet_player_mg.tscn")
const machine_gun_shoot_rate = 1.0/20.0 #seconds between shots
var machine_gun_timer = machine_gun_shoot_rate
var has_machine_gun = false
var machine_gun_ammo = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var normal_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var gravity = normal_gravity

func _ready():
	#Set this as the Globally-recognized player
	if(Global.player):
		Global.player.queue_free()
	Global.player = self

func _physics_process(delta):
	machine_gun_timer -= delta
	machine_gun_timer = clamp(machine_gun_timer, 0, machine_gun_shoot_rate)
	if( Input.is_action_just_pressed("cheat") and is_alive):
		hp += 3
		$cheat_sound.play()
	#check for death
	if(is_alive and hp <= 0):
		#kill player
		is_alive = false
		#Free/destroy sprite, hitbox, and audio players
		$hurt_sound.queue_free()
		$CollisionPolygon2D/PhSank.queue_free()
		velocity = Vector2(0,0)
		gravity = normal_gravity/200
		#add_child(load("res://scene_entities/player_death_sprite.tscn").instantiate())#hacky
		#$CollisionPolygon2D.disabled = true
		$CollisionPolygon2D/PhSkel.visible = true
		Global.current_level.clear_player_bullets()
		Global.play_music_name("player_death")
	if is_alive:
		#Determine gravity
		if(velocity.y < 0): #When rising
			gravity = normal_gravity * 2
		else:
			gravity = normal_gravity
		#Add gravity
		if not is_on_floor():
			velocity.y += gravity * delta
			
		#Handle coyote frames
		if is_on_floor():
			if !is_being_knocked_back:
				coyote_timer = COYOTE_TIMER_MAX
			#Player is considered "on floor" for first frame of knockback if hit
			#while on the floor. So, to avoid the knockback bool being flipped off
			#immediately, we simple make it so knockback can't end while rising.
			if(velocity.y >= 0):
				is_being_knocked_back = false
		else: #decrement while in the air
			coyote_timer -= delta
			coyote_timer = clamp(coyote_timer, 0, COYOTE_TIMER_MAX)

		# Handle jump
		if Input.is_action_just_pressed("jump") and coyote_timer > 0:
			#When jump button is pressed, JUMP.
			velocity.y = JUMP_VELOCITY
			coyote_timer = 0
		if Input.is_action_just_released("jump") and velocity.y<0 and !is_on_floor() and !is_being_knocked_back:
			#When jump button is released, FALL immediately.
			#Note that velocity.y<0 means we are rising, because UP is negative in Godot.
			velocity.y = 0

		#Handle movement
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		if(!is_being_knocked_back):#No air control if being knocked back.
			var direction = Input.get_axis("ui_left", "ui_right")
			if direction:
				velocity.x = direction * WALK_SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, WALK_SPEED)
			#Make children face movement direction
			if(direction * $CollisionPolygon2D.scale.x < 0):
				$CollisionPolygon2D.scale.x *= -1
			if($CollisionPolygon2D.scale.x > 0):
				is_facing_right = true
			else:
				is_facing_right = false
		blink_timer_ms -= int(delta*1000)#miniseconds
		blink_timer_ms = clamp(blink_timer_ms, 0, 999999)
		if(blink_timer_ms>0 and blink_timer_ms%(2*blink_rate) > blink_rate):
			self.visible = false
		else:
			self.visible = true
		#Handle shoot
		if Input.is_action_just_pressed("shoot") and !is_being_knocked_back and !has_machine_gun:
			#Default bullet
			$CollisionPolygon2D/PhSank/BulletEmitter.add_child(bullet_default.instantiate())
			$shoot_default.play()
		elif Input.is_action_pressed("shoot") and has_machine_gun and machine_gun_timer <= 0:
			#Machine gun
			$CollisionPolygon2D/PhSank/BulletEmitter.add_child(bullet_mg.instantiate())
			#Refill timer
			machine_gun_timer = machine_gun_shoot_rate
			#Depleat ammo
			machine_gun_ammo -= 1
			if machine_gun_ammo <= 0:
				has_machine_gun = false
			$shoot_mg.play()
	else:
		#Do nothing. You're dead!
		#Low gravity.
		if not is_on_floor():
			velocity.y += gravity * delta
	# Physics black box (Always happens.)
	move_and_slide()
		
	

func push_hurt(hurty_thing):	
	if(!blink_timer_ms and is_alive):#I-frames while blinking!
		hp -= 1
		position.y -= 1
		coyote_timer = 0 #prevent jumping to negate knockback
		is_being_knocked_back = true
		blink_timer_ms = 1500
		
		var was_hurt_from_right = (hurty_thing.global_position.x - Global.player.global_position.x) > 0
		hurty_thing.get_parent().queue_free() #Free/destroy the bullet!
		
		if (was_hurt_from_right):
			velocity = Vector2(-1,-1).normalized() * 300
		else:
			velocity = Vector2(1,-1).normalized() * 300
		
		$hurt_sound.play()
