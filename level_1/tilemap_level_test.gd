extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.play_music_by_name_plus_volume("gameboy_girl", -6)
