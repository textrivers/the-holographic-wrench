extends KinematicBody

## guard patrol script adapted from script found on this video: 
## https://www.youtube.com/watch?v=_urHlep2P84

var path = []
var path_ind = 0
const MOVE_SPEED = 5
onready var nav = get_parent()
var waiting = true

var guard_destinations = []

func _ready():
	Signals.connect("initiate_fun", self, "_on_WaitTimer_timeout")
	randomize()
	guard_destinations = game_data.guard_waypoints

func _physics_process(delta):
	if waiting == true:
		return
	
	## MOVING --------------------
	if path_ind < path.size():
		var move_vec = (path[path_ind] - global_transform.origin)
		if move_vec.length() < 0.1:
			path_ind += 1
		else:
			move_and_slide(move_vec.normalized() * MOVE_SPEED, Vector3(0, 1, 0))
	## WAITING ----------------------
	else:
		$WaitTimer.start()
		waiting = true

func move_to(target_pos):
	path = nav.get_simple_path(global_transform.origin, target_pos)
	path_ind = 0

func _on_WaitTimer_timeout():
	waiting = false
	var new_target_ind = randi() % guard_destinations.size()
	var new_target_pos = guard_destinations[new_target_ind]
	move_to(new_target_pos)
	if $AudioStreamPlayer3D.playing == false:
		$AudioStreamPlayer3D.play()
