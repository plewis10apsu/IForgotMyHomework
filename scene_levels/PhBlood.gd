extends Sprite2D

const blood_speed = 0.06 #Multiplier. 1 = max in 1 sec.

# Called when the node enters the scene tree for the first time.
func _ready():
	scale.y=0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if visible and scale.y<0.3:
		scale.y = clamp(scale.y + (delta * blood_speed), 0, 1)
