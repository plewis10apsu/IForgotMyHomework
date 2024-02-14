extends Area2D

var overlapping: Array = []
var was_hurt_from_right

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Handle collisions
	overlapping = get_overlapping_areas()
	for hurty_thing in overlapping:
		Global.Player.push_hurt(hurty_thing)
		break #Just 1 damage per frame, please.
