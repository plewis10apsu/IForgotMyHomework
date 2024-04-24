class_name Enemy extends Area2D

signal killed(points)
signal hit

@export var speed = 150
@export var hp = 1
@export var points = 100
@export var particle_amount = 32
var particle_scene = preload("res://level_2/SpaceShooterLevel/scenes/particles.tscn")

func _physics_process(delta):
	global_position.y += speed * delta

func die():
	var particle_instance = particle_scene.instantiate()
	particle_instance.position = position
	$"..".add_child(particle_instance)
	particle_instance.amount = particle_amount
	particle_instance.emitting = true
	particle_instance.finished.connect(func():
		print("YEET")
		queue_free()
	)
	queue_free()
	

func _on_body_entered(body):
	if body is Player:
		body.hurt()
		die()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

#If the enemies hp goes below zero, it dies
func take_damage(amount):
	hp -= amount
	if hp <= 0:
		killed.emit(points)
		die()
	else:
		hit.emit()
