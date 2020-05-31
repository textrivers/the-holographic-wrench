extends Node2D


var counter = 0
var wrap = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	counter = counter % 4
	wrap = (counter + 2) % 4
	
	if Input.is_action_just_pressed("interact"):
		print("counter = " + str(counter) + "; wrap = " + str(wrap))
		counter += 1
		
