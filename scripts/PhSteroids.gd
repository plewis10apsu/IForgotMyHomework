extends Sprite2D

var overlapping
var has_been_taken = false
var self_destruct_timer = 0 #Set this to n to free/destroy in n seconds.

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#overlapping = $Area2D.get_overlapping_areas()
	overlapping = $Area2D.get_overlapping_bodies()
	for hopefully_player in overlapping:
		Global.player.has_machine_gun = true
		Global.player.machine_gun_ammo = 100
		$Area2D/CollisionShape2D.disabled = true
		$PowerUpSound.play()
		visible = false
		has_been_taken = true
		self_destruct_timer = 3
		break #Just one iteration is enough.
	if self_destruct_timer > 0:
		self_destruct_timer -= delta
		if self_destruct_timer <= 0:
			queue_free()
