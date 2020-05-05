extends CSGSphere

var disappear_frame
var current_frame
var game_in_progress = false
var parent_box

# Called when the node enters the scene tree for the first time.
func _ready():
	parent_box = get_node("..")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
