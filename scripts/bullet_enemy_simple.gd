extends Node2D

var VectorTowardPlayer
const SPEED = 100
const max_lifetime = 5 #seconds
const blink_delay = 2
var blink_colors={#Dictionary for easy color flipping
	true: Color.YELLOW,
	false: Color.GOLDENROD
}
var is_blink_on = true
var blink_counter = blink_delay
var time_alive = 0.0

#The player needs to exist for _ready() to succeed, so  
#avoid having a bullet in level space before runtime.
func _ready():
	#Create a normalized Vector2, toward player.
	VectorTowardPlayer = Vector2(Global.Player.global_position - self.global_position).normalized()
	#Reparent to designated parent in Global, so bullet
	#doesn't also vanish if turret is destroyed.
	reparent(Global.enemy_bullet_parent)
	#Draw bullet on top layer.
	z_index = 69

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#Move
	global_position += VectorTowardPlayer * SPEED * delta
	
	#Handle blinking
	blink_counter -= 1
	if(blink_counter <= 0):
		blink_counter = blink_delay #Refill delay counter
		is_blink_on = !is_blink_on #Flip the bool
		$Polygon2D.color = blink_colors[is_blink_on] #Update the color
	
	#Handle lifetime and free/destroy
	time_alive += delta
	if(time_alive >= max_lifetime):
		queue_free()	
