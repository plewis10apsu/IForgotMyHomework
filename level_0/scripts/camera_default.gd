extends Camera2D

const y_margin = 30
var new_x
var new_y
var player_ammo

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#Follow player
	if(Global.player):
		if Global.player.is_alive:
			#Camera follow player
			new_x = Global.player.position.x
			new_y = clamp(position.y, Global.player.position.y - y_margin, Global.player.position.y + y_margin)
			position = Vector2(new_x,new_y)
			#HUD HP
			$HUD_HP.text = "HP: " + str(Global.player.hp)
		else:
			$HUD_HP.text = "Well, that's just embarrassing."
		#HUD ammo
		player_ammo = Global.player.machine_gun_ammo #Limits us to 1 fetch.
		if(player_ammo):
			$HUD_Ammo.text = "AMMO: " + str(player_ammo)
		else:
			$HUD_Ammo.text = ""
