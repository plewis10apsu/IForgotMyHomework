extends Camera2D


var main_menu_position = Vector2()
var highscore_menu_position = Vector2()




# Called when the node enters the scene tree for the first time.
func _ready():
	main_menu_position = position # Initialize with the camera's starting position
	highscore_menu_position.y = position.y - 1080
	highscore_menu_position.x = position.x

# Function to move the camera
func move_camera(target_position: Vector2):
	var tween = get_tree().create_tween() # Create a new tween using the scene tree
	# Tween the camera's position property to the target position over 1.3 secondS
	tween.tween_property(self, "position", target_position, 1.3).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)

# Function to move to the high score menu
func move_to_highscore():
	move_camera(highscore_menu_position)

func _on_score_button_pressed():
	$"../../../VBoxContainer/HighScore1".text = str(Global.get_high_score_as_string(0))
	$"../../../VBoxContainer/HighScore2".text = str(Global.get_high_score_as_string(1))
	$"../../../VBoxContainer/HighScore3".text = str(Global.get_high_score_as_string(2))
	move_to_highscore()

# Function to move to the main menu menu
func move_to_main_menu():
	move_camera(main_menu_position)

func _on_back_button_pressed():
	move_to_main_menu()
