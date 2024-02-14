extends Node

var player #Player will put itself here when it spawns.
var current_level #Level will put itself here when it spawns.
#Music player
var music_player = AudioStreamPlayer.new()
var current_music_name # In case we ever care what's playing.
var music_dictionary = {
	# Paths for all music files
	"level_0" : "res://assets/music/noattrib_PandaBeats_PixelParty.wav",
	"boss_0" : "res://assets/music/PH_NeXsard_NotDeadYet_Shrek_Boss.mp3",
	"boss_0_death" : "res://assets/music/PH_Shrek_Death_Music.mp3",
	"player_death" : "res://assets/music/PH_player_death_music.mp3"
}

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(music_player)
	# TODO: When we have a default level, like a main menu or whatever, THAT
	# will load levels instead of just loading one here in Global._ready()
	change_level(preload("res://scene_levels/level_0.tscn"))

func change_level(preloaded_level):
	if(current_level):
		current_level.queue_free()
	current_level = preloaded_level.instantiate()
	add_child(current_level)

func play_music_name(music_name):
	# By making this a stream instead of a path, we can load the music during level loading.
	var new_stream = load(Global.music_dictionary[music_name])
	music_player.stream = new_stream
	music_player.play()
