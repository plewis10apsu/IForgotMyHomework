extends Node

var seconds_remaining = 0 #set this to n to destroy parent in n seconds.

func _ready():
	print("Timer ready.")
	
func _process(delta):
	print(seconds_remaining)
	if(seconds_remaining > 0):
		#Timer is ticking.
		seconds_remaining -= delta
		if(seconds_remaining <= 0):
			#Time's up!
			get_parent().queue_free()
