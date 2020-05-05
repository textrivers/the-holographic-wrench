extends Spatial

export var ghost_ID = 0

var ghost_playback = false
var playback_available = false

var current_frame = 0

var data

# Called when the node enters the scene tree for the first time.
func _ready():
	
	Signals.connect("initiate_fun", self, "activate_ghost_playback")
	
	if game_data.ghost_pos_dict.has(ghost_ID):
		data = game_data.ghost_pos_dict[ghost_ID]
		playback_available = true


func _physics_process(delta):
	if ghost_playback == true && data.has(current_frame):
		translation = data[current_frame][0]
		rotation_degrees = data[current_frame][1]
		current_frame += 1
	else:
		if current_frame > 0:
			deactivate_ghost_playback()

func activate_ghost_playback():
	if playback_available == true:
		ghost_playback = true

func deactivate_ghost_playback():
	ghost_playback = false
	self.hide()
