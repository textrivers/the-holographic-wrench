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

func _ready():
	pass

func _process(delta):
	pass
