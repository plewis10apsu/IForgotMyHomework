extends Sprite2D

const total_frames = 27
const ticks_per_frame = 5
const fps = 30
var time_alive = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_alive += delta*fps
	frame = int(time_alive) % total_frames
