extends Node2D
var player
var heart_sprite_list = []
var heart_sprite_positions = []
const max_health_sprites = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	player = Global.player
	heart_sprite_list.append($heart_1)
	heart_sprite_list.append($heart_2)
	heart_sprite_list.append($heart_3)
	heart_sprite_list.append($heart_4)
	heart_sprite_list.append($heart_5)
	for sprite in heart_sprite_list:
		heart_sprite_positions.append(sprite.position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player_health = 0
	if Global.player != null:
		player = Global.player
		player_health = player.hp
	
	if player != null:
		for i in max_health_sprites:
			var sprite = heart_sprite_list[i]
			if player_health > i:
				sprite.frame = 0 # Full heart
			else:
				sprite.frame = 1 # Empty heart
