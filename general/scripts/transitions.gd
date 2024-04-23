class_name Transitions extends Control

@export var scene_switch_anim : String = "fade_out" 
@export var scene_to_load : PackedScene 

@onready var animation_tex : TextureRect = $TextureRect
@onready var animation_player : AnimationPlayer = $AnimationPlayer


func _ready():
	pass

func set_next_animation(fading_out : bool):
	animation_tex.visible = true
	if(fading_out):
		animation_player.queue("fade_out")
	else:
		animation_player.queue("fade_in")
	animation_player.play()


func _on_animation_player_animation_finished(anim_name):
	if(scene_to_load != null && scene_switch_anim == anim_name):
		Global.current_level_path = scene_to_load.resource_path
		Global.score_at_level_start = Global.score
		#NOTE(Jim): ^ Normally, we would update score_at_level_start and
		#current_level_path by using Global.change_level(), but I'm putting
		#these here to minimize the amount of other people's code I have to
		#change to fix these bugs.
		get_tree().change_scene_to_packed(scene_to_load)
	animation_tex.visible = false
