extends Node2D

const SPEED = 450
var shoot_vector
const max_lifetime = 0.5 #seconds
var time_alive = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	#When player sprite is flipped, the emitter will be as well.
	if(Global.Player.is_facing_right):
		shoot_vector = Vector2(1, 0).normalized()
	else:
		shoot_vector = Vector2(-1, 0).normalized()
	reparent(Global.player_bullet_parent)
	z_index = 69


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position += shoot_vector * SPEED * delta
	
	time_alive += delta
	if(time_alive >= max_lifetime):
		queue_free()
