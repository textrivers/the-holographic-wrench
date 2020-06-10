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
	var new_target_ind = randi() % guard_destinations.size()
	translation = guard_destinations[new_target_ind]

func _physics_process(delta):
	## WAITING ------------------------
	if waiting == true:
		return
	
	## MOVING --------------------
	if path_ind < path.size():
		var move_vec = (path[path_ind] - global_transform.origin)
		if move_vec.length() < 0.1:
			path_ind += 1
		else:
			move_and_slide(move_vec.normalized() * MOVE_SPEED, Vector3(0, 1, 0))
			look_at(path[path_ind], Vector3(0, 1, 0))
			rotation_degrees.x = 0
			rotation_degrees.z = 0
	
	## ARRIVING ----------------------
	else:
		$WaitTimer.start()
		$HumPlayer3D.stop()
		## $ArrivePlayer3D.play()
		waiting = true

func move_to(target_pos):
	if target_pos != null:
		path = nav.get_simple_path(global_transform.origin, target_pos)
	path_ind = 0

func _on_WaitTimer_timeout():
	waiting = false
	var new_dest = get_new_destination()
	move_to(new_dest)
	if $HumPlayer3D.playing == false:
		$HumPlayer3D.play()

func get_new_destination():
	var new_target_ind = randi() % guard_destinations.size()
	var new_target_pos = guard_destinations[new_target_ind]
	if new_target_pos == translation:
		get_new_destination()
	else:
		return new_target_pos
