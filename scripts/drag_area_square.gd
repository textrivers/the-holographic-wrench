extends Area2D

export var machine_box = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func unhighlight():
	$Box.modulate = Color(0, 0, 0)

func highlight():
	$Box.modulate = Color(1, 1, 1)

func redlight():
	$Box.modulate = Color(0.5, 0.1, 0.1)
