extends Area2D

export var machine_box = false
var pinklit = false
var pinklit_wait = 0.1

func _ready():
	pass # Replace with function body.

func unhighlight():
	if pinklit == false:
		$Box.modulate = Color(0, 0, 0)

func highlight():
	if pinklit == false:
		$Box.modulate = Color(1, 1, 1)

func redlight():
	if pinklit == false:
		$Box.modulate = Color(0.5, 0.1, 0.1)

func pinklight():
	## $Box.modulate = Color(1, 0.13, 0.67)
	pinklit = true
	## wait a short time before unhighlighting
	$PinklitTimer.wait_time = pinklit_wait
	$PinklitTimer.start()

func _on_PinklitTimer_timeout():
	pinklit = false
	unhighlight()
