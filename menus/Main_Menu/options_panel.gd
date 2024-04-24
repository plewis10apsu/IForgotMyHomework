extends Panel


# Called when the node enters the scene tree for the first time.
func _ready():
	$MarginContainer/VBoxContainer/VBoxContainer/SoundFXCheckButton.button_pressed = !Global.sfx_muted


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_sound_fx_check_button_toggled(toggled_on):
	if toggled_on:
		Global.unmute_sfx()
		print("unmuted sound effects")
	else:
		Global.mute_sfx()
		print("muted sound effects")



func _on_music_check_button_toggled(toggled_on):
	Global.set_allow_music(toggled_on);
