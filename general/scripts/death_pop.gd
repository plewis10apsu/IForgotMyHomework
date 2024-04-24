extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.play_sfx_by_name("death_pop")
	$AnimatedSprite2D.animation_finished.connect(func(): self.queue_free())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
