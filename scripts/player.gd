extends CharacterBody2D

var is_alive = true
var is_facing_right = true
const max_hp = 3
var hp = max_hp
const SPEED = 120.0
const JUMP_VELOCITY = -500.0
const coyote_frames_max = 10
var coyote_frames = coyote_frames_max
var is_being_knocked_back = true
var blink_timer = 0 #set this to blink for n frames
const blink_rate = 3 #how many frames until a blink
var death_music = load("res://assets/music/player_death_music.tscn")
var bullet_default = load("res://scene_entities/bullet_player_default.tscn")
var bullet_mg = load("res://scene_entities/bullet_player_mg.tscn")
const machine_gun_shoot_rate = 1.0/20.0 #seconds between shots
var machine_gun_timer = machine_gun_shoot_rate
var has_machine_gun = false
var machine_gun_ammo = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var normal_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var gravity = normal_gravity

func _ready():
	Global.Player = self
	#Global.self_destruct(self, 3) #Still not working for some reason.

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
		Global.clear_player_bullets()
		add_child(death_music.instantiate())
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
				coyote_frames = coyote_frames_max
			#Player is considered "on floor" for first frame of knockback if hit
			#while on the floor. So, to avoid the knockback bool being flipped off
			#immediately, we simple make it so knockback can't end while rising.
			if(velocity.y >= 0):
				is_being_knocked_back = false
		else: #decrement while in the air
			coyote_frames -= 1
			coyote_frames = clamp(coyote_frames, 0, coyote_frames_max)

		# Handle jump
		if Input.is_action_just_pressed("jump") and coyote_frames > 0:
			#When jump button is pressed, JUMP.
			velocity.y = JUMP_VELOCITY
			coyote_frames = 0
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
				velocity.x = direction * SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
			#Make children face movement direction
			if(direction * $CollisionPolygon2D.scale.x < 0):
				$CollisionPolygon2D.scale.x *= -1
			if($CollisionPolygon2D.scale.x > 0):
				is_facing_right = true
			else:
				is_facing_right = false
		blink_timer -= 1
		blink_timer = clamp(blink_timer, 0, 999999)
		if(blink_timer%blink_rate == 1):
			$CollisionPolygon2D/PhSank.visible = false
		else:
			$CollisionPolygon2D/PhSank.visible = true
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
	if(!blink_timer and is_alive):#I-frames while blinking!
		hp -= 1
		position.y -= 1
		coyote_frames = 0 #prevent jumping to negate knockback
		is_being_knocked_back = true
		blink_timer = 60
		
		var was_hurt_from_right = (hurty_thing.global_position.x - Global.Player.global_position.x) > 0
		hurty_thing.get_parent().queue_free() #Free/destroy the bullet!
		
		if (was_hurt_from_right):
			velocity = Vector2(-1,-1).normalized() * 300
		else:
			velocity = Vector2(1,-1).normalized() * 300
		
		$hurt_sound.play()
