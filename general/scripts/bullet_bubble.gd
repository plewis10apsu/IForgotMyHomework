extends Node2D

const INIT_LAUNCH : float = 100.0 # Distance in pixels, initial impulse
const SPEED : float = 150 # Pixels per second
const MAX_LIFETIME : float = 3.0
const FRICTION : float = 0.6
var actorData : ActorData
var aim_vector : Vector2
var time_alive : float = 0.0 #in seconds
var rng = RandomNumberGenerator.new()
var prev_position : Vector2 #where this bubble was at the start of the previous frame
var angles : Vector2 # Movement

func explicit_init(shooter_IN, aim_vector_IN:Vector2):
	rng.randomize()
	actorData = ActorData.new(
		1, #HP_MAX
		shooter_IN.actorData.team,
		shooter_IN.actorData.weapon_type,
		1 #hazard_level
	)
	prev_position = position
	aim_vector = aim_vector_IN
	angles.y = atan2(aim_vector.y, aim_vector.x)
	angles.x = angles.y
	prev_position += aim_vector * -1 * INIT_LAUNCH # Initial impulse moving the bubble
	var sprite = $Sprite
	sprite.animation = "default"
	sprite.frame = rng.randi_range(0,sprite.sprite_frames.get_frame_count("default")-3)

func modulus_vector2(vector, bound):
	while vector.x > bound:
		vector.x -= bound
	while vector.x < bound:
		vector.x += bound
	while vector.y > bound:
		vector.y -= bound
	while vector.y < bound:
		vector.y += bound
	return vector
	
func _process(delta):
	time_alive += delta
	if time_alive > MAX_LIFETIME:
		destroy()
	else:
		var velocity = (position - prev_position) 
		prev_position = position #update previous before moving, for use next frame
		
		# Calculate move vector using the angles
		angles.x += rng.randf_range(-PI,PI) * 4 * delta
		angles.y += rng.randf_range(-PI,PI) * 4 * delta
		angles = modulus_vector2(angles, PI*2)
		velocity.x += (cos(angles.y) + cos(angles.x)) * SPEED
		velocity.y += (sin(angles.y) + sin(angles.x)) * SPEED
		velocity *= FRICTION * delta
		# Move
		position += velocity

func hit_something():
	destroy()

func destroy():
	$Sprite.play("pop")
	$Sprite.animation_finished.connect(func(): self.queue_free())
