extends CollisionPolygon2D

@export var color: Color
var color_polygon

# Called when the node enters the scene tree for the first time.
func _ready():
	color_polygon = $Polygon2D
	color_polygon.polygon = polygon
	color_polygon.color = color

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
