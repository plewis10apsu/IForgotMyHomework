extends Node2D

var bullet_dictionary = {
	#Bullet scenes, preloaded and ready to be instantiatated when an actor shoots.
	WEAPON.DEFAULT : "res://general/scenes/bullet_default.tscn",
	WEAPON.SLOW : "res://general/scenes/bullet_slow.tscn",
	WEAPON.MG : "res://general/scenes/bullet_mg.tscn",
	WEAPON.MAGNUM : "res://general/scenes/bullet_magnum.tscn",
	WEAPON.FLAME : "res://general/scenes/bullet_flame.tscn",
	WEAPON.BUBBLE : "res://general/scenes/bullet_bubble.tscn",
	WEAPON.BUBBLE_RAINBOW : "res://general/scenes/bullet_bubble_rainbow.tscn"
}

func shoot(shooter_IN, aim_vector_IN:Vector2):
	var bullet_scene = load(bullet_dictionary[shooter_IN.actorData.weapon_type])
	var new_bullet = bullet_scene.instantiate()
	#OLD# get_tree().root.add_child(new_bullet)
	Global.bullet_parent.add_child(new_bullet)
	new_bullet.global_position = global_position
	new_bullet.explicit_init(shooter_IN, aim_vector_IN)
	if(shooter_IN.actorData.weapon_type == WEAPON.MAGNUM and aim_vector_IN.x<0):
		#Magnum bullets aren't horizontally symetrical. Flip if shooting left.
		new_bullet.scale.x *= (-1)
