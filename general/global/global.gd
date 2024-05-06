extends Node

const MAX_SCORE_DIGITS = 6
var cheats_enabled : bool = true
var player #Player will put itself here when it spawns.
var current_level #Level will put itself here when it spawns.
var current_level_path = "" #Current scene path
var bullet_parent = Node.new()
var score : int = 0
var score_at_level_start : int = 0
var high_scores = [0, 0, 0]
var level_timer : Timer
#Music player
var music_player = AudioStreamPlayer.new()
var current_music_name # In case we ever care what's playing.
var music_dictionary = {
	# Paths for all music files
	"rocks_and_apples" : "res://general/music/noattrib_PandaBeats_Rocks and Apples.wav",
	"voyage" : "res://general/music/noattrib_PandaBeats_Voyage.wav",
	"gameboy_girl" : "res://general/music/noattrib_PandaBeats_Gameboy Girl.wav"
}
var sfx_player_dictionary : Dictionary #Keys will be defined in _ready()
var sfx_player_name_list = []
var sfx_muted : bool = false
var music_is_muted : bool = false
var level_1_secret_timer : float = 3.0

func _ready():
	add_child(music_player)
	add_child(bullet_parent)
	prep_sfx_player("pop", 16, "res://general/sfx/cc0_698818__funky_audio__dsgnsynth_bubble-pops-synth-singular_funky-audio_fass.mp3")
	prep_sfx_player("bop_ouch", 1, "res://general/sfx/cc0_340288__kevinduffy1234_and_404747__owlstorm.mp3")
	prep_sfx_player("death_pop", 8, "res://general/sfx/cc0_703851__ragnar59__bloop-f3.wav")
	sfx_player_dictionary["death_pop"].volume_db = -6
	prep_sfx_player("pop_1", 16, "res://general/sfx/bubble_pop_1.wav")
	prep_sfx_player("pop_2", 16, "res://general/sfx/bubble_pop_2.wav")
	prep_sfx_player("pop_3", 16, "res://general/sfx/bubble_pop_3.wav")
	prep_sfx_player("pop_4", 16, "res://general/sfx/bubble_pop_4.wav")
	prep_sfx_player("pop_5", 16, "res://general/sfx/bubble_pop_5.wav")
	prep_sfx_player("heart_up", 3, "res://general/sfx/heart_up.wav")
	sfx_player_dictionary["heart_up"].volume_db = -8
	prep_sfx_player("pick_up_coin", 16, "res://general/sfx/pick_up_coin.wav")
	sfx_player_dictionary["pick_up_coin"].volume_db = -12
	prep_sfx_player("secret", 1, "res://general/sfx/cc0_jim_and_495004__evretro__alert-video-game-sound.wav")
	sfx_player_dictionary["secret"].volume_db = -2
	read_score()

func prep_sfx_player(sfx_name_IN, max_polyphony_IN, asset_IN):
	sfx_player_dictionary[sfx_name_IN] = AudioStreamPlayer.new()
	sfx_player_dictionary[sfx_name_IN].stream = load(asset_IN)
	sfx_player_dictionary[sfx_name_IN].max_polyphony = max_polyphony_IN
	sfx_player_name_list += [sfx_name_IN]
	add_child(sfx_player_dictionary[sfx_name_IN])

func pause_all_sound():
	if music_player.playing:
		music_player.stream_paused = true
	for key in sfx_player_name_list:
		if sfx_player_dictionary[key].playing:
			sfx_player_dictionary[key].stream_paused = true

func unpause_all_sound():
	if music_player.stream_paused:
		music_player.stream_paused = false
	for key in sfx_player_name_list:
		if sfx_player_dictionary[key].stream_paused:
			sfx_player_dictionary[key].stream_paused = false

func mute_sfx():
	# Set all sfx player volume to -60
	#for key in sfx_player_name_list:
	#	sfx_player_dictionary[key].volume_db = -60.0
	sfx_muted = true

func unmute_sfx():
	# Set all sfx player volume to 0
	#for key in sfx_player_name_list:
	#	sfx_player_dictionary[key].volume_db = 0.0
	sfx_muted = false
	
func set_allow_music(toggled_on):
	music_is_muted = not toggled_on
	if music_is_muted:
		music_player.volume_db = -60
	else:
		music_player.volume_db = 0

func point_at_player_from(from_node_IN):
	#Creates normalized V2 pointing from argument's position to the player.
	#For shooting, remember to pass the emitter node, NOT the actor's top-level "self".
	return Vector2(player.global_position - from_node_IN.global_position).normalized()

func clear_bullets():
	#Deletes all children of the bullet parent
	for b in bullet_parent.get_children():
		b.queue_free()

func change_level(level_path):
	score_at_level_start = score
	# Delete all the bullets
	clear_bullets()
	# Change scenes
	get_tree().change_scene_to_file(level_path)
	current_level = get_tree().current_scene
	current_level_path = level_path

func reload_current_scene():
	change_level(current_level_path)

func get_current_score_as_string():
	return str( get_clamped_score(score) ).pad_zeros(MAX_SCORE_DIGITS)

func get_high_score_as_string(i):
	return str( get_clamped_score(high_scores[i]) ).pad_zeros(MAX_SCORE_DIGITS)
	
func get_clamped_score(score_IN):
	#Clamps score to truncate digits exceeding max
	var max_score_value_allowed = (pow(10, MAX_SCORE_DIGITS)) - 1
	return clamp(score_IN, 0, max_score_value_allowed)

func submit_score_and_reset():
	score_at_level_start = 0
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
	write_score()

func write_score():
	var save_file = FileAccess.open("user://save.data", FileAccess.WRITE)
	save_file.store_var(high_scores)

func read_score():
	var save_file = FileAccess.open("user://save.data", FileAccess.READ)
	var data
	if save_file != null:
		data = save_file.get_var()
		if data != null:
			high_scores = data
	else:
		write_score()

func play_music_by_name(music_name):
	if !music_is_muted:
		# By making this a stream instead of a path, we can load the music during level loading.
		var new_stream = load(Global.music_dictionary[music_name])
		music_player.volume_db = 0
		music_player.stream = new_stream
		music_player.play()

func play_music_by_name_plus_volume(music_name, new_volume):
	play_music_by_name(music_name)
	music_player.volume_db = new_volume

func stop_music():
	music_player.stop()
	
func play_sfx_by_name(sfx_name):
	#if not sfx_player_dictionary[sfx_name].playing:
	if not sfx_muted:
		sfx_player_dictionary[sfx_name].play()
