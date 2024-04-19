extends Node2D
var player
var heart_sprite_list = []
var heart_sprite_positions = []
const max_health_sprites = 5
var position_angle = 0
var rainbow_hue = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	player = $"../.."
	heart_sprite_list.append($heart_1)
	heart_sprite_list.append($heart_2)
	heart_sprite_list.append($heart_3)
	heart_sprite_list.append($heart_4)
	heart_sprite_list.append($heart_5)
	for sprite in heart_sprite_list:
		heart_sprite_positions.append(sprite.position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player_health = player.actorData.hp
	rainbow_hue += 1.0 * delta
	if rainbow_hue > 1:
		rainbow_hue -= 1
	
	position_angle += 6 * delta
	if position_angle > PI * 2:
		position_angle -= 2 * PI
	
	if player != null:
		for i in max_health_sprites:
			var sprite = heart_sprite_list[i]
			if player_health > i:
				sprite.frame = 0 # Full heart
			else:
				sprite.frame = 1 # Empty heart
			if player.powerup == PLATFORMING_POWERUP.RAINBOW:
				sprite.modulate = Color.from_hsv(rainbow_hue, 0.8, 1.5)
				sprite.position.y = heart_sprite_positions[i].y - clampf(sin(position_angle+heart_sprite_positions[i].x), 0, 1)*2
			else:
				sprite.modulate = Color(1,1,1)
				sprite.position = heart_sprite_positions[i]
