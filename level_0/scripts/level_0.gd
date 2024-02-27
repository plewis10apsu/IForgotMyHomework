extends "res://general/scripts/level_action.gd"

##WARNING:DON'T OVERRIDE _ready()! There is critical functionality in the parent!
#func _ready():

func _ready():
	super._ready()
	Global.play_music_name("level_0")
