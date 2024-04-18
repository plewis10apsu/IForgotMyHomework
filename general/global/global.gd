extends Node

const MAX_SCORE_DIGITS = 6
var player #Player will put itself here when it spawns.
var current_level #Level will put itself here when it spawns.
var current_level_path = "" #Current scene path
var bullet_parent = Node.new()
var score : int = 0
var high_scores = [000000, 000000, 000000]
#Music player
var music_player = AudioStreamPlayer.new()
var current_music_name # In case we ever care what's playing.
var music_dictionary = {
	# Paths for all music files
	"pixelparty" : "res://general/music/noattrib_PandaBeats_PixelParty.wav"
}

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(music_player)
	add_child(bullet_parent)
	#score = 1234567890
	#submit_score_and_reset()
	#score = 1
	#submit_score_and_reset()
	#print("Player score: " + get_current_score_as_string())
	#print("High score 1: " + get_high_score_as_string(0))
	#print("High score 2: " + get_high_score_as_string(1))
	#print("High score 3: " + get_high_score_as_string(2))

func point_at_player_from(from_node_IN):
	#Creates normalized V2 pointing from argument's position to the player.
	#For shooting, remember to pass the emitter node, NOT the actor's top-level "self".
	return Vector2(player.global_position - from_node_IN.global_position).normalized()

func change_level(level_path):
	# Delete all the bullets
	for b in bullet_parent.get_children():
		b.queue_free()

	# Change scenes
	get_tree().change_scene_to_file(level_path)
	current_level = get_tree().current_scene
	current_level_path = level_path

func reload_current_scene():
	change_level(current_level_path)

func get_current_score_as_string():
	return str( clamped_score(score) ).pad_zeros(MAX_SCORE_DIGITS)

func get_high_score_as_string(i):
	return str( clamped_score(high_scores[i]) ).pad_zeros(MAX_SCORE_DIGITS)


func clamped_score(score_IN):
	#Clamps score to truncate digits exceeding max
	var max_score_value_allowed = (pow(10, MAX_SCORE_DIGITS)) - 1
	return clamp(score_IN, 0, max_score_value_allowed)

func submit_score_and_reset():
	#Starting rank is max highscore index + 1 (AKA length)
	var rank : int = high_scores.size()
	#Iterate over all scores, starting with lowest, and see if we placed.
	var i = high_scores.size() - 1
	while i >= 0:
		if(score > high_scores[i]):
			#The more times this is overridden, the higher our rank.
			#Getting rank 0 means we have a new best score! (Because ranks are indices.)
			rank = i
		i -= 1
	if rank < high_scores.size():
		#We placed! Let's start at the last score and slide everything down.
		i = high_scores.size() - 1 #NOTE(Jim): Notice that we are resetting i for reuse!
		while i > rank:
			#Slide next highest score down to this spot.
			high_scores[i] = high_scores[i-1]
			i -= 1
		#When while loop ends, we have arrived at our rank (which is now stored in i).
		#This rank has already slid down, so we simply need to override it.
		#Again, if rank==0, we have the new best score!
		high_scores[i] = score
	score = 0

func play_music_by_name(music_name):
	# By making this a stream instead of a path, we can load the music during level loading.
	var new_stream = load(Global.music_dictionary[music_name])
	music_player.stream = new_stream
	music_player.play()
