extends Area2D

@onready var home = position
var is_alive = true
const hp_max = 3
const oscillation_distance = 15
const oscillation_speed_multiplier = 3
var hp = hp_max
var overlapping #array
var new_position
var new_y = 0
var time_alive = 0.0
var hurtwhite = 0.0
var hurtwhite_decay_rate = 4 #decays in 1/n seconds

# Called when the node enters the scene tree for the first time.
func _ready():
	$CollisionPolygon2D/AddcolorPolygon.visible = true
	$CollisionPolygon2D/AddcolorPolygon.modulate.a = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Hurtwhite is also used on death for afterimage
	hurtwhite -= delta*hurtwhite_decay_rate
	hurtwhite = clamp(hurtwhite, 0, 1)
	$CollisionPolygon2D/AddcolorPolygon.modulate.a = hurtwhite
	if is_alive:
		time_alive += delta
		new_y = home.y + sin(time_alive * oscillation_speed_multiplier) * oscillation_distance
		position.y = new_y
		overlapping = get_overlapping_areas()
		for hurty_thing in overlapping:
			hurty_thing.get_parent().queue_free()
			hp -= 1
			hurtwhite = 0.85
			$HurtSound.play()
		if hp <= 0:
			#Die
			is_alive = false
			$DeathSound.play()
			$CollisionPolygon2D/PhUfo.visible = false
			$CollisionPolygon2D/AddcolorPolygon.modulate.a = 0.3
			hurtwhite_decay_rate = 0.8
			hurtwhite = 0.5
	elif !$DeathSound.is_playing():
		queue_free()
