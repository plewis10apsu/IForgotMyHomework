extends Polygon2D

# Called when the node enters the scene tree for the first time.
func _ready():
	position = Vector2(0, 0)
	self.polygon = get_parent().polygon
	#self.scale.x = 1
	#self.scale.y = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
