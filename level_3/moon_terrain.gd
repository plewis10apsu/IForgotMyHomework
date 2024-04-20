extends CollisionPolygon2D

var visible_polygon

# Called when the node enters the scene tree for the first time.
func _ready():
	visible_polygon = $Polygon2D
	polygon = visible_polygon.polygon

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
