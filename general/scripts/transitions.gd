class_name Transitions extends Control

@export var scene_switch_anim : String = "fade_out" 
@export var scene_to_load : PackedScene 

@onready var animation_tex : TextureRect = $TextureRect
@onready var animation_player : AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	
	if animation_tex:
		animation_tex.visible = false
	animation_player.queue("fade_in")


func set_next_animation(fading_out : bool):
	animation_tex.visible = true
	if(fading_out):
		animation_player.queue("fade_out")
	else:
		animation_player.queue("fade_in")
	animation_player.play()


func _on_animation_player_animation_finished(anim_name):
	if(scene_to_load != null && scene_switch_anim == anim_name):
		get_tree().change_scene_to_packed(scene_to_load)
	animation_tex.visible = false
