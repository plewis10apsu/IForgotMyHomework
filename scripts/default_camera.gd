extends Camera2D

const y_margin = 30
var new_x
var new_y
var player_ammo

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.boss_hp_bar = $BossHP


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#Follow player
	if(Global.Player):
		if Global.Player.is_alive:
			#Camera follow player
			new_x = Global.Player.position.x
			new_y = clamp(position.y, Global.Player.position.y - y_margin, Global.Player.position.y + y_margin)
			position = Vector2(new_x,new_y)
			#HUD HP
			$HUD_HP.text = "HP: " + str(Global.Player.hp)
		else:
			$HUD_HP.text = "Well, that's just embarrassing."
		#HUD ammo
		player_ammo = Global.Player.machine_gun_ammo #Limits us to 1 fetch.
		if(player_ammo):
			$HUD_Ammo.text = "AMMO: " + str(player_ammo)
		else:
			$HUD_Ammo.text = ""
