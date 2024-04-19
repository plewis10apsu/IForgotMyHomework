extends CheckButton

@export var transitions : Transitions



func _on_toggled(button_pressed):
	transitions.set_next_animation(button_pressed)
