extends CSGSphere

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	## if Input.is_action_just_pressed("light"):
		## activate()
	if $Timer.is_stopped() == false:
		$Light.light_energy = (1 - $Timer.time_left) * 5

func activate():
	$Timer.start()
	$Light.show()
	$AudioStreamPlayer3D.play()

func deactivate():
	$Light.hide()

func destroy():
	queue_free()
