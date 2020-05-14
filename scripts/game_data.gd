extends Node

var scene_counter = 1

var ghost_pos_dict = {}

var player_dict = {
	1: "res://scenes/Sarah.tscn",
	2: "res://scenes/Chaplain.tscn",
	3: "res://scenes/Eleni.tscn",
	4: "res://scenes/HR.tscn"
}

var ghost_dict = {
	1: "res://scenes/Sarah_ghost.tscn",
	2: "res://scenes/Chaplain_ghost.tscn",
	3: "res://scenes/Eleni_ghost.tscn",
	4: "res://scenes/HR_ghost.tscn"
}

var all_boxes = []

## items dict fills up with ID numbers as keys, and values consisting of arrays of two frame numbers and one bool
## first frame number is when the front panel is hidden, second when the item is hidden
## bool is whether or not the box has an item inside it
var items_dict = {}

var items_found_counter = 0

var exit_string = ""
var exit_elapsed = 0

var guard_waypoints = [
	## first floor
	Vector3(-12, 1, -14),
	Vector3(0, 1, -12),
	Vector3(15.5, 1, -15.5),
	Vector3(-12, 1, 0),
	Vector3(12, 1, 0),
	Vector3(-15.5, 1, 15.5),
	Vector3(0, 1, 12),
	Vector3(14, 1, 12),
	## second floor
	Vector3(-16, 5, -16),
	Vector3(0, 5, -12),
	Vector3(16, 5, -16),
	Vector3(-12, 5, -4),
	Vector3(-12, 5, 4),
	Vector3(12, 5, -4),
	Vector3(12, 5, 4),
	Vector3(-16, 5, 16),
	Vector3(0, 5, 12),
	Vector3(16, 5, 16),
	## third floor
	Vector3(-16, 9, -16),
	Vector3(0, 9, -12),
	Vector3(16, 9, -16),
	Vector3(-12, 9, -4),
	Vector3(-12, 9, 4),
	Vector3(0, 9, -6),
	Vector3(0, 9, 6),
	Vector3(12, 9, -4),
	Vector3(12, 9, 4),
	Vector3(-16, 9, 16),
	Vector3(0, 9, 12),
	Vector3(16, 9, 16),
]
