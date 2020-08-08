extends CSGSphere

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_pressed("light"):
		activate()

func activate():
	print("light activated")
	$LightSphere.show()

func deactivate():
	$LightSphere.hide()

func destroy():
	queue_free()
