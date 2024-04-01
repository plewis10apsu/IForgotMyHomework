extends Camera2D

enum CameraState { CENTER_MENU, MOVE_TO_OPTIONS }

var target_position = Vector2()
var camera_state = CameraState.CENTER_MENU

# Called when the node enters the scene tree for the first time.
func _ready():
	target_position = position
	target_position.x += 200  # Adjust this offset as needed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match camera_state:
		CameraState.CENTER_MENU:
			center_menu()
		CameraState.MOVE_TO_OPTIONS:
			move_to_options()

# Function to center the menu
func center_menu():
	if position.x < target_position.x:
		position.x += 1

# Function to move to the options menu
func move_to_options():
	# Add logic here to move the camera towards the options menu position
	# For example, you can smoothly interpolate the position over time
	# using lerp or other techniques.
	pass

# Call this function when the button for moving to options is pressed
func on_options_button_pressed():
	# Set the camera state to move towards the options menu
	camera_state = CameraState.MOVE_TO_OPTIONS
	# Set the target_position to the desired position for the options menu
	#target_position.x = /* Set the x-coordinate of the options menu position */
