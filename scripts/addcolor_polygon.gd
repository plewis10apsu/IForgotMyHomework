extends Polygon2D

# Called when the node enters the scene tree for the first time.
func _ready():
	#Polygons won't be in the right place unless we move them to 0,0
	position = Vector2(0, 0)
	self.polygon = get_parent().polygon
	#self.scale.x = 1
	#self.scale.y = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
