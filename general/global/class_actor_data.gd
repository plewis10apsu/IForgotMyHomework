class_name ActorData

var hp : int
var HP_MAX : int
var team : int
var weapon_type : int
var hazard_level : int #Amount of damage this does on touches

func _init(HP_MAX_IN, team_IN, weapon_type_IN, hazard_level_IN):
	HP_MAX = HP_MAX_IN
	hp = HP_MAX
	team = team_IN
	weapon_type = weapon_type_IN
	hazard_level = hazard_level_IN
	
