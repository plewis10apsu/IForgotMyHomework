class_name WEAPON

#####################################################################
##  NOTE: Any time you update this list, bullet_emitter.gd and     ##
##  actor_player.gd's pull_trigger() should implement the changes  ##
#####################################################################

enum {NONE, DEFAULT, SLOW, MG, MAGNUM, FLAME, BUBBLE, BUBBLE_RAINBOW}

##NOTE: SLOW is the same as default, but slow so the player can dodge it.
