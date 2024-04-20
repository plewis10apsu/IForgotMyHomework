class_name Enemy extends Area2D

signal killed(points)
signal hit

@export var speed = 150
@export var hp = 1
@export var points = 100

func _physics_process(delta):
	global_position.y += speed * delta

func die():
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
