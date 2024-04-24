extends Sprite2D

var player_in_area : bool = false
var actorData : ActorData

func _ready():
	actorData = ActorData.new(9999, TEAM.ENVIRONMENT, WEAPON.NONE, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_in_area and Global.level_1_secret_timer > 0 and Input.is_action_pressed("move_down"):
		Global.level_1_secret_timer -= delta
		if Global.level_1_secret_timer <= 0:
			Global.play_sfx_by_name("secret")
			$SecretTiles.queue_free()

func _on_area_2d_area_entered(area):
	if area.get_parent() == Global.player:
		player_in_area = true

func _on_area_2d_area_exited(area):
	if area.get_parent() == Global.player:
		player_in_area = false
