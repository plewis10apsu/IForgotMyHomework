extends Sprite2D

var original_position : Vector2
const distance : int = 5 # pixels up + down range
const speed : float = 5 # pixels per second
var angle : float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	original_position = position
	angle = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	angle += speed * delta
	if angle > PI * 2:
		angle -= PI * 2
	if angle < 0:
		angle += 2*PI
	position.y = original_position.y + sin(angle) * distance
